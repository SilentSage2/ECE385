module lifeplus_state(
			input Clk, Reset, VGA_VS,
			input life_plus,
			output [7:0] disapearcounter,
			output plus1
			);
			
	logic [7:0] plus_counter;
	logic LD_disapear, LD_plus_wait, reset;
	
			enum logic [3:0] {  
						IDLE,
						PLUS,
						DISAPEAR } curr_state, next_state;
			
	
	reg_8_down disapear(.VGA_VS, .reset(reset), .Load(LD_disapear), .Din(disapearcounter), .reset_D(8'h20), .Data_out(disapearcounter));
	reg_8_down pluswait(.VGA_VS, .reset(reset), .Load(LD_plus_wait), .Din(plus_counter), .reset_D(8'h20), .Data_out(plus_counter));
  always_ff @ (posedge Clk)
    begin
        if (Reset)
            curr_state <= IDLE;
			else
            curr_state <= next_state;
    end
	 
	 

always_comb
   begin
	LD_disapear = 1'b0;
	LD_plus_wait = 1'b0;
	reset = 1'b0;
	plus1 = 1'b0;
	next_state = curr_state;
	
	unique case(curr_state)
	IDLE:
	begin
		if(life_plus)
		begin
			next_state = PLUS;
		end
	end
	PLUS:
	begin
		if(plus_counter == 0)
			next_state = DISAPEAR;
	end
	DISAPEAR:
	begin
		if(disapearcounter == 0)
			next_state = IDLE;
	end
	endcase
	
	
	
	
	case(curr_state)
	IDLE:
	begin
		reset = 1'b1;
	end
	PLUS:
	begin
		LD_plus_wait = 1'b1;
		plus1 = 1'b1;
	end
	DISAPEAR:
	begin
		LD_disapear = 1'b1;
		plus1 = 1'b1;
	end
	endcase
end

endmodule
	