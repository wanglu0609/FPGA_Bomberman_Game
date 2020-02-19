//------------------------------------------------------------------------------------------------------------------------
// ( 20, 20)|( 60, 20)|(100, 20)|(140, 20)|(180, 20)|(220, 20)|(260, 20)|(300, 20)|(340, 20)|(380, 20)|(420, 20)|(460, 20)
// ( 20, 60)|( 60, 60)|(100, 60)|(140, 60)|(180, 60)|(220, 60)|(260, 60)|(300, 60)|(340, 60)|(380, 60)|(420, 60)|(460, 60)
// ( 20,100)|( 60,100)|(100,100)|(140,100)|(180,100)|(220,100)|(260,100)|(300,100)|(340,100)|(380,100)|(420,100)|(460,100)
// ( 20,140)|( 60,140)|(100,140)|(140,140)|(180,140)|(220,140)|(260,140)|(300,140)|(340,140)|(380,140)|(420,140)|(460,140)
// ( 20,180)|( 60,180)|(100,180)|(140,180)|(180,180)|(220,180)|(260,180)|(300,180)|(340,180)|(380,180)|(420,180)|(460,180)
// ( 20,220)|( 60,220)|(100,220)|(140,220)|(180,220)|(220,220)|(260,220)|(300,220)|(340,220)|(380,220)|(420,220)|(460,220)
// ( 20,260)|( 60,260)|(100,260)|(140,260)|(180,260)|(220,260)|(260,260)|(300,260)|(340,260)|(380,260)|(420,260)|(460,260)
// ( 20,300)|( 60,300)|(100,300)|(140,300)|(180,300)|(220,300)|(260,300)|(300,300)|(340,300)|(380,300)|(420,300)|(460,300)
// ( 20,340)|( 60,340)|(100,340)|(140,340)|(180,340)|(220,340)|(260,340)|(300,340)|(340,340)|(380,340)|(420,340)|(460,340)
// ( 20,380)|( 60,380)|(100,380)|(140,380)|(180,380)|(220,380)|(260,380)|(300,380)|(340,380)|(380,380)|(420,380)|(460,380)
// ( 20,420)|( 60,420)|(100,420)|(140,420)|(180,420)|(220,420)|(260,420)|(300,420)|(340,420)|(380,420)|(420,420)|(460,420)
// ( 20,460)|( 60,460)|(100,460)|(140,460)|(180,460)|(220,460)|(260,460)|(300,460)|(340,460)|(380,460)|(420,460)|(460,460)
//--------------------------------------------------------------------------------------------------

module Avatar_1 (
	input Frame_Clk, Reset,
	input [15:0] Keycode,
	input [9:0] Avatar_X_Center, Avatar_Y_Center,
	input [143:0] Wall_Map, Bomb_Map, Tree_Map, Treasure_Map, Flame_Map,
	output [1:0] Avatar_Dir,
	output [9:0] Avatar_X, Avatar_Y, Avatar_Step,
	output [31:0] Bomb_Index,
	output Is_Dead
);
	
	logic [1:0] Avatar_Dir_In;
	logic [9:0] Avatar_X_Pos, Avatar_X_Motion, Avatar_Y_Pos, Avatar_Y_Motion, Bomb_X_Pos, Bomb_Y_Pos;
	logic [9:0] Avatar_X_Pos_In, Avatar_X_Motion_In, Avatar_Y_Pos_In, Avatar_Y_Motion_In, Avatar_X_C, Avatar_Y_C;
	logic [31:0] Index, Bomb_Index_In;
	logic [7:0] Step_Count;
	logic Can_Right, Can_Left, Can_Up, Can_Down, Is_Dead_In;

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
	assign Bomb_Index = Bomb_Index_In;
	assign Avatar_Dir = Avatar_Dir_In;
	assign Is_Dead = Is_Dead_In;

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
			Bomb_Index_In <= 32'd0;
			Avatar_Dir_In <= 2'b0;
			Is_Dead_In <= 1'b0;
		end
		else
		begin
			if (Flame_Map[Index])
			begin
				Is_Dead_In <= 1'b1;
				Avatar_X_Pos <= 10'd0;
				Avatar_Y_Pos <= 10'd0;
				Avatar_X_Motion <= 10'd0;
				Avatar_Y_Motion <= 10'd0;
			end
			else
			begin
				Bomb_Index_In <= 32'd0;
				if (Ready)
				begin
					case (Keycode[7:0])
						8'h1a: // w (up)
							begin
								Avatar_Dir_In <= 2'b01;
								if (Can_Up)
								begin
									Ready <= 1'b0;
									Avatar_X_Motion <= 10'd0; // always clear first
									if (Avatar_Y_Motion >= 0) // going down
										Avatar_Y_Motion <= ~(Avatar_Y_Step) + 1'b1;  // 2's complement.
									else
										Avatar_Y_Motion <= Avatar_Y_Step; // keep motion
								end else begin
									Avatar_X_Motion <= 10'd0; // always clear first
									Avatar_Y_Motion <= 10'd0; // keep motion
								end
							end
						8'h04: // a (left)
							begin
								Avatar_Dir_In <= 2'b10;
								if (Can_Left)
								begin
									Ready <= 1'b0;
									Avatar_Y_Motion <= 10'd0; // always clear first
									if (Avatar_X_Motion >= 0) // going right
										Avatar_X_Motion <= ~(Avatar_X_Step) + 1'b1;  // 2's complement.
									else
										Avatar_X_Motion <= Avatar_X_Step; // keep motion
								end else begin
									Avatar_Y_Motion <= 10'd0; // always clear first
									Avatar_X_Motion <= 10'd0; // keep motion
								end
							end
						8'h16: // s (down)
							begin
								Avatar_Dir_In <= 2'b00;
								if (Can_Down)
								begin
									Ready <= 1'b0;
									Avatar_X_Motion <= 10'd0; // always clear first
									if (Avatar_Y_Motion < 0) // going up
										Avatar_Y_Motion <= ~(Avatar_Y_Step) + 1'b1;  // 2's complement.
									else
										Avatar_Y_Motion <= Avatar_Y_Step; // keep motion
								end else begin
									Avatar_X_Motion <= 10'd0; // always clear first
									Avatar_Y_Motion <= 10'd0; // keep motion
								end
							end
						8'h07: // d (right)
							begin
								Avatar_Dir_In <= 2'b11;
								if (Can_Right)
								begin
									Ready <= 1'b0;
									Avatar_Y_Motion <= 10'd0; // always clear first
									if (Avatar_X_Motion < 0) // going left
										Avatar_X_Motion <= ~(Avatar_X_Step) + 1'b1;  // 2's complement.
									else
										Avatar_X_Motion <= Avatar_X_Step; // keep motion
								end else begin
									Avatar_Y_Motion <= 10'd0; // always clear first
									Avatar_X_Motion <= 10'd0; // keep motion
								end
							end
						8'h2c:
							begin
								Bomb_Index_In <= Index;
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
	end
	
	assign Avatar_X_C = (Avatar_X - 10'd20)/10'd40;
	assign Avatar_Y_C = (Avatar_Y - 10'd20)/10'd40;
	assign Index = Avatar_Y_C*12 + Avatar_X_C;
	
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
		if (Wall_Map[Index - 1'b1] || Bomb_Map[Index - 1'b1] || Tree_Map[Index - 1'b1])
			Can_Left = 1'b0;
		if (Wall_Map[Index + 1'b1] || Bomb_Map[Index + 1'b1] || Tree_Map[Index + 1'b1])
			Can_Right = 1'b0;
		if (Wall_Map[Index - 4'd12] || Bomb_Map[Index - 4'd12] || Tree_Map[Index - 4'd12])
			Can_Up = 1'b0;
		if (Wall_Map[Index + 4'd12] || Bomb_Map[Index + 4'd12] || Tree_Map[Index + 4'd12])
			Can_Down = 1'b0;
	end
endmodule
