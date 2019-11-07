`timescale 1ns / 1ps

module ledio(
    input clk,
    input reset,
    input write,
    input [15:0]id,
    input [15:0]din,
    output reg [7:0]ledsout = 8'h00
    );	 

    always @(posedge clk)
	     begin	      		  
		      if(id == 16'h0020 && write)
				    ledsout <= din[7:0];
				if(reset)
				    ledsout <= 8'h00;				
		  end

endmodule
