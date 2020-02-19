//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  03-03-2017                               --
//                                                                       --
//    Spring 2017 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
// ( 24, 24)|( 72, 24)|(120, 24)|(168, 24)|(216, 24)|(264, 24)|(312, 24)|(360, 24)|(408, 24)|(456, 24)
// ( 24, 72)|( 72, 72)|(120, 72)|(168, 72)|(216, 72)|(264, 72)|(312, 72)|(360, 72)|(408, 72)|(456, 72)
// ( 24,120)|( 72,120)|(120,120)|(168,120)|(216,120)|(264,120)|(312,120)|(360,120)|(408,120)|(456,120)
// ( 24,168)|( 72,168)|(120,168)|(168,168)|(216,168)|(264,168)|(312,168)|(360,168)|(408,168)|(456,168)
// ( 24,216)|( 72,216)|(120,216)|(168,216)|(216,216)|(264,216)|(312,216)|(360,216)|(408,216)|(456,216)
// ( 24,264)|( 72,264)|(120,264)|(168,264)|(216,264)|(264,264)|(312,264)|(360,264)|(408,264)|(456,264)
// ( 24,312)|( 72,312)|(120,312)|(168,312)|(216,312)|(264,312)|(312,312)|(360,312)|(408,312)|(456,312)
// ( 24,360)|( 72,360)|(120,360)|(168,360)|(216,360)|(264,360)|(312,360)|(360,360)|(408,360)|(456,360)
// ( 24,408)|( 72,408)|(120,408)|(168,408)|(216,408)|(264,408)|(312,408)|(360,408)|(408,408)|(456,408)
// ( 24,456)|( 72,456)|(120,456)|(168,456)|(216,456)|(264,456)|(312,456)|(360,456)|(408,456)|(456,456)
//--------------------------------------------------------------------------------------------------



module  color_mapper ( input        [9:0] Avatar_X, Avatar_Y,       // Ball coordinates
                                          Avatar_S,              // Ball size (defined in ball.sv)
                                          DrawX, DrawY,       // Coordinates of current drawing pixel
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    
    logic [7:0] c_table[0:8][0:2];
    logic [7:0] Red, Green, Blue;
	 logic [7:0] char_index;
	 logic [8:0] avatar [0:47][0:47];
	 logic [7:0] ava_sprite[0:8][0:2];
	 logic char_on, block_on, exploded_on, flame_on, bomb_on;
	 
	 
	 color_table color(.colors(c_table));
	 char_sprite ava(.index(ava_sprite));
    
 /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
    the single line is quite powerful descriptively, it causes the synthesis tool to use up three
    of the 12 available multipliers on the chip! Since the multiplicants are required to be signed,
    we have to first cast them from logic to int (signed by default) before they are multiplied. */
    
    int Size, Char_X, Char_Y;
	 assign Char_X = Avatar_X;
	 assign Char_Y = Avatar_Y;
    assign Size =  Avatar_S/2;
    
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
	 
	 
    
    // Compute whether the pixel corresponds to ball or background
    always_comb
    begin : find_index
        if(DrawX >= Char_X - Size && DrawX <= Char_X + Size && DrawY >= Char_Y - Size && DrawY <= Char_Y + Size) 
            char_on = 1'b1;
        else 
            char_on = 1'b0;
    end
    
	 
	  always_comb
    begin : color_picker
        if(char_on == 1'b1)
        begin
           char_index =  ava_sprite[Char_X][Char_Y];
        end
    end 
	 
	 
    // Assign color based on ball_on signal
    always_comb
    begin : RGB_Display
        if ((char_on == 1'b1) && (char_index != 0)) 
        begin
            // White ball
            Red = c_table[char_index][0];
				Green = c_table[char_index][1];
            Blue = c_table[char_index][2];
        end
		  else if ((bomb_on == 1'b1) && (char_index != 0)) 
        begin
            // White ball
            Red = c_table[char_index][0];
				Green = c_table[char_index][1];
            Blue = c_table[char_index][2];
        end
        else
        begin
            // Background with nice color gradient
            Red = 8'd67; 
            Green = 8'd102;
            Blue = 8'd70;
        end
    end 
    
endmodule
