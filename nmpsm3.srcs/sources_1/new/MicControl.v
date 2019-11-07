`timescale 1ns / 1ps

module MicControl(
    input clk,
    input done,
	 input [11:0] mdin,
    output reg start,
	 output reg [11:0] mdout
    );

    reg [6:0] counter;

    always @(posedge clk)
	 begin
	     counter = counter + 1;
	     if(counter < 64)
		      start = 1;
		  else
		      start = 0;
		  if(done)
		  //if(counter == 75)
		  begin
		      counter = 0;
				mdout = mdin;
		  end
	 end
endmodule
