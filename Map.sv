module Map (
	input Reset, Frame_Clk,
	input [9:0] Bomb_X, Bomb_Y,
	output [143:0] Wall_Map, Bomb_Map, Tree_Map, Treasure_Map
);
	// [0] upon on left top
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
	
	assign Bomb_Map = 143'b0;
	assign Tree_Map = 143'b0;
	assign Treature_Map = 143'b0;
endmodule
