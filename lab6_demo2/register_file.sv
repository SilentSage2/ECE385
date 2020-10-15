module reg_file(
                input logic Clk, Reset_ah, 
                input logic [15:0] bus_data,
					 input logic [2:0] DRMUX_out, SR1MUX_out, SR2,
					 input logic LD_REG,
					 output logic [15:0] SR1_OUT, SR2_OUT
					 );
	logic R0, R1, R2, R3, R4, R5, R6, R7;
	logic [15:0] R0_out, R1_out, R2_out, R3_out, R4_out, R5_out, R6_out, R7_out;
	
   always_comb begin
		R0 = 1'b0;
		R1 = 1'b0;
		R2 = 1'b0;
		R3 = 1'b0;
		R4 = 1'b0;
		R5 = 1'b0;
		R6 = 1'b0;
		R7 = 1'b0;

		if (LD_REG)
			unique case (DRMUX_out)
				3'b000   : R0 = 1'b1; // '0'
				3'b001   : R1 = 1'b1; // '1'
				3'b010   : R2 = 1'b1; // '2'
				3'b011   : R3 = 1'b1; // '3'
				3'b100   : R4 = 1'b1; // '4'
				3'b101   : R5 = 1'b1; // '5'
				3'b110   : R6 = 1'b1; // '6'
				3'b111   : R7 = 1'b1; // '7'
			endcase
	
	end
	
	always_comb begin
		unique case (SR1MUX_out)
			3'b000   : SR1_OUT = R0_out; // '0'
			3'b001   : SR1_OUT = R1_out; // '1'
			3'b010   : SR1_OUT = R2_out; // '2'
			3'b011   : SR1_OUT = R3_out; // '3'
			3'b100   : SR1_OUT = R4_out; // '4'
			3'b101   : SR1_OUT = R5_out; // '5'
			3'b110   : SR1_OUT = R6_out; // '6'
			3'b111   : SR1_OUT = R7_out; // '7'
		endcase
		
		unique case (SR2)
			3'b000   : SR2_OUT = R0_out; // '0'
			3'b001   : SR2_OUT = R1_out; // '1'
			3'b010   : SR2_OUT = R2_out; // '2'
			3'b011   : SR2_OUT = R3_out; // '3'
			3'b100   : SR2_OUT = R4_out; // '4'
			3'b101   : SR2_OUT = R5_out; // '5'
			3'b110   : SR2_OUT = R6_out; // '6'
			3'b111   : SR2_OUT = R7_out; // '7'
		endcase
	end
	
	reg_16 Reg0(.Clk(Clk), .Reset(Reset_ah), .Load(R0), .D(bus_data), .Data_out(R0_out));
	reg_16 Reg1(.Clk(Clk), .Reset(Reset_ah), .Load(R1), .D(bus_data), .Data_out(R1_out));
	reg_16 Reg2(.Clk(Clk), .Reset(Reset_ah), .Load(R2), .D(bus_data), .Data_out(R2_out));
	reg_16 Reg3(.Clk(Clk), .Reset(Reset_ah), .Load(R3), .D(bus_data), .Data_out(R3_out));
	reg_16 Reg4(.Clk(Clk), .Reset(Reset_ah), .Load(R4), .D(bus_data), .Data_out(R4_out));
	reg_16 Reg5(.Clk(Clk), .Reset(Reset_ah), .Load(R5), .D(bus_data), .Data_out(R5_out));
	reg_16 Reg6(.Clk(Clk), .Reset(Reset_ah), .Load(R6), .D(bus_data), .Data_out(R6_out));
	reg_16 Reg7(.Clk(Clk), .Reset(Reset_ah), .Load(R7), .D(bus_data), .Data_out(R7_out));					

	
endmodule
