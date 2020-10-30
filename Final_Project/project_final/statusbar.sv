module statusbar_mapper(
				input [9:0] DrawX, DrawY,
				input [0:35][7:0]status_array,
				output [4:0] coloridx_bar);

parameter [5:0] Xstart = 6'd40;
parameter [5:0] Ystart = 6'd22;
parameter [5:0] Xend = 6'd639;
parameter [5:0] Yend = 6'd38;

parameter [5:0] size = 6'd16;

logic [10:0] addr;
logic [7:0] data, ascii;

logic [5:0] Xidx;
logic [4:0] subX, subY;

logic [4:0] color;

//calculate addr to get data
assign Xidx = (DrawX - Xstart)/16;
assign subX = (DrawX - Xstart)%16;
assign subY = DrawY/20 - 5'd2;
assign ascii = status_array[Xidx];
assign addr = ascii * 8'd8 + subY;

always_comb 
begin

if(data[8-1-subX] == 1)
	color = 5'h3;
else
	color = 5'h7;

if(DrawY < Ystart || DrawY > Yend || DrawX < Xstart || DrawX > Xend || subX < 5'd4 || subX > 5'd11)
	coloridx_bar = 5'h7; //pink
else
	coloridx_bar = color;
	
end

font_rom my_font(.*);

endmodule




