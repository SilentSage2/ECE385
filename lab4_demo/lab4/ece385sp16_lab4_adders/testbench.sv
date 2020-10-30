module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;
logic Reset, LoadA, LoadB, Run, SW;
logic CO;
logic [15:0] Sum;
logic [6:0] Ahex0, Ahex1, Ahex2, Ahex3, Bhex0, Bhex1, Bhex2, Bhex3;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
//Processor processor0(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 


lab4_adders_toplevel tp(.*);

initial begin: TEST_VECTORS

Reset = 0;
LoadB = 1;
Run = 1;


//test case1
#2 Reset = 1;

#2 LoadB = 0;
	SW = 16'h0001;

#2 LoadB = 1;
	SW = 16'h0002;
	
#2 Run = 0;

#22;
end
endmodule


