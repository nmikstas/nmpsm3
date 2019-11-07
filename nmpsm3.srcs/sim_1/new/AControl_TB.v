`timescale 1ns / 1ps

module AControl_TB;
    reg clk = 1'b0;
    reg reset = 1'b1;
    reg miso = 1'b1;
    wire mosi;
    wire ss;
    wire sck;
    wire [15:0]xpos;
    wire [15:0]ypos;
       
    AControl dut(.clk(clk), .reset(reset), .miso(miso), .mosi(mosi), 
                 .ss(ss), .sck(sck), .xpos(xpos), .ypos(ypos));
     
    always #5 clk = ~clk;
    
    initial begin
        #100 reset = 1'b0;
    end    
endmodule
