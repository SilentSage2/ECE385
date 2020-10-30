//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input 		player_alive,
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [15:0]		keycode, keycode1,
					input [0:12*16-1][3:0] map_array,
					input player_id, protecting, shoe_on,
					input game_over,
               output logic  is_ball,             // Whether current pixel belongs to ball or background
					output logic [4:0] coloridx,
					output [9:0] Ball_X_Pos, Ball_Y_Pos
              );
    
    parameter [9:0] Ball_X1_Center = 10'd20;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd60;  // Center position on the Y axis
	 parameter [9:0] Ball_X2_Center = 10'd620;  // Center position on the X axis
//    parameter [9:0] Ball_Y2_Center = 10'd20;
//    parameter [9:0] Ball_X_initial = X_initial;  // Center position on the X axis
//    parameter [9:0] Ball_Y_initial = Y_initial;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd40;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    logic [9:0] Ball_X_Step, Ball_Y_Step;
	 assign Ball_X_Step = shoe_on ? 10'd4 : 10'd3;     // Step size on the X axis
    assign Ball_Y_Step = shoe_on ? 10'd4 : 10'd3;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd20;        // Ball size

	 parameter [7:0] STOP = 8'd0;               // keycode when no key is pressed 
	
	 logic [5:0] relativeX, relativeY;
    assign Size = 10'd20;
	 //logic [5:0] subX, subY;
	 assign relativeX = (DrawX - Ball_X_Pos + 10'd20);
	 assign relativeY = (DrawY - Ball_Y_Pos + 10'd20);
	 // player gesture
	 logic [4:0] coloridx1_front, coloridx1_left, coloridx1_right, coloridx1_back;
	 logic [4:0] coloridx2_front, coloridx2_left, coloridx2_right, coloridx2_back, hat_color;
	 logic [1:0] aspect;
	 player1_front figure_ins0(.player1_X(relativeX), .player1_Y(relativeY), .player1_color(coloridx1_front));
	 player1_left figure_ins1(.player1_X(relativeX), .player1_Y(relativeY), .player1_color(coloridx1_left));
	 player1_right figure_ins2(.player1_X(relativeX), .player1_Y(relativeY), .player1_color(coloridx1_right));
	 player1_back figure_ins3(.player1_X(relativeX), .player1_Y(relativeY), .player1_color(coloridx1_back));
	 player2_front figure_ins4(.player2_X(relativeX), .player2_Y(relativeY), .player2_color(coloridx2_front));
	 player2_left figure_ins5(.player2_X(relativeX), .player2_Y(relativeY), .player2_color(coloridx2_left));
	 player2_right figure_ins6(.player2_X(relativeX), .player2_Y(relativeY), .player2_color(coloridx2_right));
	 player2_back figure_ins7(.player2_X(relativeX), .player2_Y(relativeY), .player2_color(coloridx2_back));
	 hat hatins(.X(relativeX), .Y(relativeY), .hat_color(hat_color));
	 
	 always_comb
	 begin
		if(player_id == 1'b0)
		begin
			coloridx = coloridx1_front;
			case (aspect)
			2'h0:
			coloridx = coloridx1_back;
			2'h1:
			coloridx = coloridx1_front;
			2'h3:
			coloridx = coloridx1_left;
			2'h2:
			coloridx = coloridx1_right;
			endcase
		end
		
		else	
		begin
			coloridx = coloridx2_front;
			case (aspect)
			2'h0:
			coloridx = coloridx2_back;
			2'h1:
			coloridx = coloridx2_front;
			2'h3:
			coloridx = coloridx2_left;
			2'h2:
			coloridx = coloridx2_right;
		endcase	
		end
		//step onto the hat
		if(protecting && coloridx==0)
			coloridx = hat_color;
	 end
	 
	 // 0: back  1: front  2: right  3: left
	 always_ff @ (posedge Clk) begin
		if (Reset)
			aspect <= 2'b01; //reset to front
		if ((keycode & 16'h00ff) == W || (keycode & 16'hff00)>>8 == W || (keycode1 & 16'h00ff) == W || (keycode1 & 16'hff00)>>8 == W)
			aspect <= 2'h0;
		if ((keycode & 16'h00ff) == S || (keycode & 16'hff00)>>8 == S || (keycode1 & 16'h00ff) == S || (keycode1 & 16'hff00)>>8 == S)
			aspect <= 2'h1;
		if ((keycode & 16'h00ff) == D || (keycode & 16'hff00)>>8 == D || (keycode1 & 16'h00ff) == D || (keycode1 & 16'hff00)>>8 == D)
			aspect <= 2'h2;
		if ((keycode & 16'h00ff) == A || (keycode & 16'hff00)>>8 == A || (keycode1 & 16'h00ff) == A || (keycode1 & 16'hff00)>>8 == A)
			aspect <= 2'h3;
		
	 end
	 
	 // 
	 logic [7:0] W,S,A,D;
	 always_comb
	 begin
		if(player_id == 1'b0)
		begin
			W  = 8'd26;
			S  = 8'd22;
			A  = 8'd4 ;
	      D  = 8'd7 ;
		end
		else	
		begin
			D = 8'd79;    
			A = 8'd80;    
			S = 8'd81 ;
         W = 8'd82 ;  
		end
	end
			 
    logic [9:0] Ball_X_Motion, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
    
	 logic [3:0] stop;
	 is_barrier is_barrier(.*);

	 //is_stop
	 logic is_stop;
	 assign is_stop = ~((keycode & 16'h00ff) == W || (keycode & 16'hff00)>>8 == W || (keycode1 & 16'h00ff) == W || (keycode1 & 16'hff00)>>8 == W 
					|| (keycode & 16'h00ff) == S || (keycode & 16'hff00)>>8 == S || (keycode1 & 16'h00ff) == S || (keycode1 & 16'hff00)>>8 == S 
					|| (keycode & 16'h00ff) == D || (keycode & 16'hff00)>>8 == D || (keycode1 & 16'h00ff) == D || (keycode1 & 16'hff00)>>8 == D
					|| (keycode & 16'h00ff) == A || (keycode & 16'hff00)>>8 == A || (keycode1 & 16'h00ff) == A || (keycode1 & 16'hff00)>>8 == A );
	 
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
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
				if (player_id == 1'b0)
					Ball_X_Pos <= Ball_X1_Center;
				else
					Ball_X_Pos <= Ball_X2_Center;
					
				Ball_Y_Pos <= Ball_Y_Center;
					
				Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
		  
//			  if(player_id == 1'b0)
//			  begin
					// Be careful when using comparators with "logic" datatype because compiler treats 
					//   both sides of the operator as UNSIGNED numbers.
					// e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
					// If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
					if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max || Ball_Y_Pos <= Ball_Y_Min + Ball_Size || is_stop )  // Ball is at the bottom edge, BOUNCE!
						 Ball_Y_Motion_in = 10'd0;  // 2's complement.
					if ((keycode & 16'h00ff) == S || (keycode & 16'hff00)>>8 == S || (keycode1 & 16'h00ff) == S || (keycode1 & 16'hff00)>>8 == S )  // Ball is at the top edge, BOUNCE!
						 Ball_Y_Motion_in = Ball_Y_Step;
					else if ( (keycode & 16'h00ff) == W || (keycode & 16'hff00)>>8 == W || (keycode1 & 16'h00ff) == W || (keycode1 & 16'hff00)>>8 == W )
						 Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
						 
					// TODO: Add other boundary detections and handle keypress here.
					if( Ball_X_Pos + Ball_Size >= Ball_X_Max || Ball_X_Pos <= Ball_X_Min + Ball_Size || is_stop)  // Ball is at the right edge, BOUNCE!
						 Ball_X_Motion_in = 10'd0;
					if ( (keycode & 16'h00ff) == D || (keycode & 16'hff00)>>8 == D || (keycode1 & 16'h00ff) == D || (keycode1 & 16'hff00)>>8 == D )  // Ball is at the left edge, BOUNCE!
						 Ball_X_Motion_in = Ball_X_Step;
					else if ( (keycode & 16'h00ff) == A || (keycode & 16'hff00)>>8 == A || (keycode1 & 16'h00ff) == A || (keycode1 & 16'hff00)>>8 == A )
						 Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement.
						 
					if ( (keycode & 16'h00ff) == W || (keycode & 16'hff00)>>8 == W || (keycode1 & 16'h00ff) == W || (keycode1 & 16'hff00)>>8 == W 
					|| (keycode & 16'h00ff) == S || (keycode & 16'hff00)>>8 == S || (keycode1 & 16'h00ff) == S || (keycode1 & 16'hff00)>>8 == S )
						 Ball_X_Motion_in = 10'd0;
					if ( (keycode & 16'h00ff) == D || (keycode & 16'hff00)>>8 == D || (keycode1 & 16'h00ff) == D || (keycode1 & 16'hff00)>>8 == D
					|| (keycode & 16'h00ff) == A || (keycode & 16'hff00)>>8 == A || (keycode1 & 16'h00ff) == A || (keycode1 & 16'hff00)>>8 == A )
						 Ball_Y_Motion_in = 10'd0;
					if ( ((keycode & 16'h00ff) == W || (keycode & 16'hff00)>>8 == W || (keycode1 & 16'h00ff) == W || (keycode1 & 16'hff00)>>8 == W) 
						&& (Ball_Y_Pos <= Ball_Y_Min + Ball_Size || stop[0])) //top edge , UP
						Ball_Y_Motion_in = 10'd0;
					if ( ((keycode & 16'h00ff) == A || (keycode & 16'hff00)>>8 == A || (keycode1 & 16'h00ff) == A || (keycode1 & 16'hff00)>>8 == A) 
						&& (Ball_X_Pos <= Ball_X_Min + Ball_Size || stop[1])) //left edge, Left
						Ball_X_Motion_in = 10'd0;
					if ( ((keycode & 16'h00ff) == S || (keycode & 16'hff00)>>8 == S || (keycode1 & 16'h00ff) == S || (keycode1 & 16'hff00)>>8 == S)
						&& (Ball_Y_Pos + Ball_Size >= Ball_Y_Max || stop[2])) //bottom edge, Down
						Ball_Y_Motion_in = 10'd0;
					if ( ((keycode & 16'h00ff) == D || (keycode & 16'hff00)>>8 == D || (keycode1 & 16'h00ff) == D || (keycode1 & 16'hff00)>>8 == D) 
						&& (Ball_X_Pos + Ball_Size >= Ball_X_Max || stop[3])) //right edge, Right
						Ball_X_Motion_in = 10'd0;
						
					// Update the ball's position with its motion
					if(player_alive && !game_over)
						begin
						Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion_in;
						Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;
						end
					else
						begin
						Ball_X_Pos_in = Ball_X_Pos;
						Ball_Y_Pos_in = Ball_Y_Pos;
						end
			  end
		
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
	 
    always_comb begin
			is_ball = 1'b0;
        if ( DistX*DistX <= Size*Size && DistY*DistY <= Size*Size && (coloridx!=5'h0) )
				is_ball = 1'b1;
//		  if (Ball_X_Pos - DrawX >= 10'd0 || Ball_Y_Pos - DrawY >= 10'd0)
//				is_ball = 1'b0;
        else
            is_ball = 1'b0;
	 end
	 

//    end
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    
endmodule
