`timescale 1ns / 1ps

module div100k(
    input clock,
 	 output reg ce1k = 1'b0
	 );

    reg [17:0]counter = 18'h00000;
	 
	 always @(posedge clock) begin
		  counter <= counter + 1;
		  ce1k <= 0;
		  if(counter == 18'd100681) begin
		      counter <= 18'd0;  
		      ce1k <= 1;
		  end									  
    end

endmodule
