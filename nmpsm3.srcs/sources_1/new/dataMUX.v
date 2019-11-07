`timescale 1ns / 1ps

module dataMUX(
    input  [15:0]xpos,
    input  [15:0]ypos,
    input  [15:0]i2cdata,
	input  [15:0]i2cstatus,
    input  read,
	input  blink,
    input  [15:0]id,
    input  [15:0]uartdata,
    input  [11:0]txcount,
    input  [11:0]rxcount,
	input  [7:0]romdata,
	input  [15:0]switches,
	input  [7:0]sec,
	input  [7:0]min,
	input  [7:0]hour,
	input  [15:0]micdata,
    output [15:0]dout
    );

    assign dout = (id == 16'h0001 && read) ? i2cdata                :
                  (id == 16'h0002 && read) ? i2cstatus              :
                  (id == 16'h0003 && read) ? uartdata               :
                  (id == 16'h0004 && read) ? {4'h0, txcount}        :
                  (id == 16'h0005 && read) ? {4'h0, rxcount}        :
                  (id == 16'h0006 && read) ? xpos                   :
                  (id == 16'h0007 && read) ? ypos                   :
                  (id == 16'h0012 && read) ? {8'h00, romdata}       :
	              (id == 16'h0013 && read) ? switches               :
	              (id == 16'h0030 && read) ? {8'h00, sec}           :
                  (id == 16'h0031 && read) ? {8'h00, min}           :
                  (id == 16'h0032 && read) ? {8'h00, hour}          :
                  (id == 16'h0033 && read) ? {15'h0000, blink}      :
				  (id == 16'h0034 && read) ? micdata                :                 						
  	              16'h0000;
endmodule
