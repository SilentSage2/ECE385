module setBEN(
	input logic Clk,
	input logic BEN_in,
	input logic LD_BEN,
	output logic BEN
	
);

always_ff @(posedge Clk)
begin
	if (LD_BEN)
		BEN <= BEN_in;
end	
	
endmodule
