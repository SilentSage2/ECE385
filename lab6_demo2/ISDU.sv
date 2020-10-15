//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic   GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
									//SR2_select
				);

	enum logic [4:0] {  Halted, 
						PauseIR1, 
						PauseIR2, 
						S_18, //MAR<-PC, PC<-PC+1
						S_33_1, //MDR <-M[MAR]
						S_33_2, 
						S_35,  //IR<-MDR
						S_32, //decoder
						S_01_ADD, //ADD
						S_05_AND,//AND
						S_09_NOT, //NOT
						S_00_BR, //BR
						S_22_BR,
						S_12_JMP, //JMP
						S_04_JSR, //JSR
						S_21_JSR,
						S_06_LDR, //LDR
						S_25_LDR_1,
						S_25_LDR_2,
						S_27_LDR,
						S_07_STR, //STR
						S_23_STR,
						S_16_STR_1,
						S_16_STR_2
						}   State, Next_state;   // Internal state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b1;
		Mem_WE = 1'b1;
		//SR2_select = 1'b0;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;                      
			S_18 : 
				Next_state = S_33_1;
			// Any states involving SRAM require more than one clock cycles.
			// The exact number will be discussed in lecture.
			S_33_1 : 
				Next_state = S_33_2;
			S_33_2 : 
				Next_state = S_35;
			S_35 : 
				Next_state = S_32;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
			// the values in IR.
//			PauseIR1 : 
//				if (~Continue) 
//					Next_state = PauseIR1;
//				else 
//					Next_state = PauseIR2;
//			PauseIR2 : 
//				if (Continue) 
//					Next_state = PauseIR2;
//				else 
//					Next_state = S_18; //week1 ends
			S_32 : 

				case (Opcode)
					4'b0001 : //ADD
						Next_state = S_01_ADD;

					// You need to finish the rest of opcodes.....
				    4'b0101 : //AND
						Next_state = S_05_AND;
					4'b1001 : //Not
						Next_state = S_09_NOT;
					4'b0000 : //BR
						Next_state = S_00_BR;
					4'b1100 :
						Next_state = S_12_JMP;
					4'b0100 :
						Next_state = S_04_JSR;
					4'b0110:
						Next_state = S_06_LDR;
					4'b0111:
						Next_state = S_07_STR;
					4'b1101:
						Next_state = PauseIR1;
					default : 
						Next_state = S_18;
				endcase
//			S_01_ADD : 
//				Next_state = S_18;
//			S_05_AND :
//				Next_state = S_18;
//			S_09_NOT:
//				Next_state = S_18;
			S_06_LDR:
				Next_state = S_25_LDR_1;
			S_25_LDR_1:
				Next_state = S_25_LDR_2;
			S_25_LDR_2:
				Next_state = S_27_LDR;
			S_07_STR:
				Next_state = S_23_STR;
			S_23_STR:
				Next_state = S_16_STR_1;
			S_16_STR_1:
				Next_state = S_16_STR_2;
			S_04_JSR:
				Next_state = S_21_JSR;
			S_00_BR:
				if (BEN)
					Next_state = S_22_BR;
				else 
					Next_state = S_18;
			PauseIR1:
				if(Continue)
					Next_state = PauseIR2; 
			PauseIR2:
				if(!Continue)
					Next_state = S_18;

			default : 
					Next_state = S_18;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: ;
			S_18 : 
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			S_33_1 : 
				Mem_OE = 1'b0;
			S_33_2 : 
				begin 
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end
			S_35 : 
				begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			PauseIR1: LD_LED = 1'b1;
			PauseIR2: LD_LED = 1'b1;
			S_32 : 
				LD_BEN = 1'b1;
			S_01_ADD : 
				begin 
					//SR2 managed outside
					//SR1 default = 0 [8:6]
					SR2MUX = IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
				end
			S_05_AND : 
				begin 
					//SR2 managed outside
					SR2MUX = IR_5;
					ALUK = 2'b01;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
				end
			S_09_NOT: 
				begin 
					ALUK = 2'b10;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
				end
//			S_00_BR:
//				begin ????
			S_22_BR:
				begin
					ADDR2MUX = 2'b10;
					ADDR1MUX = 1'b0;
					PCMUX = 2'b01;
					LD_PC = 1'b1;
				end
			S_12_JMP:
				begin
					//SR1 = 0
					ADDR1MUX = 1'b1;
					ADDR2MUX = 2'b00;
					PCMUX = 2'b01;
					LD_PC = 1'b1;
				end
			S_04_JSR:
				begin
					//R7 <- PC;
					GatePC = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b1;
					//SR2_select = 1'b1; //select R7 to load
				end
			S_21_JSR:
				begin
					ADDR2MUX = 2'b11;
					ADDR1MUX = 1'b0;
					PCMUX = 2'b01;
					LD_PC = 1'b1;
					//GatePC = 1'b1;
				end
			S_06_LDR:
				//MAR = Rbase + offset6
				//SR1 = 0
				begin
					ADDR1MUX = 1'b1;
					ADDR2MUX = 2'b01;
					GateMARMUX = 1'b1;
					LD_MAR = 1'b1;
				end
			
			S_25_LDR_1:
				Mem_OE = 1'b0;
			S_25_LDR_2 : 
				begin 
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end
			S_27_LDR:
				begin
					GateMDR = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b0;
					LD_CC = 1'b1;
				end
			S_07_STR:
				begin
					ADDR1MUX = 1'b1;
					ADDR2MUX = 2'b01;
					GateMARMUX = 1'b1;
					LD_MAR = 1'b1;
				end
			S_23_STR:
				begin
					SR1MUX = 1'b1;
					ADDR1MUX = 1'b1;
					ADDR2MUX = 2'b00;
					GateMARMUX = 1'b1;
					//Mem_OE = 1'b1;
					LD_MDR = 1'b1;
				end
				
			S_16_STR_1:
				begin
					Mem_WE = 1'b0;
				end
			S_16_STR_2:
				begin
					Mem_WE = 1'b0;
				end			

			default : ;
//				begin
//				end
		endcase
	end 

	 // These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule
