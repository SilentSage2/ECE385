module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);
	logic [1:0] cin = { 1'b1, 1'b0};
	logic [2:0] c1, c0;
	logic c4, c8, c12;
	logic [15:0] s1,s2;
    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  four_bit_ra cra0(.x(A[3:0]), .y(B[3:0]), .cin(cin[0]), .s(Sum[3:0]), .cout(c4));

	  four_bit_ra cra1(.x(A[7:4]), .y(B[7:4]), .cin(cin[0]), .s(s1[7:4]), .cout(c0[0]));
	  four_bit_ra cra2(.x(A[7:4]), .y(B[7:4]), .cin(cin[1]), .s(s2[7:4]), .cout(c1[0]));
always_comb begin
	  if (c4 == 0 )
			Sum[7:4] = s1[7:4];
		else
			Sum[7:4] = s2[7:4];
	end
	assign c8 = c0[0] | (c1[0] & c4);
	  
	  
	  four_bit_ra cra3(.x(A[11:8]), .y(B[11:8]), .cin(cin[0]), .s(s1[11:8]), .cout(c0[1]));
	  four_bit_ra cra4(.x(A[11:8]), .y(B[11:8]), .cin(cin[1]), .s(s2[11:8]), .cout(c1[1]));	
always_comb begin
if (c8 == 0 )
	Sum[11:8] = s1[11:8];
else
	Sum[11:8] = s2[11:8];
end
	assign c12 = c0[1] | (c1[1] & c8);
	    

	  four_bit_ra cra5(.x(A[15:12]), .y(B[15:12]), .cin(cin[0]), .s(s1[15:12]), .cout(c0[2]));
	  four_bit_ra cra6(.x(A[15:12]), .y(B[15:12]), .cin(cin[1]), .s(s2[15:12]), .cout(c1[2]));	  
always_comb begin
	  if (c12 == 0 )
			Sum[15:12] = s1[15:12];
		else
			Sum[15:12] = s2[15:12];
end
	assign CO = c0[2] | (c1[2] & c12);	  
     
endmodule



//module router (input  logic  cin,
//               input  logic [3:0] s0, s1,
//               output logic [3:0] out
//					);
//	
//	always_comb
//	begin
//		unique case (cin)
//	 	   1'b0   : out = s0;
//		   1'b1   : out = s1;
//	  	 endcase
//	end
//	
//endmodule
