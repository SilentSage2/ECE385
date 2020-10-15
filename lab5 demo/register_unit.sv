module register_unit (input  logic Clk, Reset, A_In, B_In, Ld_sum_or_sub, Ld_B, 
                            Shift_En,
                      input  logic [7:0]  D, 
                      output logic A_out, B_out, 
                      output logic [7:0]  A,
                      output logic [7:0]  B);


    reg_8  reg_A (.*, .Shift_In(A_In), .Load(Ld_sum_or_sub),
	               .Shift_Out(A_out), .Data_Out(A));
    reg_8  reg_B (.*, .Shift_In(B_In), .Load(Ld_B),
	               .Shift_Out(B_out), .Data_Out(B));

endmodule