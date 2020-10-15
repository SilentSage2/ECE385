module state_MUX(		
		input logic [127:0] in0, in1, in2, in3,in4,
		input logic [2:0] select,
		output logic [127:0] out
		);
	always_comb
	begin
		case(select)
		3'b000: out = in0;
		3'b001: out = in1;
		3'b010: out = in2;
		3'b011: out = in3;
		4'b100: out = in4;
		default: out = 127'hzzzz;
		endcase
	end

endmodule

