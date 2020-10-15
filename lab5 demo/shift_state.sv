module shift_state (
                    input [2:0] State_in,
						  logic output [2:0] State_out
						  );

	logic [2:0] c;
	full_adder fa0(.x(State_in[0]), .y(1), .cin(0), .s(State_out[0]), cout(c[0]));
	full_adder fa1(.x(State_in[1]), .y(0), .cin(c[0]), .s(State_out[1]), cout(c[1]));
	full_adder fa2(.x(State_in[2]), .y(0), .cin(c[1]), .s(State_out[2]), cout(c[2]));
						 
endmodule
