module PC_MUX(
	input logic [15:0] adder_out, bus_data, PC,
	input logic [1:0] PCMUX,
	output logic [15:0] PCMUX_out
	
);

always_comb 
begin
	if (PCMUX==2'b00)
		PCMUX_out = PC + 16'b00000001;
	else if (PCMUX == 2'b01)
		PCMUX_out = adder_out;
	else 
		PCMUX_out = bus_data;
	//other cases of PC needed for week2
	
end	

endmodule
