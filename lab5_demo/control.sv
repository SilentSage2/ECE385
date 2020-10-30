module control(
               input  logic Clk, Reset, ClearA_LoadB, Run,
               output logic Shift_En, fn, LA, LB, HOLD, ClrA
					);
					

    enum logic [4:0] {NEW, H1,Hold_SH,ClrA_LdB, A7,Sh8,A6,Sh7,A5,Sh6,A4,Sh5,A3,Sh4,A2,Sh3,A1,Sh2,S1,Sh1,ClearA}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Reset) begin
            curr_state <= H1; //not hold X<=X_;
        end else
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
        
		  next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        unique case (curr_state) 
            NEW :  if (Run)
                       next_state = ClearA;
						 else if (ClearA_LoadB)
							  next_state = ClrA_LdB;
				ClrA_LdB:
						 if (!ClearA_LoadB)
								next_state = NEW;
				ClearA:  next_state = A7;
            A7 :   next_state = Sh8;
            Sh8 :  next_state = A6;
            A6 :   next_state = Sh7;
            Sh7 :  next_state = A5;
            A5 :   next_state = Sh6;
				Sh6 :  next_state = A4;
				A4 :	 next_state = Sh5;
				Sh5 :	 next_state = A3;
				A3:	 next_state = Sh4;
				Sh4 :	 next_state = A2;
				A2:	 next_state = Sh3;
				Sh3 :	 next_state = A1;
				A1:	 next_state = Sh2;
				Sh2 :	 next_state = S1;
				S1:	 next_state = Sh1;
				Sh1 :	 next_state = Hold_SH;
				H1:    if (!Run)
				          next_state = NEW; //H1 not hold, X renew to 0
				Hold_SH: if (!Run)
							next_state = NEW;
        endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   Hold_SH,NEW: 
	         begin
				    fn = 1'b0;
                Shift_En = 1'b0;
					 LA = 1'b0;
					 LB = 1'b0;
					 HOLD = 1'b1;
					 ClrA = 0;
		      end
				
	   	   H1: 
	         begin
				    fn = 1'b0;
                Shift_En = 1'b0;
					 LA = 1'b0;
					 LB = 1'b0;
					 HOLD = 1'b0;
					 ClrA = 0;
		      end
				
				ClearA:
				begin
					 fn = 1'b0;
                Shift_En = 1'b0;
					 LA = 1'b0;
					 LB = 1'b0;
					 HOLD = 1'b1;
					 ClrA = 1;
				end
				
				ClrA_LdB:
				begin
				   fn = 1'b0;
					Shift_En = 1'b0;
					LA = 1'b0;
					LB = 1'b1;
					HOLD = 1'b1;
					ClrA = 1;
				end
				
				A7,A6,A5,A4,A3,A2,A1:
				begin
				    fn = 1'b0;
                Shift_En = 1'b0;
					 LA = 1'b1;
					 LB = 1'b0;
					 HOLD = 1'b0;
					 ClrA = 0;
			   end
				
	   	   Sh8,Sh7,Sh6,Sh5,Sh4,Sh3,Sh2: 
		      begin
				    fn = 1'b0;
                Shift_En = 1'b1;
					 LA = 1'b0;
					 LB = 1'b0;
					 HOLD = 1'b0;
					 ClrA = 0;
		      end
				
				Sh1:
		      begin
				    fn = 1'b0;
                Shift_En = 1'b1;
					 LA = 1'b0;
					 LB = 1'b0;
					 HOLD = 1'b1;
					 ClrA = 0;
		      end
				
				
	   	   S1: 
		      begin
				    fn = 1'b1;
                Shift_En = 1'b0;
					 LA = 1'b1;
					 LB = 1'b0;
					 HOLD = 1'b0;
					 ClrA = 0;
		      end

//	   	   default:  //default case, can also have default assignments for Ld_A and Ld_B before case
//		      begin 
//				    fn = 1'b0;
//                Shift_En = 1'b1;
//					 LA = 1'b0;
//					 LB = 1'b0;
//		      end
				
        endcase
    end

endmodule
