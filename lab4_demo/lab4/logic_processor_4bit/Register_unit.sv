module register_unit (input  logic Clk, Reset, A_In, B_In, Ld_A, Ld_B, 
                            Shift_En,                     /////// generated from control logic , to enable shifting
                      input  logic [7:0]  D,              /////// modified 8-bit shift register PARALLEL LOAD
                      output logic A_out, B_out,          /////// right most output bit after shifting
                      output logic [7:0]  A,              /////// modified 8-bit shift register OUTPUT A
                      output logic [7:0]  B);             /////// modified 8-bit shift register OUTPUT B


    reg_4  reg_A (.*, .Shift_In(A_In), .Load(Ld_A),
	               .Shift_Out(A_out), .Data_Out(A));
    reg_4  reg_B (.*, .Shift_In(B_In), .Load(Ld_B),
	               .Shift_Out(B_out), .Data_Out(B));

endmodule
