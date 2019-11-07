`timescale 1ns / 1ps

module MControl(
    input  clk,
    input  reset,
	 input  serialdata,
	 output nenable,
	 output reg sclk = 1'b1,
    output reg [11:0]micdata = 12'h000
    );
	 
	 parameter WAIT    = 2'b00;
	 parameter GETDATA = 2'b01;
	 parameter PUTDATA = 2'b10;
	 parameter QUIET   = 2'b11;

	 reg [1:0]clockdivider = 2'b00;
	 reg [1:0]state        = WAIT;
	 reg [1:0]nextstate    = WAIT;
    reg [4:0]bitcounter   = 5'h00;
    reg [11:0]datahold    = 12'h000;

    nand nen(nenable, ~state[1], state[0]);	 
	 
	 always @(posedge clk) begin
	     if(!reset)
		      clockdivider <= clockdivider + 1'b1;
		  else begin
		      clockdivider <= 2'b00;
				sclk <= 1'b0;
		  end
				
		  if(clockdivider == 2'b01)
		      sclk <= 1'b1;
		  if(clockdivider == 2'b11)
		      sclk <= 1'b0;
	 end
	 
	 always @(posedge sclk) begin
        if(reset)
		      state       <= WAIT;
		  else
		      state       <= nextstate;
				
		  if(nextstate == GETDATA) begin
				bitcounter  <= bitcounter + 1'b1;
				datahold    <= {datahold[10:0], serialdata};
		  end
		  if(nextstate == PUTDATA) begin
	         datahold    <= {datahold[10:0], serialdata};
				bitcounter  <= 5'h00;
		  end		      
		  if(nextstate == WAIT)
		      micdata     <= datahold;
    end
	 
	 always @(state, reset, bitcounter) begin
	     case(state)
		      WAIT    : nextstate = (reset)               ? WAIT    : GETDATA;
            GETDATA : nextstate = (bitcounter == 5'h10) ? PUTDATA : GETDATA;
            PUTDATA : nextstate = WAIT;
            QUIET   : nextstate = WAIT;				
	 	  endcase
	 end

endmodule
