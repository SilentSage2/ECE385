module SR1_MUX(
	input logic [15:0] IR,
	input logic SR1MUX,
	output logic [2:0] SR1MUX_out
);

always_comb begin
	if(~SR1MUX)
		SR1MUX_out = IR[8:6];
	else
		SR1MUX_out = IR[11:9];

end
endmodule
