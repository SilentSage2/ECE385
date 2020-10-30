module colortable(input [4:0] colortable_in,
						output [7:0] Rout, Gout, Bout
);

logic [7:0] red_wire, blue_wire, green_wire;

always_comb 
begin
	unique case (colortable_in)
		5'h0://white
		begin
			red_wire=8'hff;
			green_wire=8'hff;
			blue_wire=8'hff;
		end
		
		5'h1://light brown
		begin
			red_wire=8'hfb;
			green_wire=8'hc7;
			blue_wire=8'h60;
		end
		
		5'h2://medium brown
		begin
			red_wire=8'hd2;
			green_wire=8'h97;
			blue_wire=8'h31;
		end
		
		5'h3://dark brown
		begin
			red_wire=8'h9A;
			green_wire=8'h61;
			blue_wire=8'h15;
		end
		
		5'h4://light green
		begin
			red_wire=8'h8f;
			green_wire=8'hdf;
			blue_wire=8'h43;
		end
		
		5'h5://medium green
		begin
			red_wire=8'h79;
			green_wire=8'hd6;
			blue_wire=8'h21;
		end
		
		5'h6://dark green
		begin
			red_wire=8'h59;
			green_wire=8'hb2;
			blue_wire=8'h15;
		end
		
		5'h7://light grey
		begin
			red_wire=8'hdb;
			green_wire=8'hdb;
			blue_wire=8'hdb;
		end
		
		5'h8://medium grey
		begin
			red_wire=8'h9a;
			green_wire=8'h9a;
			blue_wire=8'h9a;
		end
		
		5'h9://dark grey
		begin
			red_wire=8'h50;
			green_wire=8'h50;
			blue_wire=8'h50;
		end
		
		5'ha://light blue
		begin
			red_wire=8'h45;
			green_wire=8'hee;
			blue_wire=8'hff;
		end
		
		5'hb://medium blue
		begin
			red_wire=8'h7;
			green_wire=8'h90;
			blue_wire=8'hfd;
		end
		
		5'hc://dark blue
		begin
			red_wire=8'h0;
			green_wire=8'h37;
			blue_wire=8'hfc;
		end
		
		5'hd://red
		begin
			red_wire=8'hff;
			green_wire=8'h00;
			blue_wire=8'h00;
		end
		
		5'he://black
		begin
			red_wire=8'h00;
			green_wire=8'h00;
			blue_wire=8'h00;
		end
		
		5'hf://purple
		begin
			red_wire=8'h8d;
			green_wire=8'h08;
			blue_wire=8'hb5;
		end
		
	endcase
end

assign Rout=red_wire;
assign Gout = green_wire;
assign Bout = blue_wire;

endmodule
