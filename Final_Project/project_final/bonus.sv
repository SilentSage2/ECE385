module bonus(input [9:0] Ball_X_Pos, Ball_Y_Pos,
				input [0:12*16-1][3:0] treasure_array,
				output earn_life, earn_protection
				);
	logic [5:0] subX, subY;
	logic [3:0] treasure_idx;
	assign subX = Ball_X_Pos/40;
	assign subY = Ball_Y_Pos/40;
	assign treasure_idx = treasure_array[subY*16+subX];
	
	always_comb begin
		earn_life = 1'b0;
		earn_protection = 1'b0;
		case(treasure_idx)
			4'h1: //liquid
				earn_life = 1'b1;
			4'h2: //hat
				earn_protection = 1'b1;
			default:;
		endcase
	end
	
	
endmodule
