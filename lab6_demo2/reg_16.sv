module reg_16 (input  logic Clk, Reset, Load,
              input  logic [15:0]  D,
              output logic [15:0]  Data_out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_out <= 16'h00;
		 if (Load)
			  Data_out <= D;
    end

endmodule
