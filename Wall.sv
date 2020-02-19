module Wall (
	input [3:0] Map_Index,
	output [143:0] Wall_Map_In
);
	logic [143:0] Wall_Map;
	assign Wall_Map_In = Wall_Map;
	
	always_comb begin
		unique case (Map_Index)
			default: begin
				Wall_Map[143:132] = 12'b111111111111;
				Wall_Map[131:120] = 12'b100000000001;
				Wall_Map[119:108] = 12'b101110011101;
				Wall_Map[107:096] = 12'b101000000101;
				Wall_Map[095:084] = 12'b101010110101;
				Wall_Map[083:072] = 12'b100010000001;
				Wall_Map[071:060] = 12'b100000010001;
				Wall_Map[059:048] = 12'b101011010101;
				Wall_Map[047:036] = 12'b101000000101;
				Wall_Map[035:024] = 12'b101110011101;
				Wall_Map[023:012] = 12'b100000000001;
				Wall_Map[011:000] = 12'b111111111111;
			end
		endcase
	end
endmodule
