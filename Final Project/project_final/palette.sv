module palette(input [4:0] coloridx,
					output [7:0] Rout, Gout, Bout
);

always_comb 
begin
	unique case (coloridx)
		5'h0://ground color
		begin
			Rout=8'hf9;
			Gout=8'he5;
			Bout=8'h98;
		end
		
		5'h1://grey
		begin
			Rout=8'hc8;
			Gout=8'hc8;
			Bout=8'hc8;
		end
		
		5'h2://black
		begin
			Rout=8'h17;
			Gout=8'h17;
			Bout=8'h17;
		end
		
		5'h3://white
		begin

			Rout=8'hff;
			Gout=8'hff;
			Bout=8'hff;
		end
		
		5'h4://Red
		begin
			Rout=8'hc0;
			Gout=8'h2b;
			Bout=8'he;
		end
		
		5'h5://Orange
		begin
			Rout=8'hf9;
			Gout=8'h7d;
			Bout=8'h6c;
		end
		
		5'h6://light orange
		begin
			Rout=8'hfd;
			Gout=8'hbd;
			Bout=8'hb5;
		end
		
		5'h7://Pink
		begin
			Rout=8'heb;
			Gout=8'h64;
			Bout=8'h88;
		end
		
		5'h8://Light pink
		begin
			Rout=8'hea;
			Gout=8'h9c;
			Bout=8'hbd;
		end
		
		5'h9://rou
		begin
			Rout=8'hfc;
			Gout=8'hf0;
			Bout=8'he6;
		end
		
		5'ha://rou yellow
		begin
			Rout=8'hff;
			Gout=8'he1;
			Bout=8'haa;
		end
		
		5'hb://blue
		begin
			Rout=8'h48;
			Gout=8'h52;
			Bout=8'hd1;
		end
		
		5'hc://light blue
		begin
			Rout=8'hb1;
			Gout=8'hba;
			Bout=8'he9;
		end
		
		5'hd://glass
		begin
			Rout=8'hd1;
			Gout=8'hcf;
			Bout=8'he0;
		end
		
		5'he://brown
		begin
			Rout=8'hc5;
			Gout=8'h9f;
			Bout=8'h61;
		end
		
		5'hf://purple
		begin
			Rout=8'h63;
			Gout=8'h1b;
			Bout=8'hb4;
		end
		
		5'h10://light purple
		begin
			Rout=8'he8;
			Gout=8'h5d;
			Bout=8'hec;
		end
		
		5'h11://
		begin
			Rout=8'h8b;
			Gout=8'ha8;
			Bout=8'h8f;
		end
		
		5'h12://
		begin
			Rout=8'h5a;
			Gout=8'h61;
			Bout=8'h5a;
		end
		
		5'h13://
		begin
			Rout=8'hd9;
			Gout=8'had;
			Bout=8'h91;
		end
		
		5'h14:// Grey2
		begin
			Rout=8'ha2;
			Gout=8'ha2;
			Bout=8'ha2;
		end
		5'h15:// blue
		begin
			Rout=8'h2a;
			Gout=8'h49;
			Bout=8'hed;
		end
		5'h16:// Dark red
		begin
			Rout=8'h86;
			Gout=8'h32;
			Bout=8'h23;
		end
		
		5'h17:// red2
		begin
			Rout=8'hc4;
			Gout=8'h5a;
			Bout=8'h47;
		end
		
		5'h18:// red3
		begin
			Rout=8'hf1;
			Gout=8'h9b;
			Bout=8'h7b;
		end
		
		5'h19: //red4
		begin
			Rout=8'hf5;
			Gout=8'hbc;
			Bout=8'ha2;
		end
		5'h1a: //red5
		begin
			Rout=8'hf7;
			Gout=8'hcf;
			Bout=8'hb2;
		end
				
	endcase
end


endmodule
