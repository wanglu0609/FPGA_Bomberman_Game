module enemy(
	input Frame_Clk, Reset,
	input [9:0] Enemy_X_Center, Enemy_Y_Center,
	input [143:0] Wall_Map, Bomb_Map, Tree_Map, Treasure_Map, Fkame_Map,
	output [9:0] Enemy_X, Enemy_Y, Enemy_Step, Bomb_X, Bomb_Y
);




   logic [9:0] Avatar_X_Pos, Avatar_X_Motion, Avatar_Y_Pos, Avatar_Y_Motion, Bomb_X_Pos, Bomb_Y_Pos;
	logic [9:0] Avatar_X_Pos_In, Avatar_X_Motion_In, Avatar_Y_Pos_In, Avatar_Y_Motion_In, Avatar_X_C, Avatar_Y_C, index;
	logic [7:0] Step_Count;
	logic Can_Right, Can_Left, Can_Up, Can_Down;

	parameter [9:0] Avatar_X_Min = 0;
	parameter [9:0] Avatar_X_Max = 479;
	parameter [9:0] Avatar_Y_Min = 0;
	parameter [9:0] Avatar_Y_Max = 479;
	parameter [9:0] Avatar_X_Step = 1;
	parameter [9:0] Avatar_Y_Step = 1;
	parameter [9:0] Avatar_Size = 40;

	int Init = 1'b1;
	int Ready = 1'b1;

	assign Avatar_X = Avatar_X_Pos;
	assign Avatar_Y = Avatar_Y_Pos;
	assign Avatar_Step = Step_Count;
	assign Bomb_X = Bomb_X_Pos;
	assign Bomb_Y = Bomb_Y_Pos;

	always_ff @ (posedge Frame_Clk)
	begin
		if (Reset || Init)
		begin
			Init <= 1'b0;
			Avatar_X_Pos <= Avatar_X_Center;
			Avatar_Y_Pos <= Avatar_Y_Center;
			Avatar_X_Motion <= 10'd0;
			Avatar_Y_Motion <= 10'd0;
			Step_Count <= 8'd0;
			Bomb_X_Pos <= 10'd0;
			Bomb_Y_Pos <= 10'd0;
		end
		else
		begin
			if (Ready)
			begin
				case (Keycode[7:0])
					8'h1a: // w (up)
						begin
							if (Can_Up)
							begin
								Ready <= 1'b0;
								Avatar_X_Motion <= 10'd0; // always clear first
								if (Avatar_Y_Motion >= 0) // going down
									Avatar_Y_Motion <= ~(Avatar_Y_Step) + 1'b1;  // 2's complement.
								else
									Avatar_Y_Motion <= Avatar_Y_Step; // keep motion
//								if ( Avatar_Y_Pos <= (Avatar_Y_Min + Avatar_Size + Avatar_Y_Step) )  // Avatar is at the top edge, BOUNCE!
//								begin
//									Avatar_X_Motion <= 10'd0; // always clear first
//									Avatar_Y_Motion <= 10'd0; // keep motion
//								end
							end else begin
								Avatar_X_Motion <= 10'd0; // always clear first
								Avatar_Y_Motion <= 10'd0; // keep motion
							end
						end
					8'h04: // a (left)
						begin
							if (Can_Left)
							begin
								Ready <= 1'b0;
								Avatar_Y_Motion <= 10'd0; // always clear first
								if (Avatar_X_Motion >= 0) // going right
									Avatar_X_Motion <= ~(Avatar_X_Step) + 1'b1;  // 2's complement.
								else
									Avatar_X_Motion <= Avatar_X_Step; // keep motion
//								if ( Avatar_X_Pos <= (Avatar_X_Min + Avatar_Size + Avatar_X_Step) )  // Avatar is at the left edge, BOUNCE!
//								begin
//									Avatar_Y_Motion <= 10'd0; // always clear first
//									Avatar_X_Motion <= 10'd0; // keep motion
//								end
							end else begin
								Avatar_Y_Motion <= 10'd0; // always clear first
								Avatar_X_Motion <= 10'd0; // keep motion
							end
						end
					8'h16: // s (down)
						begin
							if (Can_Down)
							begin
								Ready <= 1'b0;
								Avatar_X_Motion <= 10'd0; // always clear first
								if (Avatar_Y_Motion < 0) // going up
									Avatar_Y_Motion <= ~(Avatar_Y_Step) + 1'b1;  // 2's complement.
								else
									Avatar_Y_Motion <= Avatar_Y_Step; // keep motion
//								if( (Avatar_Y_Pos + Avatar_Size + Avatar_Y_Step) >= Avatar_Y_Max )  // Avatar is at the bottom edge, BOUNCE!
//								begin
//									Avatar_X_Motion <= 10'd0; // always clear first
//									Avatar_Y_Motion <= 10'd0;  // 2's complement.  
//								end
							end else begin
								Avatar_X_Motion <= 10'd0; // always clear first
								Avatar_Y_Motion <= 10'd0; // keep motion
							end
						end
					8'h07: // d (right)
						begin
							if (Can_Right)
							begin
								Ready <= 1'b0;
								Avatar_Y_Motion <= 10'd0; // always clear first
								if (Avatar_X_Motion < 0) // going left
									Avatar_X_Motion <= ~(Avatar_X_Step) + 1'b1;  // 2's complement.
								else
									Avatar_X_Motion <= Avatar_X_Step; // keep motion
//								if( (Avatar_X_Pos + Avatar_Size + Avatar_X_Step) >= Avatar_X_Max )  // Avatar is at the right edge, BOUNCE!
//								begin
//									Avatar_Y_Motion <= 10'd0; // always clear first
//									Avatar_X_Motion <= 10'd0;  // 2's complement.  
//								end
							end else begin
								Avatar_Y_Motion <= 10'd0; // always clear first
								Avatar_X_Motion <= 10'd0; // keep motion
							end
						end
					8'h2c:
						begin
							Bomb_X_Pos <= Avatar_X_Pos_In;
							Bomb_Y_Pos <= Avatar_Y_Pos_In;
						end
				endcase
			end
			else
			begin
				Avatar_X_Pos <= Avatar_X_Pos_In;
				Avatar_Y_Pos <= Avatar_Y_Pos_In;
				Avatar_X_Motion <= Avatar_X_Motion_In;
				Avatar_Y_Motion <= Avatar_Y_Motion_In;
				Step_Count <= Step_Count + 8'd1;
				if (Step_Count == 8'd39)
					begin
						Step_Count <= 8'd0;
						Ready <= 1'b1;
					end
			end
		end
	end
	
	assign Avatar_X_C = (Avatar_X - 10'd20)/10'd40;
	assign Avatar_Y_C = (Avatar_Y - 10'd20)/10'd40;
	assign index = Avatar_Y_C*12 + Avatar_X_C;
	
	always_comb
	begin
		// By default, keep motion unchanged
		Avatar_X_Motion_In = Avatar_X_Motion;
		Avatar_Y_Motion_In = Avatar_Y_Motion;
		Avatar_X_Pos_In = Avatar_X_Pos + Avatar_X_Motion;
		Avatar_Y_Pos_In = Avatar_Y_Pos + Avatar_Y_Motion;
		Can_Up = 1'b1;
		Can_Down = 1'b1;
		Can_Right = 1'b1;
		Can_Left = 1'b1;
		if (Wall_Map[index - 1'b1] || Bomb_Map[index - 1'b1] || Tree_Map[index - 1'b1] || Treasure_Map[index - 1'b1])
			Can_Left = 1'b0;
		if (Wall_Map[index + 1'b1] || Bomb_Map[index + 1'b1] || Tree_Map[index + 1'b1] || Treasure_Map[index + 1'b1])
			Can_Right = 1'b0;
		if (Wall_Map[index - 4'd12] || Bomb_Map[index - 4'd12] || Tree_Map[index - 4'd12] || Treasure_Map[index - 4'd12])
			Can_Up = 1'b0;
		if (Wall_Map[index + 4'd12] || Bomb_Map[index + 4'd12] || Tree_Map[index + 4'd12] || Treasure_Map[index + 4'd12])
			Can_Down = 1'b0;
	end
endmodule
