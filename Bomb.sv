module Bomb (
	input Frame_Clk, Reset,
	input [143:0] Bomb_Map_In,
	input [9:0] Bomb_X, Bomb_Y,
	output [143:0] Bomb_Map
);
	int Bomb_X_C = (Bomb_X - 10'd20)/10'd40;
	int Bomb_Y_C = (Bomb_Y - 10'd20)/10'd40;
	int index = Bomb_Y_C*12 + Bomb_X_C;
	
	logic [9:0] Step_Count;
	int Ready;
	
	always_ff@(posedge Frame_Clk)
	begin
		if (Reset)
		begin
			Bomb_Map <= 144'b0;
			Ready <= 1'd1;
			Step_Count <= 10'd120;
		end
		else if (Ready == 1'd1)
		begin	
			if (Bomb_X == 12'b0 && Bomb_Y == 12'b0)
				Bomb_Map <= Bomb_Map_In;
			else
			begin
				Ready <= 1'd0;
				Bomb_Map[index] <= 1;
			end
		end
		else
		begin
			Step_Count <= Step_Count - 10'd1;
			if (Step_Count == 10'd0)
			begin
				Step_Count <= 8'd0;
				Ready <= 1'b1;
			end
		end
	end
endmodule
	