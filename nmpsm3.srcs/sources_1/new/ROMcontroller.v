`timescale 1ns / 1ps

module ROMcontroller(
    input [15:0]id,
    input [15:0]ain,
	 input clk,
    output reg [10:0]aout = 11'h000
    );
    
	 always @(posedge clk) begin
        if(id == 16'h0000)
		      aout <= {3'b000, ain[7:0]};
        if(id == 16'h0001)
		      aout <= {3'b001, ain[7:0]};
        if(id == 16'h0002)
		      aout <= {3'b010, ain[7:0]};
        if(id == 16'h0003)
		      aout <= {3'b011, ain[7:0]};
        if(id == 16'h0004)
		      aout <= {3'b100, ain[7:0]};
        if(id == 16'h0005)
		      aout <= {3'b101, ain[7:0]};
        if(id == 16'h0006)
		      aout <= {3'b110, ain[7:0]};
        if(id == 16'h0007)
		      aout <= {3'b111, ain[7:0]};
    end
endmodule
