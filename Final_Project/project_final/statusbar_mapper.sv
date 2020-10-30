module statusbar_mapper(
				input [9:0] DrawX, DrawY,
				input [0:34][7:0]status_array,
				input game_over,
				output [4:0] coloridx_bar);

parameter [9:0] Xstart = 10'd40;
parameter [9:0] Ystart = 10'd22;
parameter [9:0] Xend = 10'd599;
parameter [9:0] Yend = 10'd37;

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
assign ascii = status_array[Xidx];
assign addr = ascii*16 + subY;
//must be int, or the substraction will have bug
int data_idx;
assign data_idx = 5'd11-subX;

always_comb 
begin

if (subX < 5'd4 || subX > 5'd11 || DrawY < Ystart || DrawY > Yend || DrawX < Xstart || DrawX > Xend)
	coloridx_bar = 5'h7;
//else
//	coloridx_bar = 5'h3;
else if(data[data_idx] == 1'b1 && ! game_over)
	coloridx_bar = 5'h3;
else if(data[data_idx] == 1'b1 && game_over )
	coloridx_bar = 5'hb;//blue
else
	coloridx_bar = 5'h7; //bg pink

//if(DrawY < Ystart || DrawY > Yend || DrawX < Xstart || DrawX > Xend)
//	coloridx_bar = 5'h7; //pink
//else
//	coloridx_bar = color;
	
end

font_rom my_font(.*);

endmodule
