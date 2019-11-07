`timescale 1ns / 1ps

module AControl(
    input  clk,                       //System clock.
    input  reset,                     //System reset.
	input  miso,                      //Data from joystick.
	output reg mosi = 1'b0,           //Send constant zero to joystick.
	output reg ss   = 1'b1,           //Slave select.
	output reg sck  = 1'b0,           //Slave clock.
    output reg [15:0]xpos = 16'h0000, //X-position of joystick.
    output reg [15:0]ypos = 16'h0000  //Y-position of joystick.
    );
	
	//State machine states. 
	localparam IDLE    = 2'b00;
	localparam SSLOW   = 2'b01;  
	localparam GETDATA = 2'b10;
	 
	reg [9:0]clockDivider = 10'd0;     //Count to 55 and invert.
	reg [9:0]waitTimer    = 10'h000;   //Count to 1010. 
	reg [10:0]csTimer     = 11'h000;   //Count to 1510.
	 
	reg [1:0]state        = IDLE;      //Current state.
	reg [1:0]nextstate    = IDLE;      //Next state.
    reg [5:0]bitcounter   = 6'h00;     //Count 40 bits.
    reg [39:0]data        = 40'h00;    //40-bit data register.
   
	always @(posedge clk) begin
	    //Handle reset.
        if(reset)
 begin
            clockDivider <= 10'd0;
            state        <= IDLE;
        end
        
		else begin	    
		    clockDivider <= clockDivider + 1'b1;
		    state <= nextstate;
		    
            if(clockDivider == 10'd1000) begin
                if(nextstate == GETDATA)sck <= ~sck;
                clockDivider <= 10'd0;
            end
	    end
	end
	
	//Joystick timing.
	always @(posedge sck) begin
		if(nextstate == IDLE) begin
		    xpos       <= {data[15:0]};         //Update data while idle.
		    ypos       <= {data[31:16]};        //
		    ss         <= 1'b1;                 //Keep joystick unselected.		    	    
		    waitTimer  <= waitTimer + 1'b1;     //Wait 10us befor moving to next state.
		    csTimer    <= 11'h000;              //Zero cs timer.
		    bitcounter <= 6'h00;                //Zero bit counter.
		end
                     
        if(nextstate == SSLOW) begin
            ss         <= 1'b0;                 //Enable the slave select line.
            csTimer    <= csTimer + 1'b1;       //Wait 15us befor moving to next state.
            waitTimer  <= 10'h000;              //Zero wait timer.
            bitcounter <= 6'h00;                //Zero bit counter.
        end
                     				
		if(nextstate == GETDATA) begin
		    data       <= {data[38:0], miso};   //Shift in data bits.
			bitcounter <= bitcounter + 1'b1;    //Get all 40 bits.
			csTimer    <= 11'h000;              //Zero cs timer.
			waitTimer  <= 10'h000;              //Zero wait timer.
		end
    
	  
    end
    
	 
    //State machine logic.
    always @(*) begin
	    case(state)
		    IDLE    : nextstate = (waitTimer < 10'd1010) ? IDLE    : SSLOW;
		    SSLOW   : nextstate = (csTimer < 11'd1510)   ? SSLOW   : GETDATA; 
            GETDATA : nextstate = (bitcounter < 6'd40)   ? GETDATA : IDLE;
            default : nextstate = IDLE;			
	 	endcase
	end
endmodule
