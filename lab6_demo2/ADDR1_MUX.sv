module ADDR1_MUX(
                 input logic [15:0] PC, SR1_OUT,
					  input logic ADDR1MUX,
					  output logic [15:0] ADDR1MUX_out
					  );
					  
	always_comb begin
		unique case (ADDR1MUX)
			1'b0   : ADDR1MUX_out = PC; // '0'
			1'b1   : ADDR1MUX_out = SR1_OUT; // '1'
		endcase
	end
					  
endmodule
