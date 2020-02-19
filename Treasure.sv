module Treasure (
	input [3:0] Map_Index,
	output [143:0] Treasure_Map_In
);
	logic [143:0] Treasure_Map;
	assign Treasure_Map_In = Treasure_Map;
	
	always_comb begin
		unique case (Map_Index)
			default: begin
				Treasure_Map[143:132] = 12'b000000000000;
				Treasure_Map[131:120] = 12'b000000000000;
				Treasure_Map[119:108] = 12'b000000000000;
				Treasure_Map[107:096] = 12'b000100001000;
				Treasure_Map[095:084] = 12'b000000000000;
				Treasure_Map[083:072] = 12'b000000000000;
				Treasure_Map[071:060] = 12'b000000000000;
				Treasure_Map[059:048] = 12'b000000000000;
				Treasure_Map[047:036] = 12'b000100001000;
				Treasure_Map[035:024] = 12'b000000000000;
				Treasure_Map[023:012] = 12'b000000000000;
				Treasure_Map[011:000] = 12'b000000000000;
			end
		endcase
	end
endmodule
