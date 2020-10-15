//databus mux
module DatabusMUX(
	input logic GateMDR, GateMARMUX, GatePC, GateALU,
	input logic [15:0] MDR, PC, adder_out, ALU_out,
	output logic [15:0] bus_data
);
//databus MUX select
always_comb begin
	if (GateMDR)
		bus_data = MDR;
	else if (GatePC)
		bus_data = PC;
	else if (GateMARMUX)
		bus_data = adder_out;
	else 
		bus_data = ALU_out;
end

endmodule
