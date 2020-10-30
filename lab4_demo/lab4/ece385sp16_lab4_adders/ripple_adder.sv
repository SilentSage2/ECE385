module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
   
	logic [2:0] c;
	logic c0 = 1'b0;
	four_bit_ra fra0(.x(A[ 3: 0]), .y(B[ 3: 0]), .cin( c0), .s(Sum[ 3: 0]), .cout(c[0]));
	four_bit_ra fra1(.x(A[ 7: 4]), .y(B[ 7: 4]), .cin(c[0]), .s(Sum[ 7: 4]), .cout(c[1]));
	four_bit_ra fra2(.x(A[11: 8]), .y(B[11: 8]), .cin(c[1]), .s(Sum[11: 8]), .cout(c[2]));
	four_bit_ra fra3(.x(A[15:12]), .y(B[15:12]), .cin(c[2]), .s(Sum[15:12]), .cout(CO));
	
endmodule

module four_bit_ra(
                   input[3:0]         x,
					    input[3:0]         y,
					    input              cin,
					    output logic[3:0]  s,
					    output logic       cout	 
                   );
	logic [2:0] c;
	
	full_adder fa0(.x(x[0]), .y(y[0]), .cin(cin), .s(s[0]), .cout( c[0] ));
	full_adder fa1(.x(x[1]), .y(y[1]), .cin(c[0] ), .s(s[1]), .cout( c[1] ));
	full_adder fa2(.x(x[2]), .y(y[2]), .cin(c[1] ), .s(s[2]), .cout( c[2] ));
	full_adder fa3(.x(x[3]), .y(y[3]), .cin(c[2] ), .s(s[3]), .cout(cout));
	
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
