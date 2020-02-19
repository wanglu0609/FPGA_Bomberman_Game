module again_font( 
               input [3:0]	addr,
		         output [97:0]	data
		         );

					
   parameter ADDR_WIDTH = 4;
   parameter DATA_WIDTH =  98;
	logic [ADDR_WIDTH-1:0] addr_reg;
				
	// ROM definition				
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {
	
	
	98'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
   98'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
   98'b00010000000111100000010000000111100011000110001111100000000000000000000000000000000000000000000000,
   98'b00111000001100110000111000000011000011100110011000110000000000000000000000000000000000000000000000,
   98'b01101100011000010001101100000011000011110110011000110000000000000000000000000010000000000000000000,
   98'b11000110011000000011000110000011000011111110000001100000000000011000110000000110011011100000000000,
   98'b11000110011000000011000110000011000011011110000011000000000000011000110000001100001100110000000000,
   98'b11111110011011110011111110000011000011001110000011000000000000011000110000011000001100110000000000,
   98'b11000110011000110011000110000011000011000110000011000000000000011000110000110000001100110000000000,
   98'b11000110011000110011000110000011000011000110000000000000000000011000110001100000001100110000000000,
   98'b11000110001100110011000110000011000011000110000011000000000000011000110011000000001100110000000000,
   98'b11000110000111010011000110000111100011000110000011000000000000001111110010000000001100110000000000,
   98'b00000000000000000000000000000000000000000000000000000000000000000000110000000000000000000000000000,
   98'b00000000000000000000000000000000000000000000000000000000000000000001100000000000000000000000000000,
   98'b00000000000000000000000000000000000000000000000000000000000000011111000000000000000000000000000000,
   98'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
	
	
	};

	assign data = ROM[addr];

endmodule