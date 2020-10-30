module substracter
(
    input   logic          en_sub,
    input   logic[7:0]     A,
    input   logic[7:0]     S,
    output  logic[8:0]     Diff
);
	logic [8:0] temp_diff; 

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */ 
	  
	logic [8:0] c;
	logic [7:0] S_; 
	assign S_ = ~S;
		
		full_adder fa0(.x(A[0]), .y(S_[0]), .cin(1), .s(temp_diff[0]), .cout(c[0]));
		full_adder fa1(.x(A[1]), .y(S_[1]), .cin(c[0]), .s(temp_diff[1]), .cout(c[1]));
		full_adder fa2(.x(A[2]), .y(S_[2]), .cin(c[1]), .s(temp_diff[2]), .cout(c[2]));
		full_adder fa3(.x(A[3]), .y(S_[3]), .cin(c[2]), .s(temp_diff[3]), .cout(c[3]));
		full_adder fa4(.x(A[4]), .y(S_[4]), .cin(c[3]), .s(temp_diff[4]), .cout(c[4]));
		full_adder fa5(.x(A[5]), .y(S_[5]), .cin(c[4]), .s(temp_diff[5]), .cout(c[5]));
		full_adder fa6(.x(A[6]), .y(S_[6]), .cin(c[5]), .s(temp_diff[6]), .cout(c[6]));
		full_adder fa7(.x(A[7]), .y(S_[7]), .cin(c[6]), .s(temp_diff[7]), .cout(c[7]));
		
		full_adder fax(.x(A[7]), .y(S_[7]), .cin(c[7]), .s(temp_diff[8]), .cout(c[8]));	
	always_comb begin 	
		
	if (en_sub) 
		Diff = temp_diff;
	else
		Diff = {A[7], A};
		
	end
endmodule
