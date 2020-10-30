module is_barrier(
                  input [9:0] Ball_X_Pos, Ball_Y_Pos,
						input [0:12*16-1][3:0] map_array,
						output [3:0] stop
                  );
						
		logic [4:0] X_t_l, X_t_r, X_b_l, X_b_r, X_l_mid, X_r_mid, X_t_mid, X_b_mid;
		logic [4:0] Y_t_l, Y_t_r, Y_b_l, Y_b_r, Y_l_mid, Y_r_mid, Y_t_mid, Y_b_mid;
		
		assign X_t_l = (Ball_X_Pos-9)/40;
		assign X_t_r = (Ball_X_Pos+10)/40;
		assign X_b_l = (Ball_X_Pos-9)/40;
		assign X_b_r = (Ball_X_Pos+10)/40;
		assign Y_t_l = (Ball_Y_Pos-15)/40;
		assign Y_t_r = (Ball_Y_Pos-15)/40;
		assign Y_b_l = (Ball_Y_Pos+14)/40;
		assign Y_b_r = (Ball_Y_Pos+14)/40;
		assign X_t_mid = (Ball_X_Pos)/40;
		assign X_l_mid = (Ball_X_Pos-9)/40;
		assign X_b_mid = (Ball_X_Pos)/40;
		assign X_r_mid = (Ball_X_Pos+10)/40;
		assign Y_t_mid = (Ball_Y_Pos-15)/40;
		assign Y_l_mid = (Ball_Y_Pos)/40;
		assign Y_b_mid = (Ball_Y_Pos+14)/40;
		assign Y_r_mid = (Ball_Y_Pos)/40;


		
		always_comb begin
			stop = 4'b0;
			if ((map_array[16*(Y_t_l-1)+X_t_l]!=4'h0 || map_array[16*(Y_t_r-1)+X_t_l]!=4'h0 || map_array[16*(Y_t_mid-1)+X_t_mid]!=4'h0) && Ball_Y_Pos == Y_t_l*40 + 20)
				stop[0] = 1'b1;
			if ((map_array[16*Y_t_l+X_t_l-1]!=4'h0 || map_array[16*Y_b_l+X_b_l-1]!=4'h0 || map_array[16*Y_l_mid+X_l_mid-1]!=4'h0) && Ball_X_Pos == X_t_l*40 + 20)
				stop[1] = 1'b1;
			if ((map_array[16*(Y_b_l+1)+X_b_l]!=4'h0 || map_array[16*(Y_b_r+1)+X_b_r]!=4'h0 || map_array[16*(Y_b_mid+1)+X_b_mid]!=4'h0) && Ball_Y_Pos == Y_b_r*40 + 20)
				stop[2] = 1'b1;
			if ((map_array[16*Y_t_r+X_t_r+1]!=4'h0 || map_array[16*Y_b_r+X_b_r+1]!=4'h0 || map_array[16*Y_r_mid+X_r_mid+1]!=4'h0) && Ball_X_Pos == X_b_r*40 + 20)
				stop[3] = 1'b1;
		end
						
endmodule
