module game_state(
			input Clk, Reset, VGA_VS,
			input start, //key[1] || click_start
			input restart, //key[2] || click_restart
			input [3:0] player1_lives, player2_lives, //with palyer2_lives, can decide if end the game
			input load_finish,
			output game_on, game_over,
			output display_init,
			output load_map,
			output load_startpage,
			output draw_cursor,
			output [7:0] counter,
			output draw_gameover
		);
		
enum logic [3:0] {  
						INIT,
						LOAD_MAP, START_PAGE,
						GAME_ON,
						GAME_OVER,
						DISAPEAR} curr_state, next_state;

logic reset, LD_little1, reset_little1, LD_gameover;
logic [7:0] little_counter1;
logic  LD_little2, reset_little2;
logic [7:0] little_counter2;
reg_8_down gameover_wait(.*, .Load(LD_gameover), .Din(counter), .reset_D(8'h9f), .Data_out(counter));//decrease when load
reg_8_down switch1(.*, .reset(reset_little1), .Load(LD_little1), .Din(little_counter1), .reset_D(8'h10), .Data_out(little_counter1));//decrease when load
reg_8_down switch2(.*, .reset(reset_little2), .Load(LD_little2), .Din(little_counter2), .reset_D(8'h10), .Data_out(little_counter2));//decrease when load

  always_ff @ (posedge Clk)
    begin
        if (Reset)
            curr_state <= INIT;
			else
            curr_state <= next_state;
	end
	
	
always_comb
   begin
	 //if not changed in current state, these are the default values
//     	LD_init_wait = 1'b0;
		reset_little1 = 1'b0;
		LD_little1 = 1'b0;
		reset_little2 = 1'b0;
		LD_little2 = 1'b0;
		game_on = 1'b0;
		game_over = 1'b0;
		draw_gameover = 1'b0;
		reset = 1'b1; //reset other than GAME_OVER
		LD_gameover = 1'b0;
		load_startpage = 1'b0;
		load_map = 1'b0;
		display_init = 1'b0;
		next_state  = curr_state;	//required because I haven't enumerated all possibilities below
		draw_cursor = 1'b0;
	unique case(curr_state)
	INIT:
		begin
		if (load_finish)
			begin
		   next_state = START_PAGE;
			end
		end
	START_PAGE:
		begin
		if(start)
		   next_state = GAME_ON;
		end
	GAME_ON:
		begin
		if(player2_lives==0 || player1_lives==0)
			next_state = GAME_OVER;
		end
	GAME_OVER:
		begin
			if(restart)
			begin
				next_state = START_PAGE;
			end
			if(little_counter1 == 0 && counter != 0)
				next_state = DISAPEAR;
		end
	DISAPEAR:
		begin
			if(little_counter2 == 0)
				next_state = GAME_OVER;
		end
	default:;
	endcase
	
	
	case(curr_state)

	INIT:
		begin
			display_init = 1'b1;
		end
	START_PAGE:
		begin
			load_map = 1'b1;
			draw_cursor = 1'b1;
			game_over = 1'b0;
			load_startpage = 1'b1;
		end
	GAME_ON:
		begin
			game_on = 1'b1;
			reset_little1 = 1'b1;
			reset_little2 = 1'b1;
		end
	GAME_OVER:
		begin
		reset = 1'b0;
		draw_gameover = 1'b1;
		game_over = 1'b1;
		draw_cursor = 1'b1;
		if(counter!=0)
		begin
			LD_gameover = 1'b1;
			LD_little1 = 1'b1;
		end
		reset_little2 = 1'b1;
		end
	DISAPEAR:
		begin
		reset = 1'b0;
		game_over = 1'b1;
		draw_cursor = 1'b1;
		if(counter!=0)
			LD_gameover = 1'b1;
		LD_little2 = 1'b1;
		reset_little1 = 1'b1;
		end
	default: ;
	endcase	
end


endmodule

		
	
		
		
		
