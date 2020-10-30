module bomb_state( input Clk, Reset, VGA_VS,
		   input bombstart,
		   output bomb_placed,
			output bomb_exploding,
			output bomb_exploded,
			output bomb_on
);

enum logic [2:0] {  
						IDLE,
						PLACE_BOMB,
						EXPLODE,
						DONE
									} curr_state, next_state;

logic LD_count, LD_wait, reset;
logic [7:0] counter, explode_wait;


reg_8_down counterreg(.*, .Load(LD_count), .Din(counter), .reset_D(8'h4f), .Data_out(counter));//decrease when load
reg_8_down explodereg(.*, .Load(LD_wait), .Din(explode_wait), .reset_D(8'h0a), .Data_out(explode_wait));//decrease when load

   always_ff @ (posedge Clk)
    begin
        if (Reset)
            curr_state <= IDLE;
			else
            curr_state <= next_state;
    end


always_comb
   begin
	 //if not changed in current state, these are the default values
     	LD_count = 1'b0;
		LD_wait = 1'b0;
		reset = 1'b0;
		bomb_placed = 1'b0;
		bomb_exploding = 1'b0;
		bomb_exploded = 1'b0;
		bomb_on = 1'b0;
		next_state  = curr_state;	//required because I haven't enumerated all possibilities below

	unique case(curr_state)
   IDLE:
		begin
		if (bombstart)
		   next_state = PLACE_BOMB;
		end
	PLACE_BOMB:
		begin
		if(counter == 8'h00)
		   next_state = EXPLODE;
		end
	EXPLODE:
		begin
		if(explode_wait == 8'h00)
			begin
				next_state = DONE;
				//bomb_exploded = 1'b1;
			end
		end
	DONE:
		begin
		   next_state = IDLE;
		end
		default: ;
			
	endcase	
		

	case(curr_state)
	IDLE: 
		begin 
			reset = 1'b1; //reset counter = 15
			bomb_on = 1'b0;
		end
	PLACE_BOMB:
		begin
			bomb_placed = 1'b1;
			LD_count = 1'b1;
			if(counter < 8'h4a)
				bomb_on = 1'b1;
			else
				bomb_on = 1'b0;
		end
	EXPLODE:
		begin
			LD_wait = 1'b1;
			bomb_exploding = 1'b1;
			bomb_on = 1'b1;
		end
	DONE:
		begin
			bomb_on = 1'b1;
			bomb_exploded = 1'b1;
		end
	default: ;
	endcase	
	end

endmodule




module reg_8_down(
			input VGA_VS, reset, Load,
		  input [7:0] Din, reset_D,
		  output [7:0] Data_out
);

	logic [7:0] data;
	assign data = Din - 8'b0001;
	always_ff @ (posedge VGA_VS)
   begin
		if(reset)
			Data_out <= reset_D;
		if(Load)
			Data_out <= data;

	 end
	 
endmodule


