module reg_32 (input  logic Clk, Reset, Load,
					input logic [3:0] ByteEN,
              input  logic [31:0]  D,
				  input logic [31:0] lastD,
              output logic [31:0]  Data_out);

logic [31:0] Data;
	always_comb
	begin 
			unique case(ByteEN)
				4'b1111: Data = D;
				4'b1100: Data = D & 32'hffff0000 + lastD & 32'h0000ffff;
				4'b0011: Data = D & 32'h0000ffff + lastD & 32'hffff0000;
				4'b1000: Data = D & 32'hff000000 + lastD & 32'h00ffffff;
				4'b0100: Data = D & 32'h00ff0000 + lastD & 32'hff00ffff;
				4'b0010: Data = D & 32'h0000ff00 + lastD & 32'hffff00ff;
				4'b0001: Data = D & 32'h000000ff + lastD & 32'hffffff00;
				default: Data = 32'hzzzzzzzz;
			endcase
	end
			
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_out <= 32'h00;
		 if (Load)
			  Data_out <= Data;
    end

endmodule

module reg_32DE (input  logic Clk, Reset, Load1, Load2,
					input logic [3:0] ByteEN,
              input  logic [31:0]  D, D2,
				  input logic [31:0] lastD,
              output logic [31:0]  Data_out);

logic [31:0] Data;
	always_comb
	begin 
			unique case(ByteEN)
				4'b1111: Data = D;
				4'b1100: Data = D & 32'hffff0000 + lastD & 32'h0000ffff;
				4'b0011: Data = D & 32'h0000ffff + lastD & 32'hffff0000;
				4'b1000: Data = D & 32'hff000000 + lastD & 32'h00ffffff;
				4'b0100: Data = D & 32'h00ff0000 + lastD & 32'hff00ffff;
				4'b0010: Data = D & 32'h0000ff00 + lastD & 32'hffff00ff;
				4'b0001: Data = D & 32'h000000ff + lastD & 32'hffffff00;
				default: Data = 32'hzzzzzzzz;
			endcase
	end
			
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_out <= 32'h00;
		 if (Load1)
			  Data_out <= Data;
		 if (Load2)
			  Data_out <= D2;
    end

endmodule