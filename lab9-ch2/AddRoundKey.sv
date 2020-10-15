module addRoundkey (
			input  logic [127:0] state,
			input  logic [1407:0] KeyS,
			input  logic [3:0] round, //10,9,8,7,6,5,4,3,2,1,0
			output logic [127:0] out
);
logic [127:0] key;

always_comb
begin 
	unique case(round)
		4'b0000:
			key = KeyS[127:0];
		4'b0001:
			key = KeyS[255:128];
		4'b0010:
			key = KeyS[383:256];
		4'b0011:
			key = KeyS[511:384];
		4'b0100:
			key = KeyS[639:512];
		4'b0101:
			key = KeyS[767:640];
		4'b0110:
			key = KeyS[895:768];
		4'b0111:
			key = KeyS[1023:896];
		4'b1000:
			key = KeyS[1151:1024];
		4'b1001:
			key = KeyS[1279:1152];
		4'b1010:
			key = KeyS[1407:1280];
		default:
			key = state;
	endcase
end

assign out = state ^ key;

endmodule 

