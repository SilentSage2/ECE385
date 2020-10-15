//DR MUX
module DR_MUX(
	input logic [15:0] IR,
	input logic DRMUX,
	output logic [2:0] DRMUX_out
);
	
	always_comb begin
	if(~DRMUX)
		DRMUX_out = IR[11:9];
	else
		DRMUX_out = 3'b111;
	end
	
endmodule
