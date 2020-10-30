module adder_subber
(
    input   logic          fn,
    input   logic[7:0]     A,
    input   logic[7:0]     S,
    output  logic[8:0]     Sum
);

	logic [7:0] B;
	
	assign B = {8{fn}}^S;
	
    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	logic [8:0] c;
	
		full_adder fa0(.x(A[0]), .y(B[0]), .cin(fn), .s(Sum[0]), .cout(c[0]));
		full_adder fa1(.x(A[1]), .y(B[1]), .cin(c[0]), .s(Sum[1]), .cout(c[1]));
		full_adder fa2(.x(A[2]), .y(B[2]), .cin(c[1]), .s(Sum[2]), .cout(c[2]));
		full_adder fa3(.x(A[3]), .y(B[3]), .cin(c[2]), .s(Sum[3]), .cout(c[3]));
		full_adder fa4(.x(A[4]), .y(B[4]), .cin(c[3]), .s(Sum[4]), .cout(c[4]));
		full_adder fa5(.x(A[5]), .y(B[5]), .cin(c[4]), .s(Sum[5]), .cout(c[5]));
		full_adder fa6(.x(A[6]), .y(B[6]), .cin(c[5]), .s(Sum[6]), .cout(c[6]));
		full_adder fa7(.x(A[7]), .y(B[7]), .cin(c[6]), .s(Sum[7]), .cout(c[7]));
		
		full_adder fax(.x(A[7]), .y(B[7]), .cin(c[7]), .s(Sum[8]), .cout(c[8]));

endmodule


module full_adder(
                  input x,
                  input y,
                  input cin,
						output logic s,
						output logic cout
                  );
	assign s    = x ^ y ^ cin;
	assign cout = (x&y) | (y&cin) |(cin&x);
	
endmodule
