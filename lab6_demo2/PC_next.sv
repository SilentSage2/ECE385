module PC_next(
	input logic Clk,
	input logic [15:0] PCMUX_out,
	output logic [15:0] PC
);

always_ff @ (posedge Clk)
begin 
	PC <= PCMUX_out;
end

endmodule
