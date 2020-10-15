module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.

logic [127:0] state;
logic RESET, CLK, AES_START,AES_DONE;
logic [127:0] AES_KEY, AES_MSG_ENC, AES_MSG_DEC;


//middle
logic [3:0] round, curr_state; //11 times, 0-10 already help us to inverse in the keySchedule (KeyExpansion)
logic [1407:0] KeySchedule;
logic [127:0] state_in;
logic [127:0] new_state, invShift_state, invMixCol_state, invSub_state;
logic [6:0] key_wait; //or logic???
logic [31:0] MixCol_IN, MixCol_OUT;
logic [1:0] mixcol_select, state_select; //for mux controller
logic LD_state, LD_wait, LD_round, LD_MSG_DEC, reset, LD_done, LD_invmix, reset_export;
	
// A counter to count the instances where simulation results
// do no match with expected results
//integer ErrorCnt = 0;

// Instantiating the DUT
// Make sure the module and signal names match with those in your design
AES my_aes(.*);

assign state = my_aes.state;
assign state_in = my_aes.state_in;
assign round = my_aes.round;
assign KeySchedule = my_aes.KeySchedule;
assign state_select = my_aes.state_select;
assign mixcol_select = my_aes.mixcol_select;
assign curr_state = my_aes.curr_state;
assign LD_state = my_aes.LD_state;
assign LD_done = my_aes.LD_done;
assign LD_invmix = my_aes.LD_invmix;
assign LD_wait = my_aes.LD_wait;
assign LD_round = my_aes.LD_round;
assign LD_MSG_DEC = my_aes.LD_MSG_DEC;
assign reset_export = my_aes.reset_export;
assign invShift_state = my_aes.invShift_state;
assign invSub_state = my_aes.invSub_state;
assign new_state = my_aes.new_state;
assign invMixCol_state = my_aes.invMixCol_state;
assign key_wait = my_aes.key_wait;
assign MixCol_IN = my_aes.MixCol_IN;
assign MixCol_OUT = my_aes.MixCol_OUT;

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
RESET = 1;		// Toggle loadB clearA
AES_START = 0;
AES_MSG_ENC = 128'hdaec3055df058e1c39e814ea76f6747e;
AES_KEY = 128'h000102030405060708090a0b0c0d0e0f;
//S = 8'h1;	// Specify S --load into B
#4
RESET = 0;

#4 AES_START = 1;
//#2 AES_START = 0;

#1000;

end

endmodule
