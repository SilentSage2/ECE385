module loading( 
				input       Clk,                // 50 MHz clock
                        Reset,              // Active-high reset signal
                        frame_clk,          // The clock indicating a new frame (~60Hz)
				input [9:0] DrawX, DrawY,
				output [4:0] coloridx,
				output load_finish,
				output is_bomb, is_bar_left, is_bar_right, is_loading
				);


parameter [9:0] bomb_X_Center = 10'd40;  // Center position on the X axis
parameter [9:0] bomb_Y_Center = 10'd345;  // Center position on the Y axis
parameter [9:0] bomb_X_Step = 10'd1;     // Step size on the X axis
parameter [9:0] bomb_Size = 10'd10;      // Bomb size

parameter [9:0] bar_X_Min = 10'd30;       // Leftmost point on the X axis
parameter [9:0] bar_X_Max = 10'd610;     // Rightmost point on the X axis
parameter [9:0] bar_Y_Min = 10'd342;       // Leftmost point on the X axis
parameter [9:0] bar_Y_Max = 10'd348;     // Rightmost point on the X axis

logic [9:0] bomb_X_Pos, bomb_Y_Pos;
logic [9:0] bomb_X_Motion, bomb_X_Motion_in;
logic [9:0] bomb_X_Pos_in, bomb_Y_Pos_in;
logic load_finish_in;

logic frame_clk_delayed, frame_clk_rising_edge;

    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
			bomb_X_Pos <= bomb_X_Center;
			bomb_Y_Pos <= bomb_Y_Center;
			bomb_X_Motion <= 10'd0;
			load_finish <= 1'b0;
        end
        else
        begin
            bomb_X_Pos <= bomb_X_Pos_in;
            bomb_Y_Pos <= bomb_Y_Pos_in;
            bomb_X_Motion <= bomb_X_Motion_in;
            load_finish <= load_finish_in;
        end
    end
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        bomb_X_Pos_in = bomb_X_Pos;
        bomb_Y_Pos_in = bomb_Y_Pos;
        bomb_X_Motion_in = bomb_X_Motion;
        load_finish_in = load_finish;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				 
			// TODO: Add other boundary detections and handle keypress here.
				if( bomb_X_Pos + bomb_Size >= bar_X_Max )  // bomb is at the right edge, load finish
				begin
					bomb_X_Motion_in = 10'd0;
					load_finish_in = 1'b1;
				end
				if (bomb_X_Pos + bomb_Size < bar_X_Max)  // bomb is on the way
				begin
					bomb_X_Motion_in = bomb_X_Step;
					load_finish_in = 1'b0;
				end
			// Update the bomb's position with its motion
		  bomb_X_Pos_in = bomb_X_Pos + bomb_X_Motion_in;
		  end
    end

    int DistX, DistY, Size;
    assign DistX = DrawX - bomb_X_Pos;
    assign DistY = DrawY - bomb_Y_Pos;
	 
	logic [5:0] relativeX, relativeY;
   assign Size = 10'd10;
//	logic [5:0] subX, subY;
	assign relativeX = (DrawX - bomb_X_Pos + 10'd10);
	assign relativeY = (DrawY - bomb_Y_Pos + 10'd10);
	small_bomb small_bomb0(.small_bomb_X(relativeX), .small_bomb_Y(relativeY), .small_bomb_color(coloridx));
	 
    always_comb begin
		is_bomb = 1'b0;
		is_bar_right = 1'b0;
		is_bar_left = 1'b0;
      if ( DistX*DistX <= Size*Size && DistY*DistY <= Size*Size && (coloridx!=5'h0))
			is_bomb = 1'b1;
		else if ( DrawX >= bar_X_Min && DrawX < bomb_X_Pos && DrawY >= bar_Y_Min && DrawY <= bar_Y_Max )
			is_bar_left = 1'b1;
		else if ( DrawX >= bomb_X_Pos && DrawX < bar_X_Max && DrawY >= bar_Y_Min && DrawY <= bar_Y_Max )
			is_bar_right = 1'b1;
	 end


parameter [0:11][7:0] loading_array = {8'h4c,8'h6f,8'h61,8'h64,8'h69,8'h6e,8'h67,8'h2e,8'h2e,8'h2e};
parameter [9:0] Xstart = 10'd24;
parameter [9:0] Ystart = 10'd376;
parameter [9:0] Xend = 10'd220;
parameter [9:0] Yend = 10'd392;
//parameter [5:0] size = 6'd16;
logic [10:0] addr;
logic [7:0] data, ascii;
logic [5:0] Xidx;
logic [4:0] subX, subY;
logic [4:0] color;

//calculate addr to get data
assign Xidx = (DrawX - Xstart)/16;
assign subX = (DrawX - Xstart)%16;
//assign subY = DrawY/20 - 5'd2;
assign subY = (DrawY-Ystart)%16;
assign ascii = loading_array[Xidx];
assign addr = ascii*16 + subY;
//must be int, or the substraction will have bug
int data_idx;
assign data_idx = 5'd11-subX;

always_comb 
begin
if (subX < 5'd4 || subX > 5'd11 || DrawY < Ystart || DrawY > Yend || DrawX < Xstart || DrawX > Xend)
	is_loading = 1'b0;
else if(data[data_idx] == 1'b1)
	is_loading = 1'b1;
else
	is_loading = 1'b0;
end

font_rom my_font2(.*);

endmodule

module small_bomb(
					input logic [5:0] small_bomb_X, small_bomb_Y,
					output logic [4:0] small_bomb_color
					);
	parameter[0:400-1][4:0] small_bomb = {
5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h1,5'h3,5'h3,5'h0,5'h3,5'h1,5'h0,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h2,5'h2,5'h1,5'h1,5'h3,5'h1,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h2,5'h2,5'h3,5'h3,5'h1,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h0,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h3,5'h0,5'h2,5'h2,5'h3,5'h0,5'h0,5'h0,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h0,5'h2,5'h2,5'h1,5'h3,5'h1,5'h2,5'h3,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h2,5'h2,5'h3,5'h3,5'h1,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h2,5'h0,5'h3,5'h3,5'h1,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h2,5'h1,5'h3,5'h3,5'h1,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,
5'h0,5'h2,5'h2,5'h2,5'h3,5'h3,5'h1,5'h1,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,
5'h0,5'h2,5'h2,5'h2,5'h3,5'h3,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,
5'h0,5'h2,5'h2,5'h2,5'h1,5'h1,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,
5'h0,5'h2,5'h2,5'h2,5'h0,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,
5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,
5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,
5'h0,5'h0,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h0,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,5'h0,5'h0,5'h0,
5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h2,5'h2,5'h2,5'h2,5'h2,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0,5'h0
};

assign small_bomb_color = small_bomb[small_bomb_Y*20+small_bomb_X];

endmodule



module press_start(
				input [9:0] DrawX, DrawY, cursorX, cursorY,
				input leftButton,
				output is_press_start, is_pressed, is_start_range, click_start
 					);
					
parameter [0:11][7:0] loading_array = {8'h50,8'h52,8'h45,8'h53,8'h53,8'h00,8'h53,8'h54,8'h41,8'h52,8'h54};

parameter [9:0] Xstart = 10'd24;
parameter [9:0] Ystart = 10'd376;
parameter [9:0] Xend = 10'd240;
parameter [9:0] Yend = 10'd392;
//parameter [5:0] size = 6'd16;
logic [10:0] addr;
logic [7:0] data, ascii;
logic [5:0] Xidx;
logic [4:0] subX, subY;
logic [4:0] color;

//calculate addr to get data
assign Xidx = (DrawX - Xstart)/16;
assign subX = (DrawX - Xstart)%16;
//assign subY = DrawY/20 - 5'd2;
assign subY = (DrawY-Ystart)%16;
assign ascii = loading_array[Xidx];
assign addr = ascii*16 + subY;
//must be int, or the substraction will have bug
int data_idx;
assign data_idx = 5'd11-subX;

always_comb 
begin
	is_press_start = 1'b0;//word
	is_start_range = 1'b0;//background
//for is_press_start
if (subX < 5'd4 || subX > 5'd11 || DrawY < Ystart || DrawY > Yend || DrawX < Xstart || DrawX > Xend)
	is_press_start = 1'b0;
else if(data[data_idx] == 1'b1)
	is_press_start = 1'b1;
//for is_start_range
if ( DrawY >= Ystart && DrawY <= Yend && DrawX >= Xstart && DrawX <= Xend - 3)
	is_start_range = 1'b1;

end

font_rom my_font3(.*);

//put on
always_comb 
begin
if (cursorX >= Xstart && cursorX <= Xend && cursorY >= Ystart && cursorY <= Yend)
	is_pressed = 1'b1;
else 
	is_pressed = 1'b0;
end

//click on
always_comb begin 
click_start = 1'b0;
if((leftButton) && (cursorX >= Xstart && cursorX <= Xend && cursorY >= Ystart && cursorY <= Yend)) 
click_start = 1'b1;
end

endmodule

