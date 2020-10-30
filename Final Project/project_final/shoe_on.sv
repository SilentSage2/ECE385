module shoe_state(
			input Clk, Reset, VGA_VS,
			input shoe,
			output shoe_on
			);
			
	logic [7:0] counter;
	logic LD_counter, reset;
	
			enum logic [2:0] {  
						IDLE,
						SHOE_ON} curr_state, next_state;
			
	
	reg_8_down disapear(.VGA_VS, .reset(reset), .Load(LD_counter), .Din(counter), .reset_D(8'hff), .Data_out(counter));
  always_ff @ (posedge Clk)
    begin
        if (Reset)
            curr_state <= IDLE;
			else
            curr_state <= next_state;
    end
	 
	 

always_comb
   begin
	LD_counter = 1'b0;
	reset = 1'b0;
	shoe_on = 1'b0;
	next_state = curr_state;
	
	unique case(curr_state)
	IDLE:
	begin
		if(shoe)
		begin
			next_state = SHOE_ON;
		end
	end
	SHOE_ON:
	begin
		if(counter == 0)
			next_state = IDLE;
	end

	endcase
	
	
	
	case(curr_state)
	IDLE:
	begin
		reset = 1'b1;
		shoe_on = 1'b1;
	end
	SHOE_ON:
	begin
		LD_counter = 1'b1;
		shoe_on = 1'b1;
	end
	endcase
end

endmodule
