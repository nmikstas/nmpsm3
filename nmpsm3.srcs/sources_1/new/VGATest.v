`timescale 1ns / 1ps

module VGATest;

	// Inputs
	reg clk25MHz;
	reg clk;

	// Outputs
	wire vsync;
	wire hsync;
	wire [7:0] vga;
	
	//Internal signals.
	//wire [9:0]hcount;
	//wire [9:0]nextpixel;
	//wire [8:0]currline;
	//wire [7:0]cur256line;
   //wire [8:0]next256pixel;
   //wire [9:0]ntaddra;
	//wire [7:0]bgataddra;
	//wire [2:0]NextState;
	//wire leavewait;
	//wire [10:0]bgptaaddra;
	//wire [10:0]bgptbaddra;
	//wire [7:0]ntdout;
	//wire [7:0]bgptadout;
	//wire [7:0]bgptbdout;
	//wire [8:0]lbaddra;
	//wire [8:0]lbaddrb;
	//wire [7:0]lbdout;						 
   //wire lbwe;	
	wire [7:0]nxt256line;
	wire [8:0]pix256draw;
	wire [4:0]State;
	wire [4:0]NextState;
	wire [6:0]currsprite;
	wire [6:0]spaddrb;
	//wire [7:0]lbdin;
	wire [7:0]spritex;
	wire [7:0]spritey;
	wire [7:0]spriteptrn;
	//wire [7:0]spritemisc;
	wire spriteinrange;
	wire [10:0]aaddrb;
	wire [7:0]bfaddr;
	wire [7:0]adout;
	wire [7:0]bdout;
	wire [7:0]pix;
	wire [7:0]lbcheck;
	//wire bs;
	//wire [2:0]invert;
	//wire [2:0]normal;
	
	//wire [1:0]sc;
	//wire [2:0]soffset    = 3'b000;
	//wire [6:0]currsprite = 7'h00;
	//wire spptabit        = 1'b0;
	//wire spptbbit        = 1'b0;
   

	// Instantiate the Unit Under Test (UUT)
	VGA uut (
		.clk25MHz(clk25MHz),
      .clk(clk),		
		.vsync(vsync), 
		.hsync(hsync), 
		.vga(vga)
	);
	
	//assign hcount       = uut.hcount;
	//assign nextpixel    = uut.nextpixel;
	//assign currline     = uut.currline;
	//assign cur256line   = uut.cur256line;	
	//assign next256pixel = uut.next256pixel[9:1];
   //assign ntaddra      = uut.ntaddra;
	//assign bgataddra    = uut.bgataddra;	
	//assign NextState    = uut.NextState;
	//assign leavewait    = uut.leavewait;
	//assign bgptaaddra   = uut.bgptaaddra;
	//assign bgptbaddra   = uut.bgptbaddra;
	//assign ntdout       = uut.ntdout;
	//assign bgptadout    = uut.bgptadout;
	//assign bgptbdout    = uut.bgptbdout;
	//assign lbaddra      = uut.lbaddra;
	//assign lbaddrb      = uut.lbaddrb;
	//assign lbdout       = uut.lbdout;						 
   //assign lbwe         = uut.lbwe;
	assign nxt256line   = uut.nxt256line;
	assign pix256draw   = uut.pix256draw;
	assign State        = uut.State;
	assign NextState    = uut.NextState;
	assign lbwe         = uut.lbwe;
	assign currsprite   = uut.currsprite;
	assign spaddrb      = uut.spaddrb;
	//assign lbdin        = uut.lbdin;
   assign spritex      = uut.spritex;
	assign spritey      = uut.spritey;
	assign spriteptrn   = uut.spriteptrn;
	//assign spritemisc   = uut.spritemisc;	
	assign spriteinrange= uut.spriteinrange;
	assign aaddrb       = uut.aaddrb;
	assign bfaddr       = uut.bfaddr;
	assign adout        = uut.adout;
	assign bdout        = uut.bdout;
	assign pix          = uut.pix;
	assign lbcheck       = uut.lbcheck;
	//assign bs           = uut.bs;
	//assign invert       = uut.invert;
	//assign normal       = uut.normal;
	//assign sc            = uut.sc;
	//assign soffset       = uut.soffset;
	//assign currsprite    = uut.currsprite;
	//assign spptabit      = uut.spptabit;
	//assign spptbbit      = uut.spptbbit;

	initial begin
		// Initialize Inputs
		clk25MHz = 0;
      clk = 0;		
	end
	
	initial begin
	    forever
		     #19.8609731877 clk25MHz = ~clk25MHz;
	end
	
	initial begin
	    forever
		     #10 clk = ~clk; 
	end
      
endmodule

