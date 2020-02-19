module Game_Hub (
	input logic Reset, Frame_Clk,
	input logic [15:0] Keycode,
	output [9:0] Avatar_X_1, Avatar_Y_1, Avatar_Step_1, Avatar_X_2, Avatar_Y_2, Avatar_Step_2,
	output [1:0] Avatar_Dir_1, Avatar_Dir_2,
	output [143:0] Wall_Map, Bomb_Map, Tree_Map, Treasure_Map, Flame_Map,
	output [7:0] score_1, score_0
);
	
	assign score_1 = 8'b01111000;
	assign score_0 = 8'b00010110;
	
	assign Avatar_X_1 = 10'd0;
	assign Avatar_Y_1 = 10'd0;
	assign Avatar_X_2 = 10'd140;
	assign Avatar_Y_2 = 10'd140;
   assign Avatar_Step_1 = 10'd28;
   assign Avatar_Step_2 = 10'd33;
   assign Avatar_Dir_1 = 2'b10;
   assign Avatar_Dir_2 = 2'b00;	
	
	assign Wall_Map[143:132] = 12'b111111111111;
	assign Wall_Map[131:120] = 12'b100000000001;
	assign Wall_Map[119:108] = 12'b101110011101;
	assign Wall_Map[107:096] = 12'b101000000101;
	assign Wall_Map[095:084] = 12'b101010110101;
	assign Wall_Map[083:072] = 12'b100010000001;
	assign Wall_Map[071:060] = 12'b100000010001;
	assign Wall_Map[059:048] = 12'b101011010101;
	assign Wall_Map[047:036] = 12'b101000000101;
	assign Wall_Map[035:024] = 12'b101110011101;
	assign Wall_Map[023:012] = 12'b100000000001;
	assign Wall_Map[011:000] = 12'b111111111111;
	
	
	assign Flame_Map[143:132] = 12'b000000000000;
	assign Flame_Map[131:120] = 12'b011000000000;
	assign Flame_Map[119:108] = 12'b000000000000;
	assign Flame_Map[107:096] = 12'b000000000000;
	assign Flame_Map[095:084] = 12'b000000000000;
	assign Flame_Map[083:072] = 12'b000000000000;
	assign Flame_Map[071:060] = 12'b000000000000;
	assign Flame_Map[059:048] = 12'b000000000000;
	assign Flame_Map[047:036] = 12'b000000000000;
	assign Flame_Map[035:024] = 12'b000000000010;
	assign Flame_Map[023:012] = 12'b000000000000;
	assign Flame_Map[011:000] = 12'b000000000000;
	
	assign Tree_Map[143:132] = 12'b000000000000;
	assign Tree_Map[131:120] = 12'b000000000000;
	assign Tree_Map[119:108] = 12'b000000000000;
	assign Tree_Map[107:096] = 12'b000000000000;
	assign Tree_Map[095:084] = 12'b000000000000;
	assign Tree_Map[083:072] = 12'b000000000000;
	assign Tree_Map[071:060] = 12'b000000110000;
	assign Tree_Map[059:048] = 12'b001000000000;
	assign Tree_Map[047:036] = 12'b000000000000;
	assign Tree_Map[035:024] = 12'b000000000000;
	assign Tree_Map[023:012] = 12'b011000000000;
	assign Tree_Map[011:000] = 12'b000000000000;
	
   assign Bomb_Map[143:132] = 12'b000000000000;
	assign Bomb_Map[131:120] = 12'b000000000000;
	assign Bomb_Map[119:108] = 12'b001100000000;
	assign Bomb_Map[107:096] = 12'b000000000000;
	assign Bomb_Map[095:084] = 12'b000000000000;
	assign Bomb_Map[083:072] = 12'b000000000000;
	assign Bomb_Map[071:060] = 12'b000000000000;
	assign Bomb_Map[059:048] = 12'b000000000000;
	assign Bomb_Map[047:036] = 12'b000000000000;
	assign Bomb_Map[035:024] = 12'b000000000000;
	assign Bomb_Map[023:012] = 12'b000000010000;
	assign Bomb_Map[011:000] = 12'b000000000000;
	
   assign Treasure_Map[143:132] = 12'b000000000000;
	assign Treasure_Map[131:120] = 12'b000000011000;
	assign Treasure_Map[119:108] = 12'b000000000000;
	assign Treasure_Map[107:096] = 12'b000000000000;
	assign Treasure_Map[095:084] = 12'b000000000000;
	assign Treasure_Map[083:072] = 12'b000000000000;
	assign Treasure_Map[071:060] = 12'b000000000000;
	assign Treasure_Map[059:048] = 12'b000000110000;
	assign Treasure_Map[047:036] = 12'b000000000000;
	assign Treasure_Map[035:024] = 12'b000000000000;
	assign Treasure_Map[023:012] = 12'b001111110000;
	assign Treasure_Map[011:000] = 12'b000000000000;
	
//	logic [9:0] Avatar_X_Center, Avatar_Y_Center, Bomb_X, Bomb_Y;
//	logic Done;
//	assign Avatar_X_Center_1 = 10'd60;
//	assign Avatar_Y_Center_1 = 10'd60;
//	assign Done = 1'b0;
//	assign Avatar_Step = 10'd48;
//	assign Avatar_S = 10'd40;
//	
//	

	
//	enum logic [3:0] {WELCOME, GAME, SCORE, END} Curr_State, Next_State;
//	
//	always_ff@(posedge Frame_Clk) begin
//		if (Reset == 1'b0) begin
//			Curr_State <= WELCOME;
//		end else begin 
//			Curr_State <= Next_State;
//		end
//	end
//	
//	always_comb begin
//		Next_State = Curr_State;
//		unique case (Curr_State)
//			WELCOME: begin
//				if (Keycode[7:0] == 8'h15)
//					Next_State = GAME;
//			end
//			GAME: begin
//				if (Done)
//					Next_State = SCORE;
//			end
//			SCORE: begin
//				if (Keycode[7:0] == 8'h11)
//					Next_State = END;
//				else if (Keycode[7:0] == 8'h1c)
//					Next_State = GAME;
//			end
//			END: begin
//			end
//		endcase
//	end
//	
//	Avatar Player_1 (
//		.Frame_Clk,
//		.Reset,
//		.Keycode,
//		.Wall_Map,
//		.Bomb_Map,
//		.Tree_Map,
//		.Treasure_Map,
//		.Avatar_X_Center(Avatar_X_Center_1),
//		.Avatar_Y_Center(Avatar_Y_Center_1),
//		.Avatar_X(Avatar_X_1),
//		.Avatar_Y(Avatar_Y_1),
//		.Avatar_Step(Avatar_Step_1)
//	);
//	
//	Map Game_Map (
//		.Frame_Clk,
//		.Reset,
//		.Bomb_X,
//		.Bomb_Y,
//		.Wall_Map,
//		.Bomb_Map,
//		.Tree_Map,
//		.Treasure_Map
//	);

endmodule
