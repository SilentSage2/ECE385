//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,      //SDRAM Clock
				 output logic SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N, SRAM_WE_N,
				 output logic [19:0] SRAM_ADDR,
				 inout wire [15:0] SRAM_DQ,
				 // Mouse
				 inout PS2_CLK, PS2_DAT,
				  // audio controller
             input               AUD_ADCDAT, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK,
             output logic        AUD_DACDAT, AUD_XCK, I2C_SCLK, I2C_SDAT			 
				 
                    );
    assign SRAM_UB_N = 1'b0;
	 assign SRAM_LB_N = 1'b0;
	 assign SRAM_CE_N = 1'b0;
	 assign SRAM_OE_N = 1'b0;
	 assign SRAM_WE_N = 1'b1;
	 
	 
    logic Reset_h, Clk;
    logic [15:0] keycode, keycode1;
//	 wire PS2_CLK, PS2_DAT;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 logic [9:0] DrawX, DrawY;
	 logic is_ball1, is_ball2;
	 logic life_plus1, life_plus2, protect1, protect2, plus1_1, plus1_2, shoe1, shoe2;
	 logic [7:0] disapearcounter1,disapearcounter2;
	 
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc Nios_system (
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),
									  .keycode1_export(keycode1),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
	 
	
	//we need to draw mouse as cursorX and cursorY indicate
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk(Clk), 
	                                        .Reset(Reset_h),      
	                                        .*   );   
	logic [4:0] coloridx;

	logic [3:0] bombstart1, bombstart2;
	logic [3:0][5:0] Xbomb1, Ybomb1, Xbomb2, Ybomb2; //at most 4 bomb
	logic [3:0] bomb_placed1, bomb_exploding1, bomb_exploded1, bomb_on1, bomb_placed2, bomb_exploding2, bomb_exploded2, bomb_on2;
	
	//game_state machine
	logic load_map, load_startpage, display_init;
	logic [0:12*16-1][3:0] map_array, start_array, treasure_array;	
	logic [0:34][7:0] status_array;
	logic [9:0] Ball_X1_Pos, Ball_Y1_Pos, Ball_X2_Pos, Ball_Y2_Pos;

	 logic [3:0] sprite_idx, font_idx, treasure_idx;
	 logic [3:0] Ycoord,Xcoord;
	 logic [4:0] coloridx_ball1, coloridx_ball2, coloridx1, coloridx_bar,coloridx_small_bomb;
	 logic [3:0] player1_lives, player2_lives;
	 logic player1_alive, player2_alive, player1_display, player2_display; //player only display when display is on, can be controlled only when alive
	 logic game_on, game_over, draw_gameover;
	 logic protecting1, protecting2;
	 logic shoe_on1, shoe_on2;
	 
	 logic draw_cursor;
	 logic is_press_start, is_pressed, click_start, is_start_range, click_restart;
	 logic is_bomb, is_bar_left, is_bar_right, is_loading;
	 logic load_finish;
	 logic [7:0] counter;
	 logic start, restart, is_restart;
	 
	 always_comb begin //if in the range and GAME_OVER and counter == 0
	 click_restart = 1'b0;
	 is_restart = 1'b0;
	 if(counter == 0 && 0<=cursorY && cursorY<40)
	 begin
		if(leftButton)
			click_restart = 1'b1;
		else
			is_restart = 1'b1;
	 end
	 end
			
	assign start = ~KEY[1] || click_start;
	assign restart = ~KEY[2] || click_restart;
	 
	 
	game_state game1(.Clk(Clk), .Reset(Reset_h), .load_finish(load_finish||~KEY[1]), .*);



	loading load_page( .*, .Reset(Reset_h),         
                        .frame_clk(VGA_VS), 
								.coloridx(coloridx_small_bomb));
								
	press_start press_start0(.*, .cursorX, .cursorY);
	
	player_state player1_state(.Clk(Clk), .Reset(Reset_h), .VGA_VS, .game_on, .Ball_X_Pos(Ball_X1_Pos),.Ball_Y_Pos(Ball_Y1_Pos),
									.*, .player_lives(player1_lives), .player_alive(player1_alive), .player_display(player1_display), .protecting(protecting1),
									.life_plus(life_plus1), .protect(protect1));

	player_state player2_state(.Clk(Clk), .Reset(Reset_h), .VGA_VS, .game_on, .Ball_X_Pos(Ball_X2_Pos),.Ball_Y_Pos(Ball_Y2_Pos),
										.*, .player_lives(player2_lives), .player_alive(player2_alive), .player_display(player2_display),.protecting(protecting2),
									.life_plus(life_plus2), .protect(protect2));
									
	lifeplus_state life1(.Clk(Clk), .Reset(Reset_h), .VGA_VS, .life_plus(life_plus1), .disapearcounter(disapearcounter1), .plus1(plus1_1));
	lifeplus_state life2(.Clk(Clk), .Reset(Reset_h), .VGA_VS, .life_plus(life_plus2), .disapearcounter(disapearcounter2), .plus1(plus1_2));

	shoe_state shoe1ins(.Clk(Clk), .Reset(Reset_h), .VGA_VS, .shoe(shoe1), .shoe_on(shoe_on1));
	shoe_state shoe2ins(.Clk(Clk), .Reset(Reset_h), .VGA_VS, .shoe(shoe2), .shoe_on(shoe_on2));
//0 ground
//1 brick
//2 wall
//3 bcenter


	 assign Ycoord = DrawY/40;
	 assign Xcoord = DrawX/40;
	 assign sprite_idx = map_array[Ycoord*16+Xcoord];
	 assign treasure_idx = treasure_array[Ycoord*16+Xcoord];
	 //
	 assign font_idx = start_array[Ycoord*16+Xcoord];
	 
	 color_mapper color_instance(.*); //maps to RGB
	 statusbar_mapper bar_instance(.*);  
	 
	 palette palette0(.coloridx, .Rout(VGA_R), .Gout(VGA_G), .Bout(VGA_B));
	 
	/////////////////////// mouse //////////////////////// 
	logic leftButton, middleButton, rightButton;
	logic [9:0] cursorX, cursorY;
	Mouse_interface our_mouse(.*);
	 
	//cursor 20*34 X*Y
	logic [4:0] cursor_color;
	int cursor_subX, cursor_subY;
	assign cursor_subX = DrawX - cursorX ;
	assign cursor_subY = DrawY - cursorY;
	cursor my_cursor(.X(cursor_subX), .Y(cursor_subY), .cursor_color);
	/////////////////////////////////////////////////////
	
	//gameover 150*210 -- 120*168
	parameter gameoverX_start = 10'd235;
	parameter gameoverY_start = 10'd215;
	parameter gameoverX_end = 10'd403;
	parameter gameoverY_end = 10'd335;
	parameter gameoverW = 20'd168;
	parameter gameoverH = 20'd120;
	logic [9:0] gameoverX, gameoverY; 
	assign gameoverX = DrawX-gameoverX_start;
	assign gameoverY = DrawY-gameoverY_start;
	logic [4:0] coloridx_barwrite;
	logic [19:0] background_ADDR;
		assign background_ADDR = {10'b0,DrawY}*20'd640 + {10'b0,DrawX};
	logic [19:0] gameover_ADDR;
		assign gameover_ADDR = {10'b0, gameoverY}*gameoverW + {10'b0,gameoverX} + 20'h4B001;//memory offset
	assign SRAM_ADDR = game_over ? gameover_ADDR : background_ADDR;
	
	////////////////////////////////////////////////////////////////
	
	//draw color for startpage and game under different cases
	//mapper summary
	always_comb 
	begin
	coloridx_barwrite = is_restart ? 5'h3 : coloridx_bar;
	if( (cursor_subX-10)*(cursor_subX-10) < 100 && (cursor_subY-17)*(cursor_subY-17)<289  && cursor_color != 0 && draw_cursor)
		coloridx = cursor_color;
	else if(display_init)
	begin
		if (is_bomb)
			coloridx = coloridx_small_bomb;
		else if (is_bar_left)
			coloridx = 5'ha; //rou yellow
		else if (is_bar_right)
			coloridx = 5'h3; //white
		else if (is_loading)//word
			coloridx = 5'ha; //rou yellow
		else 
			coloridx = SRAM_DQ[4:0];
	end
	else if(load_startpage)
	begin
		if (is_press_start && is_pressed)
			coloridx = 5'ha; //yellow
		else if (is_press_start)
			coloridx = 5'h3;//white
		else if (is_start_range)
			coloridx = 5'h7; //pink
		else
			coloridx = SRAM_DQ[4:0];
	end
		//only if in the range and not black 5'h2, we draw GAME OVER
	else if(draw_gameover && gameoverX_start <= DrawX && DrawX < gameoverX_end && gameoverY_start <= DrawY && DrawY < gameoverY_end && SRAM_DQ[4:0]!=5'h2)
		coloridx = SRAM_DQ[4:0];
	else if(DrawY >= 0 && DrawY < 10'd40)
		coloridx = coloridx_barwrite;
	else if(is_ball1 && player1_display)
		coloridx = coloridx_ball1;
	else if(is_ball2 && player2_display)
		coloridx = coloridx_ball2;
	else
		coloridx = coloridx1;
	end
	
    // Which signal should be frame_clk?
//ball positions

    ball player_ins1(.Clk(Clk),         
                       .Reset(start),       
	                    .frame_clk(VGA_VS),   
							  .player_alive(player1_alive),
							  .coloridx(coloridx_ball1),
							  .is_ball(is_ball1),
							  .Ball_X_Pos(Ball_X1_Pos),
							  .Ball_Y_Pos(Ball_Y1_Pos),
							  .player_id(1'b0),
							  .protecting(protecting1),
							  .shoe_on(shoe_on1),
							  .keycode,
							  .keycode1,
	                    .* ); //add Ball_Pos_X and Y
    ball player_ins2(.Clk(Clk), 
                       .Reset(start),     
	                    .frame_clk(VGA_VS),
							  .player_alive(player2_alive),
							  .coloridx(coloridx_ball2),
							  .is_ball(is_ball2),
							  .Ball_X_Pos(Ball_X2_Pos),
							  .Ball_Y_Pos(Ball_Y2_Pos),
							  .player_id(1'b1),
							  .protecting(protecting2),
							  .shoe_on(shoe_on2),
							  .keycode,
							  .keycode1,
	                    .* ); //add Ball_Pos_X and Y							  
	
   //////////////////////// audio //////////////////////

	logic [18:0] Addr;
	logic [15:0] music_data,data_out_music;
	
	logic	INIT, INIT_FINISH, adc_full, data_over;
	logic [31:0] ADCDATA;

	assign data_out_music = music_data;
	
	audio_interface music(	
									.LDATA(data_out_music),
									.RDATA(data_out_music),
									.clk(Clk),
									.Reset(Reset_h), 
									.INIT(INIT), 									
									.INIT_FINISH(INIT_FINISH), 					
									.adc_full(adc_full), 						
									.data_over(data_over), 						
									.AUD_MCLK(AUD_XCK), 						
									.AUD_BCLK(AUD_BCLK), 						
									.AUD_ADCDAT(AUD_ADCDAT), 					
									.AUD_DACDAT(AUD_DACDAT), 					
									.AUD_DACLRCK(AUD_DACLRCK),
									.AUD_ADCLRCK(AUD_ADCLRCK),
									.I2C_SDAT(I2C_SDAT), 						
									.I2C_SCLK(I2C_SCLK), 						
									.ADCDATA(ADCDATA) 						
									);
	music_control finite_S_M(.*, .Reset(Reset_h), .game_over(game_over), .load_startpage(load_startpage));
	bgm bgm0(.*);
	////////////////////////////////////////////////////
	
//bombs

	 bomb player1bombs(.*, .Reset(Reset_h), .keycode, .keycode1, .Ball_X_Pos(Ball_X1_Pos), .Ball_Y_Pos(Ball_Y1_Pos), .Xbomb(Xbomb1), .Ybomb(Ybomb1), .player_id(1'b0), .bomb_on(bomb_on1), .bombstart(bombstart1));
	 bomb player2bombs(.*, .Reset(Reset_h), .keycode, .keycode1, .Ball_X_Pos(Ball_X2_Pos), .Ball_Y_Pos(Ball_Y2_Pos), .Xbomb(Xbomb2), .Ybomb(Ybomb2), .player_id(1'b1), .bomb_on(bomb_on2), .bombstart(bombstart2));
	 map mapinstance(.*, .X1(Ball_X1_Pos),.Y1(Ball_Y1_Pos),.X2(Ball_X2_Pos),.Y2(Ball_Y2_Pos));
	 
 //bomb_state machines
 //bombs for player1
    bomb_state bomb1state0(.Clk(Clk), .Reset(Reset_h), .VGA_VS(VGA_VS), .bombstart(bombstart1[0]),
									.bomb_placed(bomb_placed1[0]), .bomb_exploding(bomb_exploding1[0]), .bomb_exploded(bomb_exploded1[0]), .bomb_on(bomb_on1[0]));
	 bomb_state bomb1state1(.Clk(Clk), .Reset(Reset_h), .VGA_VS(VGA_VS), .bombstart(bombstart1[1]),
									.bomb_placed(bomb_placed1[1]), .bomb_exploding(bomb_exploding1[1]), .bomb_exploded(bomb_exploded1[1]), .bomb_on(bomb_on1[1]));
    bomb_state bomb1state2(.Clk(Clk), .Reset(Reset_h), .VGA_VS(VGA_VS), .bombstart(bombstart1[2]),
									.bomb_placed(bomb_placed1[2]), .bomb_exploding(bomb_exploding1[2]), .bomb_exploded(bomb_exploded1[2]), .bomb_on(bomb_on1[2]));
    bomb_state bomb1state3(.Clk(Clk), .Reset(Reset_h), .VGA_VS(VGA_VS), .bombstart(bombstart1[3]),
									.bomb_placed(bomb_placed1[3]), .bomb_exploding(bomb_exploding1[3]), .bomb_exploded(bomb_exploded1[3]), .bomb_on(bomb_on1[3]));
	 
	 //bombs for player2
	 bomb_state bomb2state0(.Clk(Clk), .Reset(Reset_h), .VGA_VS(VGA_VS), .bombstart(bombstart2[0]),
									.bomb_placed(bomb_placed2[0]), .bomb_exploding(bomb_exploding2[0]), .bomb_exploded(bomb_exploded2[0]), .bomb_on(bomb_on2[0]));
	 bomb_state bomb2state1(.Clk(Clk), .Reset(Reset_h), .VGA_VS(VGA_VS), .bombstart(bombstart2[1]),
									.bomb_placed(bomb_placed2[1]), .bomb_exploding(bomb_exploding2[1]), .bomb_exploded(bomb_exploded2[1]), .bomb_on(bomb_on2[1]));
    bomb_state bomb2state2(.Clk(Clk), .Reset(Reset_h), .VGA_VS(VGA_VS), .bombstart(bombstart2[2]),
									.bomb_placed(bomb_placed2[2]), .bomb_exploding(bomb_exploding2[2]), .bomb_exploded(bomb_exploded2[2]), .bomb_on(bomb_on2[2]));
    bomb_state bomb2state3(.Clk(Clk), .Reset(Reset_h), .VGA_VS(VGA_VS), .bombstart(bombstart2[3]),
									.bomb_placed(bomb_placed2[3]), .bomb_exploding(bomb_exploding2[3]), .bomb_exploded(bomb_exploded2[3]), .bomb_on(bomb_on2[3]));
							  
    // Display keycode on hex display
    HexDriver hex_inst_0 (player1_lives, HEX0);
    HexDriver hex_inst_1 (player2_lives, HEX1);
    HexDriver hex_inst_2 (game_on, HEX2);
    HexDriver hex_inst_3 (game_over, HEX3);
	 HexDriver hex_inst_4 (keycode1[3:0], HEX4);
    HexDriver hex_inst_5 (keycode1[7:4], HEX5);
    HexDriver hex_inst_6 (cursorX[3:0], HEX6);
    HexDriver hex_inst_7 (counter, HEX7);
	 
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
