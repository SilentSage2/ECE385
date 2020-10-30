module music_control (
							input logic Clk, Reset,
							input logic INIT_FINISH, data_over, game_over, load_startpage,
							output logic INIT,
							output [18:0] Addr
							);
							

logic [18:0] Addr_in;
logic [18:0] count_in, count;
							
enum logic [2:0] {  
						IDLE,MUSIC_OFF, WAIT_FOR_INIT, MUSIC_ON
									} curr_state, next_state;

   always_ff @ (posedge Clk)
    begin
        if (Reset)
		  begin
            curr_state <= IDLE;
				Addr <= 19'd0;
				count <= 19'b0;
		  end
		  else
		  begin
            curr_state <= next_state;
				Addr <= Addr_in;
				count <= count_in;
		  end
    end
			
always_comb
   begin
	 //if not changed in current state, these are the default values
		INIT = 1'b0;
		Addr_in = Addr;
		count_in = count;
		next_state  = curr_state;	//required because I haven't enumerated all possibilities below

	unique case(curr_state)
	IDLE:
		begin
		if (load_startpage)
			next_state = MUSIC_OFF;
		end
   MUSIC_OFF:
		begin
		   next_state = WAIT_FOR_INIT;
		end
	WAIT_FOR_INIT:
		begin
		if(INIT_FINISH)
		   next_state = MUSIC_ON;
		end
	MUSIC_ON:
		begin
		if (game_over)
			next_state = IDLE;
		end
		default: ;
			
	endcase	
		

	case(curr_state)
	MUSIC_OFF: 
		begin 
			INIT = 1'b1;
			Addr_in = 19'd0;
		end
	WAIT_FOR_INIT:
		begin
			Addr_in = 19'd0;
		end
	MUSIC_ON:
		begin
			if ((count < 19'd10) && data_over)
				count_in = count + 19'd1;
			else if (count < 19'd10)
				count_in = count;
			else 
				count_in = 19'd0;

			if ((Addr < 19'd85114) && data_over && (count == 19'd9))//end address)
				Addr_in = Addr + 19'd1;
			else if (Addr < 19'd85114)
				Addr_in = Addr;
			else
				Addr_in = 19'd0;
		end

	default: ;
	endcase	
	end			
							
endmodule

module bgm (
				input logic Clk,
				input logic [18:0] Addr,   
				output logic [15:0] music_data			
					);

	logic [15:0] music_memory[0:85114];
	initial
	begin
		$readmemh("music.txt", music_memory);
	end
	
	always_ff @ (posedge Clk)
		begin
			music_data <= music_memory[Addr];
		end
endmodule
