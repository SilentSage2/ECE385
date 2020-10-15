/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);


logic [3:0] round; //11 times, 0-10 already help us to inverse in the keySchedule (KeyExpansion)
logic [1407:0] KeySchedule;
logic [127:0] state, state_in;
logic [127:0] new_state, invShift_state, invMixCol_state, invSub_state;
logic [3:0] key_wait; //or logic???
logic [31:0] MixCol_IN, MixCol_OUT;
logic [1:0] mixcol_select;
logic [2:0] state_select; //for mux controller
logic LD_state, LD_wait, LD_round, LD_MSG_DEC, reset, LD_done, LD_invmix, reset_export;
//logic load_invmix;
//logic [1:0] subEn;
enum logic [3:0] {  
						WAIT,
						KEY_EXPANSION, 
						ADD_ROUND_KEY_INIT,
						SHIFT_ROWS,
						SUB_BYTES, 
						SUB_BYTES_FINAL,
						ADD_ROUND_KEY,
						MIX_COLS_0,
						MIX_COLS_1,
						MIX_COLS_2,
						MIX_COLS_3,
						MIX_COLS,
						ADD_ROUND_KEY_FINAL,
						DONE
						} curr_state, next_state;
//modules to call
KeyExpansion 	KeyExpansion(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KeySchedule));//output KeySchedule
addRoundkey AddRoundKey(.state(state), .round(round), .KeyS(KeySchedule), .out(new_state));
InvShiftRows InvShiftRows(.data_in(state), .data_out(invShift_state));
InvMixColumns InvMixColumns(.in(MixCol_IN), .out(MixCol_OUT));
//reg128 mixcolreg(.*,.Load(load_invmix),.subEN(mixcol_select),.D_sub(MixCol_OUT),.D(invMixCol_state),.Data_out(invMixCol_state));
Inv_sub	InvSub(.clk(CLK), .in(state), .out(invSub_state));
//MUXes

MixColumn_MUX mixcolmux(.in3(state[127:96]),
								.in2(state[95:64]),
								.in1(state[63:32]),
								.in0(state[31:0]),
								.select(mixcol_select),
								.out(MixCol_IN));
state_MUX statemux(.in0(AES_MSG_ENC), //00
							.in1(new_state), //01
							.in2(invShift_state), //10
							.in3(invSub_state), //11
							.in4(invMixCol_state), //100
							.select(state_select),
							.out(state_in));
//registers
reg_state statereg(.*, .Load(LD_state), .Din(state_in), .Dreset(AES_MSG_ENC), .Data_out(state));
reg_MSG msgdecreg(.*, .RESET(reset), .Load(LD_MSG_DEC), .Din(state), .Data_out(AES_MSG_DEC));
reg_128 mixcolreg(.*, .Load(LD_invmix), .Din(invMixCol_state), .D_sub(MixCol_OUT),.subEn(mixcol_select),.Data_out(invMixCol_state));
reg_4_up roundreg(.*, .Load(LD_round), .Din(round), .Data_out(round));  //increase when load
reg_4_down keywaitreg(.*, .Load(LD_wait), .Din(key_wait), .Data_out(key_wait));//decrease when load
reg_1 donereg(.*, .RESET(reset), .Load(LD_done), .Data_out(AES_DONE));
   always_ff @ (posedge CLK)
    begin
        if (RESET) begin
            curr_state <= WAIT; //not hold X<=X_;
        end 
		  else
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
   begin
	 //if not changed in current state, these are the default values
      mixcol_select = 2'b00; 
		state_select = 3'b000;
		LD_state = 1'b0;
		LD_MSG_DEC = 1'b0;
		LD_wait = 1'b0;
		LD_round = 1'b0;
		LD_done = 1'b0;
		LD_invmix = 1'b0;
		reset = 1'b0;
		reset_export = 1'b0;
		//round = round;  registers
		//key_wait = key_wait;
      //state = state;

		next_state  = curr_state;	//required because I haven't enumerated all possibilities below

		unique case(curr_state)
         WAIT:
				begin
				if (AES_START)
					next_state = KEY_EXPANSION;
				end
			KEY_EXPANSION: //wait for 44 cycles
				begin
				if (key_wait == 6'b00) //else next_state = curr_state
					next_state = ADD_ROUND_KEY_INIT;
				end
			ADD_ROUND_KEY_INIT:
				begin
					next_state = SHIFT_ROWS;
					//round = 1;
				end
			SHIFT_ROWS:
				begin
					if(round == 4'b1010)
						next_state = SUB_BYTES_FINAL;
					else
						next_state = SUB_BYTES;
				end
			SUB_BYTES:
				begin
					next_state = ADD_ROUND_KEY;
				end
			ADD_ROUND_KEY:
				begin
				//	round = round + 1; //round = 2,3,4,...,10
					next_state = MIX_COLS_0;
				end
			MIX_COLS_0:
				begin
					next_state = MIX_COLS_1;
				end
			MIX_COLS_1:
				begin
					next_state = MIX_COLS_2;
				end
			MIX_COLS_2:
				begin
					next_state = MIX_COLS_3;
				end
			MIX_COLS_3:
				begin
					next_state = MIX_COLS;
				end
			MIX_COLS:
				begin
					next_state = SHIFT_ROWS;
				end			
			
			SUB_BYTES_FINAL:
				begin
					next_state = ADD_ROUND_KEY_FINAL;
				end
			ADD_ROUND_KEY_FINAL:
				begin
					next_state = DONE;
				end
			DONE:
				begin
					if(AES_START == 1'b0)
						next_state = WAIT;
				end
			default: ;
			
		endcase


	case(curr_state)
		WAIT: 
		begin 
			reset = 1'b1; //reset round = 0, key_wait = 44
			//reset DONE
		end
			
		KEY_EXPANSION: //input output is always key and keySchedule
		begin 
			LD_wait = 1'b1;
			//reset_export = 1'b1; //control MSG_DEC, till here reset = 0
		end
			
		ADD_ROUND_KEY_INIT,ADD_ROUND_KEY_FINAL:
		begin
			state_select = 3'b001;
			LD_state = 1'b1;
			LD_round = 1'b1;
		end
		
		ADD_ROUND_KEY:
		begin
			state_select = 3'b001;
			LD_state = 1'b1;
			LD_round = 1'b1;
		end
		
		SHIFT_ROWS:
		begin
			state_select = 3'b010;
			LD_state = 1'b1;
		end
		
		SUB_BYTES, SUB_BYTES_FINAL:
		begin
			state_select = 3'b011;
			LD_state = 1'b1;
		end
		
		MIX_COLS_0:
		begin
			mixcol_select = 2'b00;
			LD_invmix = 1'b1;
			//invMixCol_state[31:0] = MixCol_OUT;
		end
		
		MIX_COLS_1:
		begin
			mixcol_select = 2'b01;
			LD_invmix = 1'b1;
			//invMixCol_state[63:32] = MixCol_OUT;
		end
		
		MIX_COLS_2:
		begin
			mixcol_select = 2'b10;
			LD_invmix = 1'b1;
			//invMixCol_state[95:64] = MixCol_OUT;
		end
		
		MIX_COLS_3:
		begin
			mixcol_select = 2'b11;
			LD_invmix = 1'b1; //invmix 128 bit update
			//state_select = 3'b100;
			//LD_state = 1'b1; //state update
			//MinvMixCol_state[127:96] = MixCol_OUT;
		end
		MIX_COLS:
		begin
			state_select = 3'b100;
			LD_state = 1'b1;
		end
		
		DONE:
		begin
			LD_done = 1'b1;
			LD_MSG_DEC = 1'b1;
		end
		default: ;
		
	endcase
	end
endmodule
		
