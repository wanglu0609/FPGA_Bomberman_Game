module Bomberman(
	input               	CLOCK_50,
	input        [3:0]  	KEY,          //bit 0 is set up as Reset
	output logic [6:0]  	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
	// VGA Interface 
	output logic [7:0]  	VGA_R,        //VGA Red
							VGA_G,        //VGA Green
							VGA_B,        //VGA Blue
	output logic        	VGA_CLK,      //VGA Clock
							VGA_SYNC_N,   //VGA Sync signal
							VGA_BLANK_N,  //VGA Blank signal
							VGA_VS,       //VGA virtical sync signal
							VGA_HS,       //VGA horizontal sync signal
	// CY7C67200 Interface
	inout  wire  [15:0] 	OTG_DATA,     //CY7C67200 Data bus 16 Bits
	output logic [1:0]  	OTG_ADDR,     //CY7C67200 Address 2 Bits
	output logic        	OTG_CS_N,     //CY7C67200 Chip Select
							OTG_RD_N,     //CY7C67200 Write
							OTG_WR_N,     //CY7C67200 Read
							OTG_RST_N,    //CY7C67200 Reset
	input               	OTG_INT,      //CY7C67200 Interrupt
	// SDRAM Interface for Nios II Software
	output logic [12:0] 	DRAM_ADDR,    //SDRAM Address 13 Bits
	inout  wire  [31:0] 	DRAM_DQ,      //SDRAM Data 32 Bits
	output logic [1:0]  	DRAM_BA,      //SDRAM Bank Address 2 Bits
	output logic [3:0]  	DRAM_DQM,     //SDRAM Data Mast 4 Bits
	output logic        	DRAM_RAS_N,   //SDRAM Row Address Strobe
							DRAM_CAS_N,   //SDRAM Column Address Strobe
							DRAM_CKE,     //SDRAM Clock Enable
							DRAM_WE_N,    //SDRAM Write Enable
							DRAM_CS_N,    //SDRAM Chip Select
							DRAM_CLK      //SDRAM Clock
);

logic Reset_h, Clk;
logic [15:0] Keycode;

assign Clk = CLOCK_50;
assign {Reset_h} = ~(KEY[0]);  // The push buttons are active low

logic [1:0] hpi_addr;
logic [15:0] hpi_data_in, hpi_data_out;
logic hpi_r, hpi_w,hpi_cs;

// Interface between NIOS II and EZ-OTG chip
hpi_io_intf hpi_io_inst(
	.Clk,
	.Reset(Reset_h),
	// signals connected to NIOS II
	.from_sw_address(hpi_addr),
	.from_sw_data_in(hpi_data_in),
	.from_sw_data_out(hpi_data_out),
	.from_sw_r(hpi_r),
	.from_sw_w(hpi_w),
	.from_sw_cs(hpi_cs),
	// signals connected to EZ-OTG chip
	.OTG_DATA(OTG_DATA),    
	.OTG_ADDR(OTG_ADDR),    
	.OTG_RD_N(OTG_RD_N),    
	.OTG_WR_N(OTG_WR_N),    
	.OTG_CS_N(OTG_CS_N),    
	.OTG_RST_N(OTG_RST_N)
);

//The connections for nios_system might be named different depending on how you set up Qsys
nios_system nios_system(
	.clk_clk(Clk),         
	.reset_reset_n(KEY[0]),   
	.sdram_wire_addr(DRAM_ADDR), 
	.sdram_wire_ba(DRAM_BA),   
	.sdram_wire_cas_n(DRAM_CAS_N),
	.sdram_wire_cke(DRAM_CKE),  
	.sdram_wire_cs_n(DRAM_CS_N), 
	.sdram_wire_dq(DRAM_DQ),   
	.sdram_wire_dqm(DRAM_DQM),  
	.sdram_wire_ras_n(DRAM_RAS_N),
	.sdram_wire_we_n(DRAM_WE_N), 
	.sdram_out_clk(DRAM_CLK),
	.keycode_export(Keycode),  
	.otg_hpi_address_export(hpi_addr),
	.otg_hpi_data_in_port(hpi_data_in),
	.otg_hpi_data_out_port(hpi_data_out),
	.otg_hpi_cs_export(hpi_cs),
	.otg_hpi_r_export(hpi_r),
	.otg_hpi_w_export(hpi_w)
);

//Fill in the connections for the rest of the modules 
logic [9:0] Avatar_X_1, Avatar_Y_1, Avatar_Step_1, 
            Avatar_X_2, Avatar_Y_2, Avatar_Step_2,
            Draw_X, Draw_Y;
logic [1:0] Avatar_Dir_1, Avatar_Dir_2;
logic [143:0] Wall_Map, Bomb_Map, Tree_Map, Flame_Map, Treasure_Map;
logic [7:0] score_1, score_0;

VGA_controller vga_controller_instance(
	.Clk,
	.Reset(Reset_h),
	.VGA_HS,
	.VGA_VS,
	.VGA_CLK,
	.VGA_BLANK_N,
	.VGA_SYNC_N,
	.Draw_X,
	.Draw_Y
);

//ball ball_instance(
//	.Reset(~KEY[1]),
//	.frame_clk(VGA_VS),
//	.keycode(Keycode),
//	.BallX,
//	.BallY,
//	.BallS
//);

logic [1:0] state;
logic Player_choose, Winner;

assign state = 2'b10;
assign Player_choose = 1'b1;
assign Winner = 1'b0;

Game_Hub (
	.Frame_Clk(VGA_VS),
	.Reset(~KEY[1]),
	.Keycode,
	.Avatar_X_1,
	.Avatar_Y_1,
	.Avatar_Step_1,
	.Avatar_X_2,
	.Avatar_Y_2,
	.Avatar_Step_2,
	.Avatar_Dir_1,
	.Avatar_Dir_2,
	.Wall_Map,
	.Bomb_Map,
	.Tree_Map,
	.Treasure_Map,
	.Flame_Map,
	.score_1,
	.score_0
);
	

Color_Mapper_Final color_instance(
	.Avatar_X_1(Avatar_X_1),
	.Avatar_Y_1(Avatar_Y_1),
	.Avatar_Step_1,
	.Avatar_X_2(Avatar_X_2),
	.Avatar_Y_2(Avatar_Y_2),
	.Avatar_Step_2,
	.Draw_X,
	.Draw_Y,
	.Avatar_Dir_1,
	.Avatar_Dir_2,
	.state,
	.Wall_Map, 
	.Tree_Map, 
	.Treasure_Map, 
	.Bomb_Map, 
	.Flame_Map,
	.score_0,
	.score_1,
   .Player_choose,
	.Winner,
	.VGA_R,
	.VGA_G,
	.VGA_B
);

//color_mapper Color_Instance_Alt (
//	.BallX,
//	.BallY,
//	.BallS,
//	.DrawX(Draw_X),
//	.DrawY(Draw_Y),
//	.VGA_R,
//	.VGA_G,
//	.VGA_B
//);

HexDriver hex_inst_0 (Keycode[3:0], HEX0);
HexDriver hex_inst_1 (Keycode[7:4], HEX1);

HexDriver hex_inst_5 (Avatar_X_2[3:0], HEX5);
HexDriver hex_inst_6 (Avatar_X_2[7:4], HEX6);
HexDriver hex_inst_7 (Avatar_X_2[9:8], HEX7);

HexDriver hex_inst_2 (Avatar_Y_2[3:0], HEX2);
HexDriver hex_inst_3 (Avatar_Y_2[7:4], HEX3);
HexDriver hex_inst_4 (Avatar_Y_2[9:8], HEX4);

/**************************************************************************************
ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
Hidden Question #1/2:
What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
connect to the keyboard? List any two.  Give an answer in your Post-Lab.
**************************************************************************************/
endmodule
