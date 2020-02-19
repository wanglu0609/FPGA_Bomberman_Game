//------------------------------------------------------------------------------------------------------------------------
// ( 20, 20)|( 72, 20)|(120, 20)|(168, 20)|(216, 20)|(264, 20)|(312, 20)|(360, 20)|(408, 20)|(456, 20)|(222, 20)|(222, 20)
// ( 20, 72)|( 72, 72)|(120, 72)|(168, 72)|(216, 72)|(264, 72)|(312, 72)|(360, 72)|(408, 72)|(456, 72)
// ( 20,120)|( 72,120)|(120,120)|(168,120)|(216,120)|(264,120)|(312,120)|(360,120)|(408,120)|(456,120)
// ( 20,168)|( 72,168)|(120,168)|(168,168)|(216,168)|(264,168)|(312,168)|(360,168)|(408,168)|(456,168)
// ( 20,216)|( 72,216)|(120,216)|(168,216)|(216,216)|(264,216)|(312,216)|(360,216)|(408,216)|(456,216)
// ( 20,264)|( 72,264)|(120,264)|(168,264)|(216,264)|(264,264)|(312,264)|(360,264)|(408,264)|(456,264)
// ( 20,312)|( 72,312)|(120,312)|(168,312)|(216,312)|(264,312)|(312,312)|(360,312)|(408,312)|(456,312)
// ( 20,360)|( 72,360)|(120,360)|(168,360)|(216,360)|(264,360)|(312,360)|(360,360)|(408,360)|(456,360)
// ( 20,408)|( 72,408)|(120,408)|(168,408)|(216,408)|(264,408)|(312,408)|(360,408)|(408,408)|(456,408)
// ( 20,456)|( 72,456)|(120,456)|(168,456)|(216,456)|(264,456)|(312,456)|(360,456)|(408,456)|(456,456)
//--------------------------------------------------------------------------------------------------

module Avatar (
	input Frame_Clk, Reset,
	input [15:0] Keycode,
	input [9:0] Avatar_X_Center, Avatar_Y_Center,
	input [143:0] Wall_Map, Bomb_Map, Tree_Map, Treasure_Map,
	output [9:0] Avatar_X, Avatar_Y, Avatar_Step, Bomb_X, Bomb_Y
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
