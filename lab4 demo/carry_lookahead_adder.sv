module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

	logic [2:0] c;
	logic [3:0] pg;
	logic [3:0] gg;
	logic c0 = 1'b0;

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	
	g_p_adder gpa0(.x(A[3:0]), .y(B[3:0]), .cin(c0), .s(Sum[3:0]), .P_G(pg[0]), .G_G(gg[0]));
	assign c[0] = (c0 & pg[0]) | gg[0];

	g_p_adder gpa1(.x(A[7:4]), .y(B[7:4]), .cin(c[0]), .s(Sum[7:4]), .P_G(pg[1]), .G_G(gg[1]));
	assign c[1] = gg[1] | (gg[0] & pg[1]) | (c0 & pg[0] & pg[1]);
	
	g_p_adder gpa2(.x(A[11:8]), .y(B[11:8]), .cin(c[1]), .s(Sum[11:8]), .P_G(pg[2]), .G_G(gg[2]));
	assign c[2] = gg[2] | (gg[1] & pg[2]) | (gg[0] & pg[2] & pg[1]) | (c0 & pg[2] & pg[1] & pg[0]);
	
	g_p_adder gpa3(.x(A[15:12]), .y(B[15:12]), .cin(c[2]), .s(Sum[15:12]), .P_G(pg[3]), .G_G(gg[3]));
	assign CO = gg[3] | (gg[2] & pg[3]) | (gg[1]&pg[3]&pg[2]) | (gg[0]&pg[3]&pg[2]&pg[1]) | (c0&pg[3]&pg[2]&pg[1]&pg[0]);
	  
     
endmodule


module g_p_adder(
                  input[3:0]           x,
                  input[3:0]           y,
                  input 	            cin,
						output logic [3:0]   s,
						output logic         P_G,
						output logic         G_G
                  );
						
	logic [3:0]    g;
	logic [3:0]    p;
	logic [3:0]    c;
	always_comb
	begin  
			for (int i = 0; i<=3;i++) begin
					g[i] = x[i] & y[i];
					p[i] = x[i] ^ y[i];
					end
	end
	
	always_comb 
	begin
	c[0] = cin;
	c[1] = (cin & p[0]) | g[0];
	c[2] = (cin & p[0] & p[1]) | (g[0] & p[1]) | g[1];
	c[3] = (cin & p[0] & p[1] & p[2]) | (g[0] & p[1] & p[2]) | (g[1] & p[2]) | g[2];
	P_G  = p[0] & p[1] & p[2] & p[3];
	G_G  = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);
	end
	
	always_comb
	begin  
			for (int i = 0; i<=3;i++) begin
					s[i] = x[i] ^ y[i] ^ c[i];
					end
	end
endmodule

