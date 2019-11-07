`timescale 1ns / 1ps

module timer0(
    input clk,
    input cein,
	 input write,
	 input [15:0] id,
	 input [15:0] din,
	 input reset,
	 output reg dout = 1'b0
	 );

    reg [15:0] timerreg = 16'h0000;

    always @(posedge clk) begin
	         dout <= 1'b0;
		      //Load timer bits.
		      if(id == 16'h0010 && write)
				    timerreg <= din;    
            //Decrement timer if not 0.
            if(cein && timerreg > 1'b1)			
				    timerreg <= timerreg - 1'b1;
				//One timer is about to expire, send output strobe.
				if(cein && timerreg == 1'b1) begin
				    timerreg <= timerreg - 1'b1;
					 dout <= 1'b1;
				end
				//Synchronous reset.   
            if(reset)
                timerreg <= 16'h0000;					 
		  end

endmodule
