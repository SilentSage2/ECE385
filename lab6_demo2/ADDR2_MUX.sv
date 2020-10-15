module ADDR2_MUX(
                 input logic [15:0] IR,
					  input logic [1:0] ADDR2MUX,
					  output logic [15:0] ADDR2MUX_out
					  );
					  
	always_comb begin
		unique case (ADDR2MUX)
			2'b00   : ADDR2MUX_out = 16'b0; // '0'
			2'b01   : ADDR2MUX_out = {{10{IR[5]}},IR[5:0]}; // '1'
			2'b10   : ADDR2MUX_out = {{7{IR[8]}},IR[8:0]}; // '2'
			2'b11   : ADDR2MUX_out = {{5{IR[10]}},IR[10:0]}; // '3'
		endcase
	end
					  
endmodule
