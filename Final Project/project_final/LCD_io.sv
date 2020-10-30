module LCD_io(
	input logic Clk, Reset,
	output logic LCD_RS, LCD_RW, LCD_E,
	output logic [7:0]  LCD_data
	);
	
logic data_ready;
logic [7:0] data_buffer;


always_ff @ (posedge Clk)
begin
    if(Reset)
    begin
        from_sw_data_out_buffer <= 16'h0000;
        OTG_ADDR                <= 2'b00;
        OTG_RD_N                <= 1'b1;
        OTG_WR_N                <= 1'b1;
        OTG_CS_N                <= 1'b1;
        OTG_RST_N               <= 1'b1;
        from_sw_data_in         <= 16'h0000;
    end
    else 
    begin
        from_sw_data_out_buffer <= from_sw_data_out;
        OTG_ADDR                <= from_sw_address;
        OTG_RD_N                <= from_sw_r;
        OTG_WR_N                <= from_sw_w;
        OTG_CS_N                <= from_sw_cs;
        OTG_RST_N               <= from_sw_reset;
        from_sw_data_in         <= OTG_DATA;
    end
end

// OTG_DATA should be high Z (tristated) when NIOS is not writing to OTG_DATA inout bus.
// Look at tristate.sv in lab 6 for an example.
assign OTG_DATA = from_sw_w? 16'hzzzz : from_sw_data_out_buffer;

endmodule 