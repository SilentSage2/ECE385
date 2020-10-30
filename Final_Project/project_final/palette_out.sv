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
		
		5'h3://while
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
		
		5'h5://Pink
		begin
			Rout=8'hf9;
			Gout=8'h7d;
			Bout=8'h6c;
		end
		
		5'h6://dark green
		begin
			Rout=8'h59;
			Gout=8'hb2;
			Bout=8'h15;
		end
		
		5'h7://light grey
		begin
			Rout=8'hdb;
			Gout=8'hdb;
			Bout=8'hdb;
		end
		
		5'h8://medium grey
		begin
			Rout=8'h9a;
			Gout=8'h9a;
			Bout=8'h9a;
		end
		
		5'h9://dark grey
		begin
			Rout=8'h50;
			Gout=8'h50;
			Bout=8'h50;
		end
		
		5'ha://light blue
		begin
			Rout=8'h45;
			Gout=8'hee;
			Bout=8'hff;
		end
		
		5'hb://medium blue
		begin
			Rout=8'h7;
			Gout=8'h90;
			Bout=8'hfd;
		end
		
		5'hc://dark blue
		begin
			Rout=8'h0;
			Gout=8'h37;
			Bout=8'hfc;
		end
		
		5'hd://red
		begin
			Rout=8'hff;
			Gout=8'h00;
			Bout=8'h00;
		end
		
		5'he://black
		begin
			Rout=8'h00;
			Gout=8'h00;
			Bout=8'h00;
		end
		
		5'hf://purple
		begin
			Rout=8'h8d;
			Gout=8'h08;
			Bout=8'hb5;
		end
		
	endcase
end


endmodule
