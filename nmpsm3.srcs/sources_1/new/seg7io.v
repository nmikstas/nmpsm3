`timescale 1ns / 1ps

module seg7io(
    input clk,
	 input ce1k,
	 input write,
	 input reset,
	 input [15:0]id,
	 input [15:0]din, 
     output reg [3:0]segselect = 4'h0, 
	 output reg [7:0]segs = 8'h00
	 );

    reg [7:0]seg0 = 8'h00;
	reg [7:0]seg1 = 8'h00;
	reg [7:0]seg2 = 8'h00;
	reg [7:0]seg3 = 8'h00;

    always @(posedge ce1k)
	    begin
		    //Constantly cycle through the enable pins.
		    if(segselect == 4'b1110) begin
		        segselect <= 4'b0111;
		        segs <= ~seg0;
		    end
		    else if(segselect == 4'b0111) begin
				segselect <= 4'b1011;
				segs <= ~seg1;
			end
            else if(segselect == 4'b1011) begin
				segselect <= 4'b1101;
				segs <= ~seg2;
			end
			else begin
			    segselect <= 4'b1110;
			    segs <= ~seg3;
			end				    
		end
		  
    always @(posedge clk)
	    begin
		      if(id == 16'h0024 && write)
				   seg0 <= din[7:0];
		      if(id == 16'h0025 && write)
				   seg1 <= din[7:0];
				if(id == 16'h0026 && write)
				   seg2 <= din[7:0];
		      if(id == 16'h0027 && write)
				   seg3 <= din[7:0];
					
				if(reset)
				    begin
					     seg0 <= 8'h00;
						 seg1 <= 8'h00;
						 seg2 <= 8'h00;
						 seg3 <= 8'h00;
					 end												
		  end

endmodule
