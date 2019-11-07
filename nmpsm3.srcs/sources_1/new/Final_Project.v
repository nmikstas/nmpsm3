`timescale 1ns / 1ps

module Final_Project(
    input clk,
    
    input [15:0]sw,
    
    input btnC,
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    
    input data,
    
    input RsRx,
    output RsTx,
    
    output RxTest,
    output TxTest,
    
    output [15:0]led,
    
    output [6:0]seg,
    output [3:0]an,
    output dp, 
    
    output [3:0]vgaRed,
    output [3:0]vgaGreen,
    output [3:0]vgaBlue,
    output Hsync,
    output Vsync,
    
    output sclk,
    output ce
    );
    
    //UART test ports.
    assign RxTest = RsRx;
    assign TxTest = RsTx;
    
    wire clk100MHz;
    wire clk50MHz;
    wire clk25MHz;
    wire t0out;
    wire t1out;
    wire ack0;
    wire ack1;
    wire ack2;
    wire ack3;
    wire sigout0;
    wire sigout1;
    wire sigout2;
    wire sigout3;
    wire ce1k;
    wire blink;
    wire read;
    wire write;
    wire vblank;
    wire reset;
    wire [15:0]id;
    wire [15:0]outdata;
    wire [7:0]hour;
    wire [7:0]min;
    wire [7:0]sec;
    wire [35:0]inst;
    wire [15:0]in_port;
    wire [15:0]address;
    wire [7:0]romdata;
    wire [11:0]mdout;
    wire [7:0]vgadata;
    wire [9:0]addr;
    wire [10:0]romaddress;
    wire [11:0]mdin;
    
    //UART wires.
    wire [7:0]uartdata;
    wire [11:0]txcount;
    wire [11:0]rxcount;  
    
    //Unused VGA bits in this design.
    assign vgaRed[0] = 1'b0;
    assign vgaGreen[0] = 1'b0;
    assign vgaBlue[0] = 1'b0;
    assign vgaBlue[1] = 1'b0;
    
    //Reset signal.
    assign reset = btnU;
   
    //Flip-flop for interrupt 0.
    FF ff0(.set(t0out), .reset(ack0), .sigout(sigout0));
         
    //Flip-flop for interrupt 1.
    FF ff1(.set(t1out), .reset(ack1), .sigout(sigout1));
         
    //Flip-flop for interrupt 2.
    FF ff2(.set(vblank), .reset(ack2), .sigout(sigout2));
         
    //Flip-flop for interrupt 3(not used).
    FF ff3(.set(1'b0), .reset(ack3), .sigout(sigout3));
    
    //Divide by 100,000.
    div100k divideBy100K(.clock(clk100MHz), .ce1k(ce1k));
    
    //Clock divider.
    clk25 c(.clk_in1(clk), .clk_out1(clk100MHz), .clk_out2(clk50MHz), .clk_out3(clk25MHz));
    
    //NMPSM3 soft processor.	 
    NMPSM3 nmpsm3(.clk(clk100MHz), .reset(reset), .IRQ0(sigout0), .IRQ1(sigout1), .IRQ2(sigout2), .IRQ3(sigout3),
                  .INSTRUCTION(inst), .IN_PORT(in_port), .READ_STROBE(read), .WRITE_STROBE(write), .IRQ_ACK0(ack0),
                  .IRQ_ACK1(ack1), .IRQ_ACK2(ack2), .IRQ_ACK3(ack3), .ADDRESS(address), .OUT_PORT(outdata), 
                  .PORT_ID(id));
                  
    //Program ROM for NMPSM3.
    Program_ROM prgROM(.clka(clk100MHz), .addra(address[9:0]), .douta(inst));
    
    //Lookup ROM
    Lookup_ROM lookuprom(.clka(clk100MHz), .addra(romaddress), .douta(romdata));
    
    //UART
    uart uart1(.clk(clk100MHz), .reset(reset), .id(id), .din(outdata), .write(write), .rx(RsRx), .tx(RsTx),
               .dout(uartdata), .rxcount(rxcount), .txcount(txcount));
    
    //LED output controller.	 
    ledio LEDIO(.clk(clk100MHz), .reset(reset), .write(write), .id(id), .din(outdata), .ledsout(led[7:0]));
    
    //LED output controller 2.
    LEDIO2 ledio2(.clk(clk100MHz), .reset(reset), .write(write), .id(id), .din(outdata), .ledsout(led[15:8]));
    
    //Seven segment controller.
    seg7io seg7control(.clk(clk100MHz), .ce1k(ce1k), .write(write), .reset(reset), .id(id), .din(outdata),
                       .segselect(an), .segs({dp,seg}));
                                              
    //Timer 0.
    timer0 time0(.clk(clk100MHz), .cein(ce1k), .write(write), .reset(reset), .id(id), .din(outdata), .dout(t0out));
                            
    //Timer 1.
    timer1 time1(.clk(clk100MHz), .cein(ce1k), .write(write), .reset(reset), .id(id), .din(outdata), .dout(t1out));
    
    //ROM controller for lookup ROM.
    ROMcontroller ROMcontrol(.clk(clk100MHz), .id(id), .ain(outdata), .aout(romaddress));
                    
    //Processor input data MUX.
    dataMUX datamux(.read(read), .blink(blink), .id(id), .i2cdata(16'd0), .i2cstatus(16'd0), .xpos(16'd0), .ypos(16'd0), 
                    .uartdata({8'h00,uartdata}), .txcount(txcount), .rxcount(rxcount), .romdata(romdata),
                    .switches(sw), .sec(sec), .min(min), .hour(hour), .micdata({btnD, 3'h0, mdout}), 
                    .dout(in_port)); 
                                         
    //Clock control.
    ClockControl clockcontrol(.clock(clk100MHz), .ce_1KHz(ce1k), .button({btnD, btnL, btnC, btnR}), .blink(blink), 
                              .hour(hour), .min(min), .sec(sec));  
                                           
    //Picture processing unit.
    VGA ppu(.clk25MHz(clk25MHz), .clk(clk100MHz), .write(write), .id(id), .data(outdata[7:0]), 
            .vblank(vblank), .vsync(Vsync), .hsync(Hsync), .vga({vgaBlue[3:2], vgaGreen[3:1], vgaRed[3:1]}));    
            
    //Microphone control.
    MControl mc(.clk(clk100MHz), .reset(reset), .serialdata(data), .nenable(ce), .sclk(sclk), .micdata(mdout));          
endmodule
