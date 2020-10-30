module map(input logic Clk,
				input logic load_map,
				output logic [0:12*16-1][3:0] map_array, treasure_array,
				output [0:34][7:0] status_array,
				input [3:0][5:0] Xbomb1, Ybomb1, Xbomb2, Ybomb2,
				input [3:0] bomb_placed1, bomb_placed2,
				input [3:0] bomb_exploding1, bomb_exploding2,
				input [3:0] bomb_exploded1, bomb_exploded2,
				input [3:0] player1_lives, player2_lives,
				input game_over,
				output life_plus1, life_plus2, protect1, protect2,shoe1,shoe2,
				input plus1_1, plus1_2, 
				input [7:0] counter,
				input [7:0] disapearcounter1,disapearcounter2,
				input [9:0] X1, Y1, X2, Y2

				);
				
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

logic [5:0] treasureX1, treasureY1, treasureX2, treasureY2;
assign treasureX1 = X1/40;
assign treasureY1 = Y1/40;
assign treasureX2 = X2/40;
assign treasureY2 = Y2/40;

parameter [3:0] bcenter = 4'h3;
parameter [3:0] bomb = 4'h6;
parameter [3:0] bup = 4'h7;
parameter [3:0] blow = 4'h8;
parameter [3:0] bright = 4'h9;
parameter [3:0] bleft = 4'ha;
//parameter [3:0] brick = 4'h1;
parameter [5:0] Ymax = 6'd12;
parameter [9:0] Xmax = 6'd16;

parameter[0:12*16-1][3:0] origin_map = {
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, //print lives and record

4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0,  
4'h0, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h0, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h0,
4'h1, 4'h2, 4'h1, 4'h1, 4'h1, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h1, 4'h1, 4'h1, 4'h2, 4'h1, 
4'h1, 4'h2, 4'h0, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h0, 4'h2, 4'h1, 
4'h1, 4'h0, 4'h1, 4'h2, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h2, 4'h1, 4'h0, 4'h0, 
4'h1, 4'h0, 4'h0, 4'h1, 4'h1, 4'h2, 4'h2, 4'h1, 4'h1, 4'h2, 4'h2, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 
4'h0, 4'h2, 4'h0, 4'h2, 4'h0, 4'h1, 4'h0, 4'h1, 4'h1, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h2, 4'h0, 
4'h0, 4'h2, 4'h0, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h0, 4'h2, 4'h1, 
4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h2, 4'h1, 
4'h0, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h0, 4'h0, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h2, 4'h0, 
4'h1, 4'h0, 4'h1, 4'h1, 4'h1, 4'h1, 4'h0, 4'h1, 4'h1, 4'h1, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0 
};


parameter[0:12*16-1][3:0] treasure_map = {
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0,
4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h1, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h3, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h3, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h3, 4'h0, 
4'h1, 4'h3, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h3, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0

};


parameter [0:34][7:0] statusbar = {
8'h53, 8'h43, 8'h4f, 8'h52, 8'h45, 8'h20, 8'h50, 8'h4c, 8'h41, 8'h59, 8'h45, 8'h52, 8'h20, 8'h31, 8'h20, 8'h3a, 8'h33,//16 th 
 8'h0, 8'h0, 8'h0, 8'h0,
 8'h50, 8'h4c, 8'h41, 8'h59, 8'h45, 8'h52, 8'h20, 8'h32, 8'h0, 8'h3a, 8'h0, 8'h33,8'h0, 8'h0
//8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53,8'h53
};

parameter [0:34][9:0] restart = {// PRESS TO RESTART
8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,
8'h50, 8'h52, 8'h45, 8'h53, 8'h53, 8'h20, 8'h54, 8'h4f, 8'h20, 8'h52, 8'h45, 8'h53, 8'h54, 8'h41, 8'h52, 8'h54,//16
8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0}; //35

parameter [0:34][9:0] tie = {//THIS IS A TIE!
8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,
8'h54, 8'h48, 8'h49, 8'h53, 8'h20, 8'h49, 8'h53, 8'h20, 8'h41, 8'h20, 8'h54, 8'h49, 8'h45, 8'h21,
8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0};

				
always_ff@(posedge Clk)
begin
	//restart game
	if(load_map)
	begin
		map_array <= origin_map;
		treasure_array <=treasure_map;
		status_array <= statusbar;
	end
	
	if(counter != 0)
	begin
	if(game_over && player1_lives==0 && player2_lives!=0) //player1 lose, player2 win
		status_array[32:34] <= {8'h57, 8'h49, 8'h4e};
	else if(game_over && player2_lives==0 && player1_lives!=0) //player2 lose, player1 win
		status_array[16:18] <= {8'h57, 8'h49, 8'h4e};
	else if(game_over && player2_lives == player1_lives)
		status_array <= tie;
	end
	else //if counter == 0
		status_array <= restart;//not displaying the player's score anymore
		
		
		
	if(plus1_1 && !game_over)
	begin
		if(disapearcounter1==8'h20)//not yet start dispearing
		begin
			status_array[16]<= player1_lives-1 + 8'h30;
			status_array[17]<= 8'h2b;
			status_array[18]<= 8'h31;
		end
		else
		begin
			status_array[16]<= 8'h0;
			status_array[17]<= 8'h0;
			status_array[18]<= 8'h0;
		end
		
	end
	
	else if(!game_over)//plus1_1 != 1 draw only if game is not over
		status_array[16]<= player1_lives + 8'h30;
		
	if(plus1_2 && !game_over)
	begin
		if(disapearcounter2==8'h20)
		begin
			status_array[32]<= player2_lives -1 + 8'h30;
			status_array[33]<= 8'h2b;
			status_array[34]<= 8'h31;
		end
		else
		begin
			status_array[32]<= 8'h0;
			status_array[33]<= 8'h0;
			status_array[34]<= 8'h0;
		end
		
	end
	else if(!game_over)//plus1_2 != 1
		status_array[32]<= player2_lives + 8'h30;

	
	
	
//treasure array
	if(treasure_array[treasureY1*16+treasureX1] != 0)
	begin
		if(treasure_array[treasureY1*16+treasureX1] == 4'h1)
			life_plus1 <= 1;
		else if(treasure_array[treasureY1*16+treasureX1] == 4'h2)
			protect1 <= 1;
		else if(treasure_array[treasureY1*16+treasureX1] == 4'h3)
			shoe1 <= 1;
		treasure_array[treasureY1*16+treasureX1] <= 4'h0;
	end
	else
	begin
		life_plus1 <= 0;
		protect1<= 0;
		shoe1 <= 0;
	end
	
	
	if(treasure_array[treasureY2*16+treasureX2] != 0)
	begin
		if(treasure_array[treasureY2*16+treasureX2] == 4'h1)
			life_plus2 <= 1;
		else if(treasure_array[treasureY2*16+treasureX2] == 4'h2)
			protect2 <= 1;
		else if(treasure_array[treasureY2*16+treasureX2] == 4'h3)
			shoe2 <= 1;
		treasure_array[treasureY2*16+treasureX2] <= 4'h0;
	end
	else
	begin
		life_plus2 <= 0;
		protect2 <= 0;
		shoe2 <= 0;
	end
	
	
	
	
		
//player1
	//placed
	if(bomb_placed1[0])
		map_array[16*Ybomb1[0]+Xbomb1[0]] <= bomb;
	if(bomb_placed1[1])
		map_array[16*Ybomb1[1]+Xbomb1[1]] <= bomb;
	if(bomb_placed1[2])
		map_array[16*Ybomb1[2]+Xbomb1[2]] <= bomb;
	if(bomb_placed1[3])
		map_array[16*Ybomb1[3]+Xbomb1[3]] <= bomb;
		
	//if exploding
	if(bomb_exploding1[0])
	begin
		map_array[16*Ybomb1[0]+Xbomb1[0]] <= bcenter;
		if(Ybomb1[0]-1 >0 && origin_map[16*(Ybomb1[0]-1)+Xbomb1[0]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[0]-1)+Xbomb1[0]] <= bup;
		if(Ybomb1[0]+1 < Ymax && origin_map[16*(Ybomb1[0]+1)+Xbomb1[0]] != 4'h2)
			map_array[16*(Ybomb1[0]+1)+Xbomb1[0]] <= blow;
		if(Xbomb1[0]+1 < Xmax && origin_map[16*Ybomb1[0]+Xbomb1[0]+1] != 4'h2)
			map_array[16*Ybomb1[0]+Xbomb1[0]+1] <= bright;
		if(Xbomb1[0] > 6'b0 && origin_map[16*Ybomb1[0]+Xbomb1[0]-1] != 4'h2)
			map_array[16*Ybomb1[0]+Xbomb1[0]-1] <= bleft;
	end
	
	if(bomb_exploding1[1])
	begin
		map_array[16*Ybomb1[1]+Xbomb1[1]] <= bcenter;
		if(Ybomb1[1]-1 >0 && origin_map[16*(Ybomb1[1]-1)+Xbomb1[1]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[1]-1)+Xbomb1[1]] <= bup;
		if(Ybomb1[1]+1 < Ymax && origin_map[16*(Ybomb1[1]+1)+Xbomb1[1]] != 4'h2)
			map_array[16*(Ybomb1[1]+1)+Xbomb1[1]] <= blow;
		if(Xbomb1[1]+1 < Xmax && origin_map[16*Ybomb1[1]+Xbomb1[1]+1] != 4'h2)
			map_array[16*Ybomb1[1]+Xbomb1[1]+1] <= bright;
		if(Xbomb1[1] > 6'b0 && origin_map[16*Ybomb1[1]+Xbomb1[1]-1] != 4'h2)
			map_array[16*Ybomb1[1]+Xbomb1[1]-1] <= bleft;
	end	
	
	if(bomb_exploding1[2])
	begin
		map_array[16*Ybomb1[2]+Xbomb1[2]] <= bcenter;
		if(Ybomb1[2]-1 >0 && origin_map[16*(Ybomb1[2]-1)+Xbomb1[2]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[2]-1)+Xbomb1[2]] <= bup;
		if(Ybomb1[2]+1 < Ymax && origin_map[16*(Ybomb1[2]+1)+Xbomb1[2]] != 4'h2)
			map_array[16*(Ybomb1[2]+1)+Xbomb1[2]] <= blow;
		if(Xbomb1[2]+1 < Xmax && origin_map[16*Ybomb1[2]+Xbomb1[2]+1] != 4'h2)
			map_array[16*Ybomb1[2]+Xbomb1[2]+1] <= bright;
		if(Xbomb1[2] > 6'b0 && origin_map[16*Ybomb1[2]+Xbomb1[2]-1] != 4'h2)
			map_array[16*Ybomb1[2]+Xbomb1[2]-1] <= bleft;
	end	
	
	if(bomb_exploding1[3])
	begin
		map_array[16*Ybomb1[3]+Xbomb1[3]] <= bcenter;
		if(Ybomb1[3]-1 >0 && origin_map[16*(Ybomb1[3]-1)+Xbomb1[3]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[3]-1)+Xbomb1[3]] <= bup;
		if(Ybomb1[3]+1 < Ymax && origin_map[16*(Ybomb1[3]+1)+Xbomb1[3]] != 4'h2)
			map_array[16*(Ybomb1[3]+1)+Xbomb1[3]] <= blow;
		if(Xbomb1[3]+1 < Xmax && origin_map[16*Ybomb1[3]+Xbomb1[3]+1] != 4'h2)
			map_array[16*Ybomb1[3]+Xbomb1[3]+1] <= bright;
		if(Xbomb1[3] > 6'b0 && origin_map[16*Ybomb1[3]+Xbomb1[3]-1] != 4'h2)
			map_array[16*Ybomb1[3]+Xbomb1[3]-1] <= bleft;
	end
	
	//some problem
	
	if(bomb_exploded1[0])
		begin
		map_array[16*Ybomb1[0]+Xbomb1[0]] <= 4'h0;
		if(Ybomb1[0]-1 >0 && origin_map[16*(Ybomb1[0]-1)+Xbomb1[0]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[0]-1)+Xbomb1[0]] <= 4'h0;
		else if(origin_map[16*(Ybomb1[0]-1)+Xbomb1[0]] == 4'h2)
			map_array[16*(Ybomb1[0]-1)+Xbomb1[0]] <= 4'h2;
		if(Ybomb1[0]+1 < Ymax && origin_map[16*(Ybomb1[0]+1)+Xbomb1[0]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[0]+1)+Xbomb1[0]] <= 4'h0;
		else if (origin_map[16*(Ybomb1[0]+1)+Xbomb1[0]] == 4'h2)
			map_array[16*(Ybomb1[0]+1)+Xbomb1[0]] <= 4'h2;
		if(Xbomb1[0]+1 < Xmax && origin_map[16*Ybomb1[0]+Xbomb1[0]+1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb1[0]+Xbomb1[0]+1] <= 4'h0;
		else if(origin_map[16*Ybomb1[0]+Xbomb1[0]+1] == 4'h2)
			map_array[16*Ybomb1[0]+Xbomb1[0]+1] <= 4'h2;
		if(Xbomb1[0]-1 >= 0 && origin_map[16*Ybomb1[0]+Xbomb1[0]-1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb1[0]+Xbomb1[0]-1] <= 4'h0;
		else if(origin_map[16*Ybomb1[0]+Xbomb1[0]-1] == 4'h2 )
			map_array[16*Ybomb1[0]+Xbomb1[0]-1] <= 4'h2;
		end
	if(bomb_exploded1[1])
		begin
		map_array[16*Ybomb1[1]+Xbomb1[1]] <= 4'h0;
		if(Ybomb1[1]-1 >0 && origin_map[16*(Ybomb1[1]-1)+Xbomb1[1]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[1]-1)+Xbomb1[1]] <= 4'h0;
		else if(origin_map[16*(Ybomb1[1]-1)+Xbomb1[1]] == 4'h2)
			map_array[16*(Ybomb1[1]-1)+Xbomb1[1]] <= 4'h2;
		if(Ybomb1[1]+1 < Ymax && origin_map[16*(Ybomb1[1]+1)+Xbomb1[1]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[1]+1)+Xbomb1[1]] <= 4'h0;
		else if (origin_map[16*(Ybomb1[1]+1)+Xbomb1[1]] == 4'h2)
			map_array[16*(Ybomb1[1]+1)+Xbomb1[1]] <= 4'h2;
		if(Xbomb1[1]+1 < Xmax && origin_map[16*Ybomb1[1]+Xbomb1[1]+1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb1[1]+Xbomb1[1]+1] <= 4'h0;
		else if(origin_map[16*Ybomb1[1]+Xbomb1[1]+1] == 4'h2)
			map_array[16*Ybomb1[1]+Xbomb1[1]+1] <= 4'h2;
		if(Xbomb1[1]-1 >= 0 && origin_map[16*Ybomb1[1]+Xbomb1[1]-1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb1[1]+Xbomb1[1]-1] <= 4'h0;
		else if(origin_map[16*Ybomb1[1]+Xbomb1[1]-1] == 4'h2 )
			map_array[16*Ybomb1[1]+Xbomb1[1]-1] <= 4'h2;
		end
		

	if(bomb_exploded1[2])
		begin
		map_array[16*Ybomb1[2]+Xbomb1[2]] <= 4'h0;
		if(Ybomb1[2]-1 >0 && origin_map[16*(Ybomb1[2]-1)+Xbomb1[2]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[2]-1)+Xbomb1[2]] <= 4'h0;
		else if(origin_map[16*(Ybomb1[2]-1)+Xbomb1[2]] == 4'h2)
			map_array[16*(Ybomb1[2]-1)+Xbomb1[2]] <= 4'h2;
		if(Ybomb1[2]+1 < Ymax && origin_map[16*(Ybomb1[2]+1)+Xbomb1[2]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[2]+1)+Xbomb1[2]] <= 4'h0;
		else if (origin_map[16*(Ybomb1[2]+1)+Xbomb1[2]] == 4'h2)
			map_array[16*(Ybomb1[2]+1)+Xbomb1[2]] <= 4'h2;
		if(Xbomb1[2]+1 < Xmax && origin_map[16*Ybomb1[2]+Xbomb1[2]+1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb1[2]+Xbomb1[2]+1] <= 4'h0;
		else if(origin_map[16*Ybomb1[2]+Xbomb1[2]+1] == 4'h2)
			map_array[16*Ybomb1[2]+Xbomb1[2]+1] <= 4'h2;
		if(Xbomb1[2]-1 >= 0 && origin_map[16*Ybomb1[2]+Xbomb1[2]-1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb1[2]+Xbomb1[2]-1] <= 4'h0;
		else if(origin_map[16*Ybomb1[2]+Xbomb1[2]-1] == 4'h2 )
			map_array[16*Ybomb1[2]+Xbomb1[2]-1] <= 4'h2;
		end
	if(bomb_exploded1[3])
		begin
		map_array[16*Ybomb1[3]+Xbomb1[3]] <= 4'h0;
		if(Ybomb1[3]-1 >0 && origin_map[16*(Ybomb1[3]-1)+Xbomb1[3]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[3]-1)+Xbomb1[3]] <= 4'h0;
		else if(origin_map[16*(Ybomb1[3]-1)+Xbomb1[3]] == 4'h2)
			map_array[16*(Ybomb1[3]-1)+Xbomb1[3]] <= 4'h2;
		if(Ybomb1[3]+1 < Ymax && origin_map[16*(Ybomb1[3]+1)+Xbomb1[3]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb1[3]+1)+Xbomb1[3]] <= 4'h0;
		else if (origin_map[16*(Ybomb1[3]+1)+Xbomb1[3]] == 4'h2)
			map_array[16*(Ybomb1[3]+1)+Xbomb1[3]] <= 4'h2;
		if(Xbomb1[3]+1 < Xmax && origin_map[16*Ybomb1[3]+Xbomb1[3]+1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb1[3]+Xbomb1[3]+1] <= 4'h0;
		else if(origin_map[16*Ybomb1[3]+Xbomb1[3]+1] == 4'h2)
			map_array[16*Ybomb1[3]+Xbomb1[3]+1] <= 4'h2;
		if(Xbomb1[3]-1 >= 0 && origin_map[16*Ybomb1[3]+Xbomb1[3]-1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb1[3]+Xbomb1[3]-1] <= 4'h0;
		else if(origin_map[16*Ybomb1[3]+Xbomb1[3]-1] == 4'h2 )
			map_array[16*Ybomb1[3]+Xbomb1[3]-1] <= 4'h2;
		end

//player2
	//placed
	if(bomb_placed2[0])
		map_array[16*Ybomb2[0]+Xbomb2[0]] <= bomb;
	if(bomb_placed2[1])
		map_array[16*Ybomb2[1]+Xbomb2[1]] <= bomb;
	if(bomb_placed2[2])
		map_array[16*Ybomb2[2]+Xbomb2[2]] <= bomb;
	if(bomb_placed2[3])
		map_array[16*Ybomb2[3]+Xbomb2[3]] <= bomb;
		
	//if exploding
	if(bomb_exploding2[0])
	begin
		map_array[16*Ybomb2[0]+Xbomb2[0]] <= bcenter;
		if(Ybomb2[0]-1 >0 && origin_map[16*(Ybomb2[0]-1)+Xbomb2[0]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[0]-1)+Xbomb2[0]] <= bup;
		if(Ybomb2[0]+1 < Ymax && origin_map[16*(Ybomb2[0]+1)+Xbomb2[0]] != 4'h2)
			map_array[16*(Ybomb2[0]+1)+Xbomb2[0]] <= blow;
		if(Xbomb2[0]+1 < Xmax && origin_map[16*Ybomb2[0]+Xbomb2[0]+1] != 4'h2)
			map_array[16*Ybomb2[0]+Xbomb2[0]+1] <= bright;
		if(Xbomb2[0] > 6'b0 && origin_map[16*Ybomb2[0]+Xbomb2[0]-1] != 4'h2)
			map_array[16*Ybomb2[0]+Xbomb2[0]-1] <= bleft;
	end
	
	if(bomb_exploding2[1])
	begin
		map_array[16*Ybomb2[1]+Xbomb2[1]] <= bcenter;
		if(Ybomb2[1]-1 >0 && origin_map[16*(Ybomb2[1]-1)+Xbomb2[1]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[1]-1)+Xbomb2[1]] <= bup;
		if(Ybomb2[1]+1 < Ymax && origin_map[16*(Ybomb2[1]+1)+Xbomb2[1]] != 4'h2)
			map_array[16*(Ybomb2[1]+1)+Xbomb2[1]] <= blow;
		if(Xbomb2[1]+1 < Xmax && origin_map[16*Ybomb2[1]+Xbomb2[1]+1] != 4'h2)
			map_array[16*Ybomb2[1]+Xbomb2[1]+1] <= bright;
		if(Xbomb2[1] > 6'b0 && origin_map[16*Ybomb2[1]+Xbomb2[1]-1] != 4'h2)
			map_array[16*Ybomb2[1]+Xbomb2[1]-1] <= bleft;
	end	
	
	if(bomb_exploding2[2])
	begin
		map_array[16*Ybomb2[2]+Xbomb2[2]] <= bcenter;
		if(Ybomb2[2]-1 >0 && origin_map[16*(Ybomb2[2]-1)+Xbomb2[2]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[2]-1)+Xbomb2[2]] <= bup;
		if(Ybomb2[2]+1 < Ymax && origin_map[16*(Ybomb2[2]+1)+Xbomb2[2]] != 4'h2)
			map_array[16*(Ybomb2[2]+1)+Xbomb2[2]] <= blow;
		if(Xbomb2[2]+1 < Xmax && origin_map[16*Ybomb2[2]+Xbomb2[2]+1] != 4'h2)
			map_array[16*Ybomb2[2]+Xbomb2[2]+1] <= bright;
		if(Xbomb2[2]-1 >0 && origin_map[16*Ybomb2[2]+Xbomb2[2]-1] != 4'h2)
			map_array[16*Ybomb2[2]+Xbomb2[2]-1] <= bleft;
	end	
	
	if(bomb_exploding2[3])
	begin
		map_array[16*Ybomb2[3]+Xbomb2[3]] <= bcenter;
		if(Ybomb2[3]-1 >0 && origin_map[16*(Ybomb2[3]-1)+Xbomb2[3]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[3]-1)+Xbomb2[3]] <= bup;
		if(Ybomb2[3]+1 < Ymax && origin_map[16*(Ybomb2[3]+1)+Xbomb2[3]] != 4'h2)
			map_array[16*(Ybomb2[3]+1)+Xbomb2[3]] <= blow;
		if(Xbomb2[3]+1 < Xmax && origin_map[16*Ybomb2[3]+Xbomb2[3]+1] != 4'h2)
			map_array[16*Ybomb2[3]+Xbomb2[3]+1] <= bright;
		if(Xbomb2[3] > 6'b0 && origin_map[16*Ybomb2[3]+Xbomb2[3]-1] != 4'h2)
			map_array[16*Ybomb2[3]+Xbomb2[3]-1] <= bleft;
	end
	
	//some problem
	
	if(bomb_exploded2[0])
		begin
		map_array[16*Ybomb2[0]+Xbomb2[0]] <= 4'h0;
		if(Ybomb2[0]-1 >0 && origin_map[16*(Ybomb2[0]-1)+Xbomb2[0]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[0]-1)+Xbomb2[0]] <= 4'h0;
		else if(origin_map[16*(Ybomb2[0]-1)+Xbomb2[0]] == 4'h2)
			map_array[16*(Ybomb2[0]-1)+Xbomb2[0]] <= 4'h2;
		if(Ybomb2[0]+1 < Ymax && origin_map[16*(Ybomb2[0]+1)+Xbomb2[0]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[0]+1)+Xbomb2[0]] <= 4'h0;
		else if (origin_map[16*(Ybomb2[0]+1)+Xbomb2[0]] == 4'h2)
			map_array[16*(Ybomb2[0]+1)+Xbomb2[0]] <= 4'h2;
		if(Xbomb2[0]+1 < Xmax && origin_map[16*Ybomb2[0]+Xbomb2[0]+1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb2[0]+Xbomb2[0]+1] <= 4'h0;
		else if(origin_map[16*Ybomb2[0]+Xbomb2[0]+1] == 4'h2)
			map_array[16*Ybomb2[0]+Xbomb2[0]+1] <= 4'h2;
		if(Xbomb2[0]-1 >= 0 && origin_map[16*Ybomb2[0]+Xbomb2[0]-1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb2[0]+Xbomb2[0]-1] <= 4'h0;
		else if(origin_map[16*Ybomb2[0]+Xbomb2[0]-1] == 4'h2 )
			map_array[16*Ybomb2[0]+Xbomb2[0]-1] <= 4'h2;
		end
	if(bomb_exploded2[1])
		begin
		map_array[16*Ybomb2[1]+Xbomb2[1]] <= 4'h0;
		if(Ybomb2[1]-1 >0 && origin_map[16*(Ybomb2[1]-1)+Xbomb2[1]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[1]-1)+Xbomb2[1]] <= 4'h0;
		else if(origin_map[16*(Ybomb2[1]-1)+Xbomb2[1]] == 4'h2)
			map_array[16*(Ybomb2[1]-1)+Xbomb2[1]] <= 4'h2;
		if(Ybomb2[1]+1 < Ymax && origin_map[16*(Ybomb2[1]+1)+Xbomb2[1]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[1]+1)+Xbomb2[1]] <= 4'h0;
		else if (origin_map[16*(Ybomb2[1]+1)+Xbomb2[1]] == 4'h2)
			map_array[16*(Ybomb2[1]+1)+Xbomb2[1]] <= 4'h2;
		if(Xbomb2[1]+1 < Xmax && origin_map[16*Ybomb2[1]+Xbomb2[1]+1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb2[1]+Xbomb2[1]+1] <= 4'h0;
		else if(origin_map[16*Ybomb2[1]+Xbomb2[1]+1] == 4'h2)
			map_array[16*Ybomb2[1]+Xbomb2[1]+1] <= 4'h2;
		if(Xbomb2[1]-1 >= 0 && origin_map[16*Ybomb2[1]+Xbomb2[1]-1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb2[1]+Xbomb2[1]-1] <= 4'h0;
		else if(origin_map[16*Ybomb2[1]+Xbomb2[1]-1] == 4'h2 )
			map_array[16*Ybomb2[1]+Xbomb2[1]-1] <= 4'h2;
		end
		

	if(bomb_exploded2[2])
		begin
		map_array[16*Ybomb2[2]+Xbomb2[2]] <= 4'h0;
		if(Ybomb2[2]-1 >0 && origin_map[16*(Ybomb2[2]-1)+Xbomb2[2]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[2]-1)+Xbomb2[2]] <= 4'h0;
		else if(origin_map[16*(Ybomb2[2]-1)+Xbomb2[2]] == 4'h2)
			map_array[16*(Ybomb2[2]-1)+Xbomb2[2]] <= 4'h2;
		if(Ybomb2[2]+1 < Ymax && origin_map[16*(Ybomb2[2]+1)+Xbomb2[2]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[2]+1)+Xbomb2[2]] <= 4'h0;
		else if (origin_map[16*(Ybomb2[2]+1)+Xbomb2[2]] == 4'h2)
			map_array[16*(Ybomb2[2]+1)+Xbomb2[2]] <= 4'h2;
		if(Xbomb2[2]+1 < Xmax && origin_map[16*Ybomb2[2]+Xbomb2[2]+1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb2[2]+Xbomb2[2]+1] <= 4'h0;
		else if(origin_map[16*Ybomb2[2]+Xbomb2[2]+1] == 4'h2)
			map_array[16*Ybomb2[2]+Xbomb2[2]+1] <= 4'h2;
		if(Xbomb2[2]-1 >= 0 && origin_map[16*Ybomb2[2]+Xbomb2[2]-1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb2[2]+Xbomb2[2]-1] <= 4'h0;
		else if(origin_map[16*Ybomb2[2]+Xbomb2[2]-1] == 4'h2 )
			map_array[16*Ybomb2[2]+Xbomb2[2]-1] <= 4'h2;
		end
	if(bomb_exploded2[3])
		begin
		map_array[16*Ybomb2[3]+Xbomb2[3]] <= 4'h0;
		if(Ybomb2[3]-1 >0 && origin_map[16*(Ybomb2[3]-1)+Xbomb2[3]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[3]-1)+Xbomb2[3]] <= 4'h0;
		else if(origin_map[16*(Ybomb2[3]-1)+Xbomb2[3]] == 4'h2)
			map_array[16*(Ybomb2[3]-1)+Xbomb2[3]] <= 4'h2;
		if(Ybomb2[3]+1 < Ymax && origin_map[16*(Ybomb2[3]+1)+Xbomb2[3]] != 4'h2) //not wall, becomes ground
			map_array[16*(Ybomb2[3]+1)+Xbomb2[3]] <= 4'h0;
		else if (origin_map[16*(Ybomb2[3]+1)+Xbomb2[3]] == 4'h2)
			map_array[16*(Ybomb2[3]+1)+Xbomb2[3]] <= 4'h2;
		if(Xbomb2[3]+1 < Xmax && origin_map[16*Ybomb2[3]+Xbomb2[3]+1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb2[3]+Xbomb2[3]+1] <= 4'h0;
		else if(origin_map[16*Ybomb2[3]+Xbomb2[3]+1] == 4'h2)
			map_array[16*Ybomb2[3]+Xbomb2[3]+1] <= 4'h2;
		if(Xbomb2[3]-1 >= 0 && origin_map[16*Ybomb2[3]+Xbomb2[3]-1] != 4'h2) //not wall, becomes ground
			map_array[16*Ybomb2[3]+Xbomb2[3]-1] <= 4'h0;
		else if(origin_map[16*Ybomb2[3]+Xbomb2[3]-1] == 4'h2 )
			map_array[16*Ybomb2[3]+Xbomb2[3]-1] <= 4'h2;
		end
		
end
endmodule
