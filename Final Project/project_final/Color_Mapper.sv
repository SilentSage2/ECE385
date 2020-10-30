//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color(idx) to be output to VGA for an input X and Y position
//if is_ball = 0, use this coloridx; if is_ball = 1, use the coloridx from ball.sv
module  color_mapper ( 
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input			[3:0] sprite_idx, treasure_idx, font_idx,
							  input load_map, load_startpage,
                       output logic [4:0] coloridx1 // VGA RGB output
							  //input logic  is_ball //use color dark green coloridx 5'h6
                     );
   logic [4:0] wall_color, brick_color, ground_color, bombcenter_color, bomb_color, liquid_color, hat_color, O_colorout, B_colorout, player1_color, player2_color,
					bup_color, blow_color, bright_color, bleft_color, shoe_color;
	assign ground_color = 5'h0;
	logic [5:0] subX, subY;
	assign subX = DrawX%40;
	assign subY = DrawY%40;
	
	wall wallins(.wall_X(subX), .wall_Y(subY), .*);
	bomb_sprite bombins(.X(subX), .Y(subY), .*);
	bombcenter bcenterins(.bcenter_X(subX), .bcenter_Y(subY), .*);
	brick brickins(.brick_X(subX), .brick_Y(subY), .*);	
	bup bup_ins(.X(subX), .Y(subY), .*);
	blow blow_ins(.X(subX), .Y(subY), .*);
	bright bright_ins(.X(subX), .Y(subY), .*);
	bleft bleft_ins(.X(subX), .Y(subY), .*);
	
	//treasure array
	liquid liquidins(.X(subX), .Y(subY), .*);
	hat hatins(.X(subX), .Y(subY), .*);
	shoe shoeins(.X(subX), .Y(subY), .*);
	
	//for startpage
//	player1_front figure_ins0(.player1_X(subX), .player1_Y(subY), .player1_color(player1_color));
//	player2_front figure_ins1(.player2_X(subX), .player2_Y(subY), .player2_color(player2_color));	
//	
	
	//for init page
	//init initialpage(.X(DrawX), .Y(DrawY), .colorout(coloridx3));
	
//0 ground
//1 brick
//2 wall
//3 bcenter
//4 player1
//5 player2
//6 bomb
//7 bup
//8 blow
//9 bright
//10 bleft
	
always_comb 
begin
		case(sprite_idx)
		4'h0:
		begin
			case(treasure_idx)
			4'h1:
				coloridx1 = liquid_color;
			4'h2:
				coloridx1 = hat_color;
			4'h3:
				coloridx1 = shoe_color;
			default: coloridx1 = ground_color;
			endcase
		end
		4'h1: //brick
			coloridx1 = brick_color; 
		4'h2: //wall
			coloridx1 = wall_color;
		4'h3: //bcenter
			coloridx1 = bombcenter_color;
		4'h6:// bomb
			coloridx1 = bomb_color;
		4'h7://bup
			coloridx1 = bup_color;
		4'h8://blow
			coloridx1 = blow_color;
		4'h9://bright
			coloridx1 = bright_color;
		4'ha://bleft
			coloridx1 = bleft_color;
		default: coloridx1 = ground_color;
		endcase
		
//		case(font_idx)
//		4'h0:
//			coloridx2 = 5'h0;
//		4'h1: //B
//			coloridx2 = B_colorout;
//		4'h2: //O
//			coloridx2 = O_colorout;
//		4'h3: //player1
//			coloridx2 = player1_color;
//		4'h4: //player2
//			coloridx2 = player2_color;
//			
//		default: coloridx2 = ground_color;
//		endcase
		

end
 
endmodule
