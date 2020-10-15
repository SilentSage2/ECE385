module reg_128 (input  logic CLK, reset, Load,
				  input logic [1:0] subEn,
				  input logic [31:0] D_sub,
              input  logic [127:0]  Din,
              output logic [127:0]  Data_out);

logic [127:0] Data;
	always_comb
	begin 
			case(subEn)
				2'b00: Data = (Din & 128'hffffffffffffffffffffffff00000000)| D_sub;
				2'b01: Data = (Din & 128'hffffffffffffffff00000000ffffffff)| D_sub << 32;
				2'b10: Data = (Din & 128'hffffffff00000000ffffffffffffffff)| D_sub << 64;
				2'b11: Data = (Din & 128'h00000000ffffffffffffffffffffffff)| D_sub << 96;
			endcase
	end

    always_ff @ (posedge CLK)
    begin
		if(reset)
			Data_out <= 128'h0000;
		if(Load)
			Data_out <= Data;
			
	 end
	 
endmodule


module reg_state (input logic CLK, reset, Load,
              input  logic [127:0]  Din,Dreset,
              output logic [127:0]  Data_out);

    always_ff @ (posedge CLK)
    begin
		if(reset)
			Data_out <= Dreset;
		else if(Load)
			Data_out <= Din;
			
	 end
	 
endmodule

module reg_MSG (input  logic CLK, RESET, Load,
				  //input logic [1:0] subEN,
				  //input logic [31:0] D_sub,
              input  logic [127:0]  Din,
              output logic [127:0]  Data_out);

    always_ff @ (posedge CLK)
    begin
		if(RESET)
			Data_out <= 128'h0000;
		if(Load)
			Data_out <= Din;
			
	 end
	 
endmodule



module reg_4_up (input  logic CLK, reset, Load,
              input  logic [3:0]  Din,
              output logic [3:0]  Data_out);
logic [3:0] data;
assign data = Din + 4'b0001;

    always_ff @ (posedge CLK)
    begin
		if(reset)
			Data_out <= 4'b0000;
		if(Load)
			Data_out <= data;
			
	 end
	 
endmodule


module reg_4_down (input  logic CLK, reset, Load,
              input  logic [3:0]  Din,
              output logic [3:0]  Data_out);
logic [3:0] data;
assign data = Din - 4'b0001;
				  
    always_ff @ (posedge CLK)
    begin
		if(reset)
			Data_out <= 4'b1010; //10
		if(Load)
			Data_out <= data;
			
	 end
	 
endmodule



module reg_1 (input  logic CLK, RESET, Load,
              output logic Data_out);

    always_ff @ (posedge CLK)
    begin
		if(RESET)
			Data_out <= 1'b0; //44
		if(Load)
			Data_out <= 1'b1;
			
	 end
	 
endmodule
