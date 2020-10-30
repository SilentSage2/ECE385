module lab4_8_bit_multiplier_toplevel(
                  input   logic           Clk,        // 50MHz clock is only used to get timing estimate data
                  input   logic           Reset,      // From push-button 0.  Remember the button is active low (0 when pressed)
					   input   logic           ClearA_LoadB,      // From push-button 1.
						input   logic           Run,        // From push-button 3.
						input   logic[7:0]      S,         // From slider switches
						
						// all outputs are registered
						output  logic           X,         // Carry-out.  Goes to the green LED to the left of the hex displays.
						output  logic[6:0]      AhexL,      // Hex drivers display both inputs to the adder.
						output  logic[6:0]      AhexU,
						output  logic[6:0]      BhexL,
						output  logic[6:0]      BhexU,
						output  logic[7:0]      Aval, Bval
						);
						
						
	//local logic variables go here
	logic 			ClrA;
	logic				 X_;
	logic [7:0]     A ;
   logic [7:0]     B ;
	logic           shift_En, Clr_Ld, Fn, ld_A, ld_B;
   logic           hold;
	logic [8:0]     Ain;
   assign X_ = Ain[8];
   logic Reset_SH, ClearA_LoadB_SH, Run_SH;
	logic [7:0] S_syn;
	//assign X = 1b'0;
	
	 control control_(
	                  .Clk(Clk), .Reset(Reset_SH), .ClearA_LoadB(ClearA_LoadB_SH), .Run(Run_SH), 
                     .Shift_En(shift_En), .fn(Fn), .LA(ld_A), .LB(ld_B), .HOLD(hold), .ClrA
							);

	 logic B_shift_in, M; 
	 logic [7:0] M_;
	 logic [7:0] S_;
	 assign M_ = {8{M}};
	 assign S_ = S_syn & M_;
	 assign Aval = A;
	 assign Bval = B; //prepare for testbench
	   
	 adder_subber add_A_S(.fn(Fn), .A(A), .S(S_), .Sum(Ain));
	// substracter  sub_A_S(.en_sub(Sub), .A(A), .S(S_), .Diff(Ain));
		 
	 


    always_ff @(posedge Clk) begin
        
			if (!hold)
				X  <= X_;//Ain[8]
			else 
				X <= X;  //update X only when not in hold state

    end	
	
	 reg_8  reg_A (.Clk(Clk), .Reset(Reset_SH | ClearA_LoadB_SH | ClrA), .Shift_In(X), .Load(ld_A),
                  .Shift_En(shift_En),
                  .D(Ain[7:0]), 
                  .Shift_Out(B_shift_in),
                  .Data_Out(A)
						);
						
	 reg_8  reg_B (.Clk(Clk), .Reset(Reset_SH), .Shift_In(B_shift_in), .Load(ld_B),
                  .Shift_En(shift_En),
                  .D(S), 
                  .Shift_Out(M),
                  .Data_Out(B)
						);	 
	 
    HexDriver AhexL_
    (
        .In0(A[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(AhexL)
    );
    
    HexDriver AhexU_
    (
        .In0(A[7:4]),
        .Out0(AhexU)
    );
    
    HexDriver BhexL_
    (
        .In0(B[3:0]),
        .Out0(BhexL)
    );
    
    HexDriver BhexU_
    (
        .In0(B[7:4]),
        .Out0(BhexU)
    );
	 
	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[2:0] (Clk, {~Reset, ~ClearA_LoadB, ~Run}, {Reset_SH, ClearA_LoadB_SH, Run_SH});
	  sync Din_sync[7:0] (Clk, S, S_syn);

endmodule
