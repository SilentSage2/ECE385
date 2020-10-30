module bomb(input logic Clk, Reset,
	    input logic [15:0] keycode, keycode1,
		 input logic [9:0] Ball_X_Pos, Ball_Y_Pos,
		 input player_id,
	    output logic [3:0][5:0] Xbomb, Ybomb,
		 input logic [3:0] bomb_on,
		 output logic [3:0] bombstart
);


// parameter [7:0] Space = 8'h2c;
 logic [5:0] Xcoord_in, Ycoord_in;
 assign Xcoord_in = Ball_X_Pos/40;
 assign Ycoord_in = Ball_Y_Pos/40;
	 
 logic [7:0] place_bomb;
 
 
 always_comb
	begin
		if(player_id == 1'b0)
			place_bomb = 8'd44;
		else
			place_bomb = 8'd98; //Number0

 //keycode for start
	bombstart = 4'b0;
	if( (keycode & 16'h00ff) == place_bomb || (keycode & 16'hff00)>>8 == place_bomb || (keycode1 & 16'h00ff) == place_bomb || (keycode1 & 16'hff00)>>8 == place_bomb )
	begin
		case(bomb_on)
		4'b0000, 4'b1110, 4'b1100, 4'b1000, 4'b0110, 4'b0010:
			bombstart[0] = 1'b1;
		4'b0001, 4'b1001, 4'b1101, 4'b0101:
			bombstart[1] = 1'b1;
		4'b0011, 4'b1011:
			bombstart[2] = 1'b1;
		4'b0111:
			bombstart[3] = 1'b1;
		default:
			bombstart = 4'b0;
		endcase

	end

end



always_ff @ (posedge Clk) 
begin
//	if(Reset)
//	begin
//		Xbomb[0] <= 6'b0;
//		Ybomb[0] <= 6'b0;
//		Xbomb[1] <= 6'b0;
//		Ybomb[1] <= 6'b0;
//		Xbomb[2] <= 6'b0;
//		Ybomb[2] <= 6'b0;
//		Xbomb[3] <= 6'b0;
//		Ybomb[3] <= 6'b0;		
//	end
		
	if (bombstart[0])
	begin
		Xbomb[0] <= Xcoord_in;
		Ybomb[0] <= Ycoord_in;
	end
	if(!bomb_on[0])
	begin
		Xbomb[0] <= 6'bzz;
		Ybomb[0] <= 6'bzz;
	end
	if (bombstart[1])
	begin
		Xbomb[1] <= Xcoord_in;
		Ybomb[1] <= Ycoord_in;
	end
	if(!bomb_on[1])
	begin
		Xbomb[1] <= 6'bzz;
		Ybomb[1] <= 6'bzz;
	end
	
	if (bombstart[2])
	begin
		Xbomb[2] <= Xcoord_in;
		Ybomb[2] <= Ycoord_in;
	end
	if(!bomb_on[2])
	begin
		Xbomb[2] <= 6'bzz;
		Ybomb[2] <= 6'bzz;
	end
	
	if (bombstart[3])
	begin
		Xbomb[3] <= Xcoord_in;
		Ybomb[3] <= Ycoord_in;
	end
	if(!bomb_on[3])
	begin
		Xbomb[3] <= 6'bzz;
		Ybomb[3] <= 6'bzz;
	end
		
end

endmodule

