/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module new_component (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET, //active high
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

logic LK0, LK1, LK2, LK3, LEN0, LEN1, LEN2, LEN3, LDE0, LDE1, LDE2, LDE3, L_ST, L_DONE;
//logic [31:0] AES_KEY0, AES_KEY1, AES_KEY2, AES_KEY3;
//logic [31:0] AES_MSG_EN0,AES_MSG_EN1,AES_MSG_EN2,AES_MSG_EN3;
//logic [31:0] AES_MSG_DE0,AES_MSG_DE1,AES_MSG_DE2,AES_MSG_DE3;
//logic [31:0] AES_START, AES_DONE;

logic [31:0] AES_KEY0_out, AES_KEY1_out, AES_KEY2_out, AES_KEY3_out;
logic [31:0] AES_MSG_EN0_out,AES_MSG_EN1_out,AES_MSG_EN2_out,AES_MSG_EN3_out;
logic [31:0] AES_MSG_DE0_out,AES_MSG_DE1_out,AES_MSG_DE2_out,AES_MSG_DE3_out;
logic [31:0] AES_START_out, AES_DONE_out;
logic [127:0] AES_KEY_in, AES_MSG_ENC_in, AES_MSG_DEC_out, AES_DONE;
//comb logic
always_comb begin
		LK0 = 1'b0; //must add here, or infer latch
		LK1 = 1'b0;
		LK2 = 1'b0;
		LK3 = 1'b0;
		LEN0 = 1'b0;
		LEN1 = 1'b0;
		LEN2 = 1'b0;
		LEN3 = 1'b0;
		LDE0 = 1'b0;
		LDE1 = 1'b0;
		LDE2 = 1'b0;
		LDE3 = 1'b0;
		L_ST = 1'b0;
		L_DONE = 1'b0;
//read
if(AVL_READ & AVL_CS)
	begin

		unique case (AVL_ADDR)
			4'h0: 
						AVL_READDATA = AES_KEY0_out;
			4'h1:	
						AVL_READDATA = AES_KEY1_out;
			4'h2:	
						AVL_READDATA = AES_KEY2_out;
			4'h3:	
						AVL_READDATA = AES_KEY3_out;
			4'h4:		
						AVL_READDATA = AES_MSG_EN0_out;
			4'h5:		
						AVL_READDATA = AES_MSG_EN1_out;
			4'h6:		
						AVL_READDATA = AES_MSG_EN2_out;
			4'h7:	
						AVL_READDATA = AES_MSG_EN3_out;
			4'h8:	
						AVL_READDATA = AES_MSG_DE0_out;
			4'h9:	
						AVL_READDATA = AES_MSG_DE1_out;
			4'ha:	
						AVL_READDATA = AES_MSG_DE2_out;
			4'hb:	
						AVL_READDATA = AES_MSG_DE3_out;
			4'he:	
						AVL_READDATA = AES_START_out;
			4'hf:	
						AVL_READDATA = AES_DONE_out;
						
			default: AVL_READDATA = 32'hzzzzzzzz; //error if not added
		endcase
	end
else 
	AVL_READDATA = 32'hzzzzzzzz;

//write
if(AVL_WRITE & AVL_CS)
	begin
		unique case (AVL_ADDR)
			4'h0: 	LK0 = 1'b1;
			4'h1:		LK1 = 1'b1;
			4'h2:		LK2 = 1'b1;
			4'h3:		LK3 = 1'b1;
			4'h4:		LEN0 = 1'b1;
			4'h5:		LEN1 = 1'b1;
			4'h6:		LEN2 = 1'b1;
			4'h7:		LEN3 = 1'b1;
			4'h8:		LDE0 = 1'b1;
			4'h9:		LDE1 = 1'b1;
			4'ha:		LDE2 = 1'b1;
			4'hb:		LDE3 = 1'b1;
			4'he:		L_ST = 1'b1;
			4'hf:		L_DONE = 1'b1;
			default : ;
		endcase
	end
	
else begin
		LK0 = 1'b0;
		LK1 = 1'b0;
		LK2 = 1'b0;
		LK3 = 1'b0;
		LEN0 = 1'b0;
		LEN1 = 1'b0;
		LEN2 = 1'b0;
		LEN3 = 1'b0;
		LDE0 = 1'b0;
		LDE1 = 1'b0;
		LDE2 = 1'b0;
		LDE3 = 1'b0;
		L_ST = 1'b0;
		L_DONE = 1'b0;
	end
end

//register file
reg_32 Reg0(.Clk(CLK), .Reset(RESET), .Load(LK0), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .lastD(AES_KEY0_out), .Data_out(AES_KEY0_out));
reg_32 Reg1(.Clk(CLK), .Reset(RESET), .Load(LK1), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .lastD(AES_KEY1_out), .Data_out(AES_KEY1_out));
reg_32 Reg2(.Clk(CLK), .Reset(RESET), .Load(LK2), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .lastD(AES_KEY2_out), .Data_out(AES_KEY2_out));
reg_32 Reg3(.Clk(CLK), .Reset(RESET), .Load(LK3), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .lastD(AES_KEY3_out), .Data_out(AES_KEY3_out));
reg_32 Reg4(.Clk(CLK), .Reset(RESET), .Load(LEN0),.ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .lastD(AES_MSG_EN0_out), .Data_out(AES_MSG_EN0_out));
reg_32 Reg5(.Clk(CLK), .Reset(RESET), .Load(LEN1),.ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .lastD(AES_MSG_EN1_out), .Data_out(AES_MSG_EN1_out));
reg_32 Reg6(.Clk(CLK), .Reset(RESET), .Load(LEN2), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .lastD(AES_MSG_EN2_out), .Data_out(AES_MSG_EN2_out));
reg_32 Reg7(.Clk(CLK), .Reset(RESET), .Load(LEN3), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .lastD(AES_MSG_EN3_out), .Data_out(AES_MSG_EN3_out));
reg_32DE Reg8(.Clk(CLK), .Reset(RESET), .Load1(LDE0), .Load2(AES_DONE), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .D2(AES_MSG_DEC_out[127:96]), .lastD(AES_MSG_DE0_out), .Data_out(AES_MSG_DE0_out));
reg_32DE Reg9(.Clk(CLK), .Reset(RESET), .Load1(LDE1), .Load2(AES_DONE), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .D2(AES_MSG_DEC_out[95:64]), .lastD(AES_MSG_DE1_out), .Data_out(AES_MSG_DE1_out));
reg_32DE Rega(.Clk(CLK), .Reset(RESET), .Load1(LDE2), .Load2(AES_DONE), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .D2(AES_MSG_DEC_out[63:32]), .lastD(AES_MSG_DE2_out), .Data_out(AES_MSG_DE2_out));
reg_32DE Regb(.Clk(CLK), .Reset(RESET), .Load1(LDE3), .Load2(AES_DONE), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .D2(AES_MSG_DEC_out[31:0]), .lastD(AES_MSG_DE3_out), .Data_out(AES_MSG_DE3_out));
reg_32 Rege(.Clk(CLK), .Reset(RESET), .Load(L_ST), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .lastD(AES_START_out), .Data_out(AES_START_out));
reg_32DE Regf(.Clk(CLK), .Reset(RESET), .Load1(L_DONE), .Load2(AES_DONE), .ByteEN(AVL_BYTE_EN), .D(AVL_WRITEDATA), .D2(AES_DONE), .lastD(AES_DONE_out), .Data_out(AES_DONE_out));

assign EXPORT_DATA = {AES_MSG_DE0_out[31:16], AES_MSG_DE3_out[15:0]};

/////////////////// Add for Week 2 ///////////////////


assign AES_KEY_in = (AES_KEY0_out<<96)|(AES_KEY1_out<<64)|(AES_KEY2_out<<32)|(AES_KEY3_out);
assign AES_MSG_ENC_in = (AES_MSG_EN0_out<<96)|(AES_MSG_EN1_out<<64)|(AES_MSG_EN2_out<<32)|(AES_MSG_EN3_out);

//assign AES_MSG_DE0_out = AES_MSG_DEC_out[127:96];
//assign AES_MSG_DE1_out = AES_MSG_DEC_out[95 :64];
//assign AES_MSG_DE2_out = AES_MSG_DEC_out[63 :32];
//assign AES_MSG_DE3_out = AES_MSG_DEC_out[31 :0 ];

//AES_MSG_DE0_out,AES_MSG_DE1_out,AES_MSG_DE2_out,AES_MSG_DE3_out;
AES aes_decry(
	.CLK(CLK), .RESET(RESET), .AES_START(AES_START_out[0]),
	.AES_DONE(AES_DONE),
	.AES_KEY(AES_KEY_in),
	.AES_MSG_ENC(AES_MSG_ENC_in),
	.AES_MSG_DEC(AES_MSG_DEC_out)
);

//////////////////////////////////////////////////////

endmodule
