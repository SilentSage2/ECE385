module setCC(
				 input logic Clk,
             input logic [15:0] bus_data,
				 input logic LD_CC,
				 output logic [2:0] NZP
				 );

	always_ff @(posedge Clk)
	begin
		if (LD_CC) begin
				if (bus_data[15])
					NZP <= 3'b100;
				else if (bus_data > 0)
					NZP <= 3'b001;
				else
					NZP <= 3'b010;
		end
	end
	
endmodule 