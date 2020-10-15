module SR2_MUX(
	input logic [15:0] SR2_OUT, IR,
	input logic SR2MUX,
	output logic [15:0] SR2MUX_out
);

always_comb begin
	if(~SR2MUX)
		SR2MUX_out = SR2_OUT;
	else
		SR2MUX_out = {{11{IR[4]}},IR[4:0]};

end
endmodule