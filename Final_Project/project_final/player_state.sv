
module player_state(
			input Clk, Reset, VGA_VS,
			input game_on,
			input [0:12*16-1][3:0] map_array, treasure_array,
			input [9:0] Ball_X_Pos, Ball_Y_Pos,
			input [3:0][5:0] Xbomb1, Xbomb2, Ybomb1, Ybomb2,
			input [3:0] bomb_exploded1, bomb_exploded2,
			output [3:0] player_lives, //with palyer2_lives, can decide if end the game
			output player_alive, //if alive, keyboard can control 
			output player_display,
			input life_plus, protect,
			input game_over, 
			input [7:0] counter,
			output protecting
		);
		
enum logic [3:0] {  
						IDLE,
						RUN,
						DEAD,
						BLINK,
						PROTECT,
						LIFE_END } curr_state, next_state;

logic LD_lives, LD_dead_wait, LD_protect; 
logic [7:0] dead_counter, protect_counter;
logic reset, reset_counter;
logic [5:0] subX, subY;

assign subX = Ball_X_Pos/40;
assign subY = Ball_Y_Pos/40;

reg_8_down player1deadcount(.VGA_VS, .reset(reset_counter), .Load(LD_dead_wait), .Din(dead_counter), .reset_D(8'h4f), .Data_out(dead_counter));//decrease when load
reg_4_down player1livescount(.Clk, .reset, .Down(LD_lives), .Up(life_plus), .Din(player_lives), .reset_D(4'h3), .Data_out(player_lives));//decrease when load
reg_8_down protectcounter(.VGA_VS, .reset(reset_counter), .Load(LD_protect), .Din(protect_counter), .reset_D(8'hff), .Data_out(protect_counter));
  always_ff @ (posedge Clk)
    begin
        if (Reset || counter == 0)
            curr_state <= IDLE;
		  else if(game_over)
				curr_state <= LIFE_END;
		  else
            curr_state <= next_state;
    end
	 
	 

always_comb
   begin
	 //if not changed in current state, these are the default values
		LD_dead_wait = 1'b0;
		LD_lives = 1'b0;
		LD_protect = 1'b0;
		reset = 1'b0;
		reset_counter = 1'b0;
		player_alive = 1'b0;
		player_display = 1'b0;
		protecting = 1'b0;
		
		next_state  = curr_state;	//required because I haven't enumerated all possibilities below
	unique case(curr_state)
	IDLE:
	begin
		reset = 1'b1;
		if(game_on)
		begin
			next_state = RUN;
		end
	end
	
	RUN:
		begin
		if( map_array[16*subY+subX] == 4'h3 || map_array[16*subY+subX] == 4'h7 || map_array[16*subY+subX] == 4'h8 
			|| map_array[16*subY+subX] == 4'h9 || map_array[16*subY+subX] == 4'ha)//need to be flame
			begin
				next_state = DEAD;
				LD_lives = 1'b1;
			end
		if(protect == 1'b1)
			next_state = PROTECT;
		end
	PROTECT:
		begin
			if(protect_counter == 0)
				next_state = RUN;
		end
	DEAD:
		begin
		if(player_lives == 0)
			next_state = LIFE_END;
		else if(dead_counter == 0)
			next_state = RUN;
		else if(dead_counter % 4==0)
			next_state = BLINK;
		end
	BLINK:
		begin
		if(dead_counter == 0)
			next_state = RUN;
		else if(dead_counter % 4==0)
			next_state = DEAD;
		end
	//LIFE_END only if Reset(by start) can go back to IDLE, or it stays in LIFE_END
			
	default:;
	endcase
	
	
	
	
	case(curr_state)
	RUN:
		begin
			player_alive = 1'b1;
			player_display = 1'b1;
			reset_counter = 1'b1;
		end
	DEAD:
		begin
			LD_dead_wait = 1'b1;
		end
	BLINK:
		begin
			LD_dead_wait = 1'b1;
			player_display = 1'b1;
		end
	
	PROTECT:
		begin
			protecting = 1'b1;
			LD_protect = 1'b1;
			player_alive = 1'b1;
			player_display = 1'b1;
		end
	default: ;
	
	endcase	
end


endmodule		

module reg_4_down(
			input Clk, reset, Down, Up,
		  input [3:0] Din, reset_D,
		  output [3:0] Data_out
);

//	logic [7:0] data;
//	assign data = Din - 4'b0001;
	always_ff @ (posedge Clk)
   begin
		if(reset)
			Data_out <= reset_D;
		if(Down)
			Data_out <= Din - 4'b0001;
		if(Up)
			Data_out <= Din + 4'b0001;

	 end
	 
endmodule


		