module ALU_MUX(
	input logic [1:0] ALUK, //00 ADD  01 AND  10 NOT 11 nothing
	input logic [15:0] SR2MUX_out, SR1_OUT,
	output logic [15:0] ALU_out
);
always_comb begin
	if (ALUK == 2'b00)
		ALU_out = SR2MUX_out + SR1_OUT;
	else if (ALUK == 2'b01)
		ALU_out = SR2MUX_out & SR1_OUT;
	else //10,11
		ALU_out = ~SR1_OUT;
end
endmodule
