//------------------------------------------------------------------------------
// Company:        UIUC ECE Dept.
// Engineer:       Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 10-19-2017 
//    spring 2018 Distribution
//
//------------------------------------------------------------------------------
module slc3(
    input logic [15:0] S,
    input logic Clk, Reset, Run, Continue,
    output logic [11:0] LED,
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
    output logic CE, UB, LB, OE, WE,
    output logic [19:0] ADDR,
    inout wire [15:0] Data //tristate buffers need to be of type wire
);

// Declaration of push button active high signals
logic Reset_ah, Continue_ah, Run_ah;

//assign Reset_ah = ~Reset;
//assign Continue_ah = ~Continue;
//assign Run_ah = ~Run;

// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX;
logic MIO_EN;

logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC;
logic [15:0] Data_from_SRAM, Data_to_SRAM;
//databus
logic [15:0] bus_data, S_syn;
//muxes output
logic [15:0] ALU_out, ADDR2MUX_out, ADDR1MUX_out, PCMUX_out, MDRMUX_out;
logic [15:0] adder_out, SR2MUX_out, SR2_OUT, SR1_OUT;
logic [2:0] SR2, DRMUX_out, SR1MUX_out, NZP, nzp;
logic BEN, BEN_in;

//logic SR2_select;

// Signals being displayed on hex display
logic [3:0][3:0] hex_4;
assign nzp = IR[11:9];
assign SR2 = IR[2:0];
assign BEN_in = (NZP[2]&nzp[2]) || (NZP[1]&nzp[1]) || (NZP[0]&nzp[0]);
//adder
assign adder_out = ADDR2MUX_out + ADDR1MUX_out;
//SR2_select:
//always_comb begin
//	if(SR2_select)
//		SR2 = 3'b111;
//	else
//		SR2 = IR[2:0];
//end


PC_MUX pcmux(.*);
//PC_next pcnext(.*);
ALU_MUX alu(.*);
DatabusMUX databusmux(.*);
SR1_MUX sr1mux(.*);
SR2_MUX sr2mux(.*);
DR_MUX drmux(.*);
setBEN setben(.*);
ADDR2_MUX addr2mux(.*);
ADDR1_MUX addr1mux(.*);
setCC setcc(.*);


// For week 1, hexdrivers will display IR. Comment out these in week 2.
//HexDriver hex_driver3 (IR[15:12], HEX3);
//HexDriver hex_driver2 (IR[11:8], HEX2);
//HexDriver hex_driver1 (IR[7:4], HEX1);
//HexDriver hex_driver0 (IR[3:0], HEX0);
always_comb begin
 if(LD_LED)
	LED = IR[11:0] ;
 else LED = 12'b0;
end
 // For week 2, hexdrivers will be mounted to Mem2IO
 HexDriver hex_driver3 (hex_4[3][3:0], HEX3);
 HexDriver hex_driver2 (hex_4[2][3:0], HEX2);
 HexDriver hex_driver1 (hex_4[1][3:0], HEX1);
 HexDriver hex_driver0 (hex_4[0][3:0], HEX0);

// The other hex display will show PC for both weeks.
HexDriver hex_driver7 (PC[15:12], HEX7);
HexDriver hex_driver6 (PC[11:8], HEX6);
HexDriver hex_driver5 (PC[7:4], HEX5);
HexDriver hex_driver4 (PC[3:0], HEX4);

// Connect MAR to ADDR, which is also connected as an input into MEM2IO.
// MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
// input into MDR)
//always
assign ADDR = { 4'b00, MAR }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
assign MIO_EN = ~OE;

reg_16 MARreg(.Clk(Clk), .Reset(Reset_ah), .Load(LD_MAR), .D(bus_data), .Data_out(MAR));
reg_16 IRreg(.Clk(Clk), .Reset(Reset_ah), .Load(LD_IR), .D(bus_data), .Data_out(IR));
reg_16 MDRreg(.Clk(Clk), .Reset(Reset_ah), .Load(LD_MDR), .D(MDRMUX_out), .Data_out(MDR));
reg_16 PCreg(.Clk(Clk), .Reset(Reset_ah), .Load(LD_PC), .D(PCMUX_out), .Data_out(PC));

// You need to make your own datapath module and connect everything to the datapath
// Be careful about whether Reset is active high or low
datapath d0(.*);//output: MAR, MDR, PC
reg_file reg_file_unit(.*);

// Our SRAM and I/O controller
Mem2IO memory_subsystem(
    .*, .Reset(Reset_ah), .ADDR(ADDR), .Switches(S_syn),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// The tri-state buffer serves as the interface between Mem2IO and SRAM
tristate #(.N(16)) tr0(
    .Clk(Clk), .tristate_output_enable(~WE), .Data_write(Data_to_SRAM), .Data_read(Data_from_SRAM), .Data(Data)
);

// State machine and control signals
ISDU state_controller(
    .*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah),
    .Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
    .Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE)
//	 .SR2_select(SR2_select)
);
sync button_sync[2:0] (Clk, {~Reset, ~Continue, ~Run}, {Reset_ah, Continue_ah, Run_ah});
sync Din_sync[15:0] (Clk, S, S_syn);


endmodule
