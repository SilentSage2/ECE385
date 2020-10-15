module datapath( 		
				input logic Clk,
				input logic [1:0]  PCMUX,
				input logic    GatePC,
									GateMDR,
									//GateALU,
									//GateMARMUX,
									//SR1MUX,
									//SR2MUX,
									//ADDR1MUX,
				//input logic [1:0]  ADDR2MUX,
				//					ALUK,
									LD_MAR,
									LD_MDR,
									LD_PC,
									LD_IR,
				input logic    MIO_EN,
				input logic [15:0] PC, MDR_In, bus_data,
				output logic [15:0] MDRMUX_out
				);

			 
			 
	

always_comb begin
	if (MIO_EN)
			MDRMUX_out = MDR_In;
	else
			MDRMUX_out = bus_data;
	
end

endmodule





