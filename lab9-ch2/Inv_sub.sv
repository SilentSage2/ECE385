module Inv_sub (
			input  logic clk,
			input  logic [127:0] in,
			output logic [127:0] out
);

InvSubBytes sub1(.*, .in(in[127:120]), .out(out[127:120]));
InvSubBytes sub2(.*, .in(in[119:112]), .out(out[119:112]));
InvSubBytes sub3(.*, .in(in[111:104]), .out(out[111:104]));
InvSubBytes sub4(.*, .in(in[103:96]), .out(out[103:96]));
InvSubBytes sub5(.*, .in(in[95:88]), .out(out[95:88]));
InvSubBytes sub6(.*, .in(in[87:80]), .out(out[87:80]));
InvSubBytes sub7(.*, .in(in[79:72]), .out(out[79:72]));
InvSubBytes sub8(.*, .in(in[71:64]), .out(out[71:64]));
InvSubBytes sub9(.*, .in(in[63:56]), .out(out[63:56]));
InvSubBytes sub10(.*, .in(in[55:48]), .out(out[55:48]));
InvSubBytes sub11(.*, .in(in[47:40]), .out(out[47:40]));
InvSubBytes sub12(.*, .in(in[39:32]), .out(out[39:32]));
InvSubBytes sub13(.*, .in(in[31:24]), .out(out[31:24]));
InvSubBytes sub14(.*, .in(in[23:16]), .out(out[23:16]));
InvSubBytes sub15(.*, .in(in[15:8]), .out(out[15:8]));
InvSubBytes sub16(.*, .in(in[7:0]), .out(out[7:0]));

endmodule
