module Tree (
	input Frame_Clk, Reset,
	input [9:0] Bomb_X, Bomb_Y,
	input [143:0] Tree_Map_In,
	output [143:0] Tree_Map
);
	int Bomb_X_C = (Bomb_X - 10'd20)/10'd40;
	int Bomb_Y_C = (Bomb_Y - 10'd20)/10'd40;
	int index = Bomb_Y_C*12 + Bomb_X_C;
	
	always_ff@(posedge Frame_Clk)
	begin
		if (Reset)
		begin
			assign Tree_Map[143:132] = 12'b000000000000;
			assign Tree_Map[131:120] = 12'b000000000000;
			assign Tree_Map[119:108] = 12'b000000000000;
			assign Tree_Map[107:096] = 12'b000100001000;
			assign Tree_Map[095:084] = 12'b000000000000;
			assign Tree_Map[083:072] = 12'b000000000000;
			assign Tree_Map[071:060] = 12'b000000000000;
			assign Tree_Map[059:048] = 12'b000000000000;
			assign Tree_Map[047:036] = 12'b000100001000;
			assign Tree_Map[035:024] = 12'b000000000000;
			assign Tree_Map[025:012] = 12'b000000000000;
			assign Tree_Map[011:000] = 12'b000000000000;
		end
		else
		begin
			if (Tree_Map[index + 1'd1])
				Tree_Map[index + 1'd1] <= 1'd1;
			if (Tree_Map[index - 1'd1])
				Tree_Map[index - 1'd1] <= 1'd1;
			if (Tree_Map[index + 4'd12])
				Tree_Map[index + 4'd12] <= 1'd1;
			if (Tree_Map[index - 4'd12])
				Tree_Map[index - 4'd12] <= 1'd1;
		end
	end
endmodule
			