# FPGA_Bomberman_Game

## System Verilog Implementation of Bomberman Game
The system verilog version of Bomberman game is displayed on VGA. The game supports maximum of two users or one user and one AI player.

## Main Functions
color_mapper.sv: covert value to RGB value for displaying in VGA

VGA_controller.sv: processing inputs from color_mapper display image on VGA 

Avatar.sv: control avatars' movement form keyboard inputs

Game_hub.sv: change game state from avatar movements

sprite files are used to save all image information
