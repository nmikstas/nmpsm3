`timescale 1ns / 1ps

//This module controls the timing of the clock and the time change
//functions.  It takes the 50 MHz system clock in as an input and the
//1 KHz clock enable.  It also takes the status of the buttons in so
//it can set the clock time.  The current time of the clock in BCD is
//provided on the output.

module ClockControl(
    input clock,
    input ce_1KHz,
    input [3:0]button,
	 output [7:0]hour,
	 output [7:0]min,
	 output [7:0]sec,
	 output blink
	 );
    
	 reg ce_1Hz         =  1'b0;
    reg [9:0]mscounter = 10'h000;	 
	 reg [3:0]seclo     =  4'h0;
    reg [3:0]sechi     =  4'h0;
    reg [3:0]minlo     =  4'h0;
    reg [3:0]minhi     =  4'h0;
    reg [3:0]hourlo    =  4'h1;
    reg [3:0]hourhi    =  4'h0;
	 
	 assign hour  = {hourhi, hourlo};
	 assign min   = {minhi, minlo};
	 assign sec   = {sechi, seclo};
	 assign blink = mscounter[9];

    always @(posedge clock) begin
	     //Reset 1 second clock enable pulse every clock cycle.
		  ce_1Hz = 1'b0;
				
	     if(ce_1KHz)
				mscounter = mscounter + 1;
					 
		  if(mscounter == 1000) begin
		      mscounter = 0;
				ce_1Hz = 1'b1; //1 second clock enable pulse.
		      seclo = seclo + 1;				
		  end	
					 
		  if(seclo == 10) begin
		      seclo = 0;
				sechi = sechi + 1;
		  end
					 
		  if(sechi == 6) begin
			   sechi = 0;
				minlo = minlo + 1;
		  end
					 
		  if(minlo == 10) begin
			   minlo = 0;
				minhi = minhi + 1;
		  end
					 
		  if(minhi == 6) begin
			   minhi = 0;
				hourlo = hourlo + 1;
		  end
					 
		  if(hourlo == 10) begin
			   hourlo = 0;
				hourhi = hourhi + 1;
		  end
					 
		  if(hourhi == 1 && hourlo == 3) begin
				hourlo = 4'b0001;
				hourhi = 0;
		  end
				
	     //Button inputs used to set the clock time.
	     //Increment the lower minute digit.
        if(button == 4'b0001 && ce_1Hz)
	         minlo = minlo + 1;
					 
	     //Increment the upper minute digit.
	     if(button == 4'b0010 && ce_1Hz)
	         minhi = minhi + 1;
					 
	     //Increment the lower hour digit.
	     if(button == 4'b0100 && ce_1Hz)
		      hourlo = hourlo + 1;					 
    end
endmodule
