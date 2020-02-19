module testbench();

timeunit 10ns;
timeprecision 1ns;

logic Frame_Clk = 0;
logic Reset;
logic [15:0] Keycode;
logic [143:0] Wall_Map, Bomb_Map, Flame_Map, Tree_Map, Treasure_Map;
logic [1:0] Avatar_Dir_1, Avatar_Dir_2;
logic [9:0] Avatar_X_1, Avatar_Y_1, Avatar_Step_1, Avatar_X_2, Avatar_Y_2, Avatar_Step_2, Avatar_S;
logic [7:0] Score_1, Score_2;
logic [1:0] State;
logic Player_Choose, Winner;

Game_Hub Game (.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Frame_Clk = ~Frame_Clk;
end

initial begin: CLOCK_INITIALIZATION
    Frame_Clk = 0;
end 


initial begin: TEST_VECTORS
Reset = 1'b0;
Keycode = 16'b0;

#2 Reset = 1'b1;
#2 Reset = 1'b0;


#10 Keycode = 16'h0015;
#2 Keycode = 16'h0;

#10 Keycode = 16'h0007;
#2 Keycode = 16'h0;
#2 Keycode = 16'h0052;
#2 Keycode = 16'h0;

#100 Keycode = 16'h0007;
#2 Keycode = 16'h0;
#2 Keycode = 16'h0052;
#2 Keycode = 16'h0;

#100 Keycode = 16'h0007;
#2 Keycode = 16'h0;
#2 Keycode = 16'h0052;
#2 Keycode = 16'h0;

#100 Keycode = 16'h0007;
#2 Keycode = 16'h0;
#2 Keycode = 16'h0052;
#2 Keycode = 16'h0;

#100 Keycode = 16'h0007;
#2 Keycode = 16'h0;
#2 Keycode = 16'h0052;
#2 Keycode = 16'h0;

#100 Keycode = 16'h002c;
#2 Keycode = 16'h0;

#100 Keycode = 16'h0007;
#2 Keycode = 16'h0;

#100 Keycode = 16'h0007;
#2 Keycode = 16'h0;

#100 Keycode = 16'h0007;
#2 Keycode = 16'h0;



#100 Keycode = 16'h0016;
#2 Keycode = 16'h0;

#100 Keycode = 16'h0016;
#2 Keycode = 16'h0;
end
endmodule
