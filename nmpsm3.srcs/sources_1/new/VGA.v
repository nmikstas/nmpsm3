`timescale 1ns / 1ps

//Address ports:
//0x8000 - 0x87FF Background pattern table A.
//0x8800 - 0x8FFF Background pattern table B.
//0x9000 - 0x97FF Sprite pattern table A.
//0x9800 - 0x9FFF Sprite pattern table B.
//0xA000 - 0xA3FF Name table.
//0xA400 - 0xA4FF Unused.
//0xA500 - 0xA5FF Background attribute table.
//0xA600 - 0xA60F Background pallettes 0 through 15.
//0xA610 - 0xA61F Sprite pallettes 0 through 15.
//0xA700          Base color (background color).
//0xB000 - 0xB3FF Sprite RAM (256 sprites).

module VGA(
    input clk25MHz,
	input clk,
	input write,
	input [15:0]id,
	input [7:0]data,
    output reg vblank = 1'b0,	 
    output reg vsync = 1'b1,
    output reg hsync = 1'b1,
    output reg [7:0]vga = 8'h00
    );
	 
	parameter WAIT  = 5'h00;
	parameter NTAT  = 5'h01;
	parameter PTAB  = 5'h02;
    parameter BUFF  = 5'h03;
    parameter NEXT  = 5'h04;
    parameter SPRAM = 5'h05;
    parameter SAB   = 5'h06;
    parameter WRIT0 = 5'h07;
    parameter WRIT1 = 5'h08;
    parameter WRIT2 = 5'h09;
    parameter WRIT3 = 5'h0A;
    parameter WRIT4 = 5'h0B;
    parameter WRIT5 = 5'h0C;
    parameter WRIT6 = 5'h0D;
    parameter WRIT7 = 5'h0E;
    parameter BUFF0 = 5'h0F;				 
    parameter BUFF1 = 5'h10;				  
    parameter BUFF2 = 5'h11;				  
    parameter BUFF3 = 5'h12;				 
    parameter BUFF4 = 5'h13;				 
    parameter BUFF5 = 5'h14;				  
    parameter BUFF6 = 5'h15;				 
    parameter BUFF7 = 5'h16;				 
    
    reg [9:0]hcount       = 10'h001;
	reg [9:0]vcount       = 10'h001;
	reg [9:0]nextpixel    = 10'h000;
	reg [9:0]nextpixel2   = 10'h000;
    reg [8:0]currline     =  9'h000;
    reg [9:0]next256pixel =  9'h000;
	 
	wire [8:0]nxt256pix;
	wire [7:0]cur256line;
	wire [7:0]nxt256line;
    wire [7:0]colorout;	 
	 
	reg [8:0]currsprite = 9'h000;
	reg [7:0]basecolor  = 8'h00;
	 
	reg [7:0]bgpal0  = 8'b00000000;
	reg [7:0]bgpal1  = 8'b00111000;
	reg [7:0]bgpal2  = 8'b00100000;
	reg [7:0]bgpal3  = 8'b00011000;
	reg [7:0]bgpal4  = 8'b00000000;
	reg [7:0]bgpal5  = 8'b00111111;
	reg [7:0]bgpal6  = 8'b00100100;
	reg [7:0]bgpal7  = 8'b00011011;
	reg [7:0]bgpal8  = 8'b00000000;
	reg [7:0]bgpal9  = 8'b00011111;
	reg [7:0]bgpal10 = 8'b00010100;
	reg [7:0]bgpal11 = 8'b00001010;
	reg [7:0]bgpal12 = 8'b00000000;
	reg [7:0]bgpal13 = 8'b00000111;
	reg [7:0]bgpal14 = 8'b00000100;
	reg [7:0]bgpal15 = 8'b00000011;
	 
	reg [7:0]sppal0  = 8'b00000000;
	reg [7:0]sppal1  = 8'b00100110;
	reg [7:0]sppal2  = 8'b00111111;
	reg [7:0]sppal3  = 8'b00000010;
	reg [7:0]sppal4  = 8'b00000000;
	reg [7:0]sppal5  = 8'b10111111;
	reg [7:0]sppal6  = 8'b10100100;
	reg [7:0]sppal7  = 8'b10011011;
	reg [7:0]sppal8  = 8'b00000000;
	reg [7:0]sppal9  = 8'b10011111;
	reg [7:0]sppal10 = 8'b10010100;
	reg [7:0]sppal11 = 8'b10001010;
	reg [7:0]sppal12 = 8'b00000000;
	reg [7:0]sppal13 = 8'b10000111;
	reg [7:0]sppal14 = 8'b10000100;
	reg [7:0]sppal15 = 8'b10000011;
	 
	always @(posedge clk) begin
	    if(id == 16'hA600 && write) bgpal0 <= data;
	    if(id == 16'hA601 && write) bgpal1 <= data;
	    if(id == 16'hA602 && write) bgpal2 <= data;
	    if(id == 16'hA603 && write) bgpal3 <= data;
	    if(id == 16'hA604 && write) bgpal4 <= data;
	    if(id == 16'hA605 && write) bgpal5 <= data;
	    if(id == 16'hA606 && write) bgpal6 <= data;
		if(id == 16'hA607 && write) bgpal7 <= data;
		if(id == 16'hA608 && write) bgpal8 <= data;
		if(id == 16'hA609 && write) bgpal9 <= data;
		if(id == 16'hA60A && write) bgpal10 <= data;
		if(id == 16'hA60B && write) bgpal11 <= data;
		if(id == 16'hA60C && write) bgpal12 <= data;
		if(id == 16'hA60D && write) bgpal13 <= data;
		if(id == 16'hA60E && write) bgpal14 <= data;
		if(id == 16'hA60F && write) bgpal15 <= data;
		
		if(id == 16'hA610 && write) sppal0  <= data;
		if(id == 16'hA611 && write) sppal1  <= data;
		if(id == 16'hA612 && write) sppal2  <= data;
		if(id == 16'hA613 && write) sppal3  <= data;
		if(id == 16'hA614 && write) sppal4  <= data;
		if(id == 16'hA615 && write) sppal5  <= data;
		if(id == 16'hA616 && write) sppal6  <= data;
		if(id == 16'hA617 && write) sppal7  <= data;
		if(id == 16'hA618 && write) sppal8  <= data;
		if(id == 16'hA619 && write) sppal9  <= data;
		if(id == 16'hA61A && write) sppal10  <= data;
		if(id == 16'hA61B && write) sppal11  <= data;
		if(id == 16'hA61C && write) sppal12  <= data;
		if(id == 16'hA61D && write) sppal13  <= data;
		if(id == 16'hA61E && write) sppal14  <= data;
		if(id == 16'hA61F && write) sppal15  <= data;
		
	    if(id == 16'hA700 && write) basecolor <= data;
    end 
	 
	//Line buffer wires and regs.
	reg  lbwe = 1'b0;
	wire [8:0]lbaddra;
	wire [7:0]lbdin;
	wire lbrstb;
	wire [8:0]lbaddrb;
	wire [7:0]lbdout;
	wire [7:0]lbcheck;
	 
    RAMB16_S9_S9 #(
	    //Test pattern.
	    .INIT_00(256'h00_01_02_03_04_05_06_07_08_09_0A_0B_0C_0D_0E_0F_10_11_12_13_14_15_16_17_18_19_1A_1B_1C_1D_1E_1F),
        .INIT_01(256'h20_21_22_23_24_25_26_27_28_29_2A_2B_2C_2D_2E_2F_30_31_32_33_34_35_36_37_38_39_3A_3B_3C_3D_3E_3F),
        .INIT_02(256'h40_41_42_43_44_45_46_47_48_49_4A_4B_4C_4D_4E_4F_50_51_52_53_54_55_56_57_58_59_5A_5B_5C_5D_5E_5F),
        .INIT_03(256'h60_61_62_63_64_65_66_67_68_69_6A_6B_6C_6D_6E_6F_70_71_72_73_74_75_76_77_78_79_7A_7B_7C_7D_7E_7F),
        .INIT_04(256'h80_81_82_83_84_85_86_87_88_89_8A_8B_8C_8D_8E_8F_90_91_92_93_94_95_96_97_98_99_9A_9B_9C_9D_9E_9F),
        .INIT_05(256'hA0_A1_A2_A3_A4_A5_A6_A7_A8_A9_AA_AB_AC_AD_AE_AF_B0_B1_B2_B3_B4_B5_B6_B7_B8_B9_BA_BB_BC_BD_BE_BF),
        .INIT_06(256'hC0_C1_C2_C3_C4_C5_C6_C7_C8_C9_CA_CB_CC_CD_CE_CF_D0_D1_D2_D3_D4_D5_D6_D7_D8_D9_DA_DB_DC_DD_DE_DF),
        .INIT_07(256'hE0_E1_E2_E3_E4_E5_E6_E7_E8_E9_EA_EB_EC_ED_EE_EF_F0_F1_F2_F3_F4_F5_F6_F7_F8_F9_FA_FB_FC_FD_FE_FF),
        .INIT_08(256'h0F_0E_0D_0C_0B_0A_09_08_07_06_05_04_03_02_01_00_1F_1E_1D_1C_1B_1A_19_18_17_16_15_14_13_12_11_10),
        .INIT_09(256'h2F_2E_2D_2C_2B_2A_29_28_27_26_25_24_23_22_21_20_3F_3E_3D_3C_3B_3A_39_38_37_36_35_34_33_32_31_30),
        .INIT_0A(256'h4F_4E_4D_4C_4B_4A_49_48_47_46_45_44_43_42_41_40_5F_5E_5D_5C_5B_5A_59_58_57_56_55_54_53_52_51_50),
        .INIT_0B(256'h6F_6E_6D_6C_6B_6A_69_68_67_66_65_64_63_62_61_60_7F_7E_7D_7C_7B_7A_79_78_77_76_75_74_73_72_71_70),
        .INIT_0C(256'h8F_8E_8D_8C_8B_8A_89_88_87_86_85_84_83_82_81_80_9F_9E_9D_9C_9B_9A_99_98_97_96_95_94_93_92_91_90),
        .INIT_0D(256'hAF_AE_AD_AC_AB_AA_A9_A8_A7_A6_A5_A4_A3_A2_A1_A0_BF_BE_BD_BC_BB_BA_B9_B8_B7_B6_B5_B4_B3_B2_B1_B0),
        .INIT_0E(256'hCF_CE_CD_CC_CB_CA_C9_C8_C7_C6_C5_C4_C3_C2_C1_C0_DF_DE_DD_DC_DB_DA_D9_D8_D7_D6_D5_D4_D3_D2_D1_D0),
        .INIT_0F(256'hEF_EE_ED_EC_EB_EA_E9_E8_E7_E6_E5_E4_E3_E2_E1_E0_FF_FE_FD_FC_FB_FA_F9_F8_F7_F6_F5_F4_F3_F2_F1_F0))
    LineBufferRAM (
        .DOA(lbcheck),	 
        .DOB(lbdout),             // Port B 8-bit Data Output      
        .ADDRA({2'b00, lbaddra}), // Port A 11-bit Address Input
        .ADDRB({2'b00, lbaddrb}), // Port B 11-bit Address Input
        .CLKA(clk),               // Port A Clock
        .CLKB(clk25MHz),          // Port B Clock
        .DIA(lbdin),              // Port A 8-bit Data Input
		.DIPA(1'b0),              // 1-bit Parity
        .ENA(1'b1),               // Port A RAM Enable Input
        .ENB(1'b1),               // Port B RAM Enable Input
        .SSRA(1'b0),              // Port A Synchronous Set/Reset Input
        .SSRB(lbrstb),            // Port B Synchronous Set/Reset Input
        .WEA(lbwe),               // Port A Write Enable Input
        .WEB(1'b0)                // Port B Write Enable Input
    );
	 
	//Name table wires and regs.
	wire [7:0]ntdout;
	wire [9:0]ntaddra;
	wire [9:0]ntaddrb;
	wire [7:0]ntdin;
	wire ntwe;
	 
	assign ntdin = data;
	assign ntaddrb = id - 16'hA000;
	assign ntwe = (id >= 16'hA000 && id <= 16'hA3FF) ? write : 1'b0;
	
	RAMB16_S9_S9 #(
	    .INIT_00(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_01(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_02(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_03(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_04(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_05(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_06(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_07(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_08(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_09(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_0A(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_0B(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_0C(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_0D(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_0E(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_0F(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_10(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_11(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_12(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_13(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_14(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_15(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_16(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_17(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_18(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_19(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_1A(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_1B(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_1C(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_1D(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_1E(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF),
        .INIT_1F(256'hFF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF_FF))
	 NameTableRAM (
        .DOA(ntdout),             // Port B 8-bit Data Output
        .ADDRA({1'b0, ntaddra}),  // Port A 11-bit Address Input
        .ADDRB({1'b0, ntaddrb}),  // Port B 11-bit Address Input
        .CLKA(clk),               // Port A Clock
        .CLKB(clk),               // Port B Clock
        .DIB(ntdin),              // Port A 8-bit Data Input
		.DIPB(1'b0),              // 1-bit Parity
        .ENA(1'b1),               // Port A RAM Enable Input
        .ENB(1'b1),               // Port B RAM Enable Input
        .SSRA(1'b0),              // Port A Synchronous Set/Reset Input
        .SSRB(1'b0),              // Port B Synchronous Set/Reset Input
        .WEA(1'b0),               // Port A Write Enable Input
        .WEB(ntwe)                // Port B Write Enable Input
    );
	 
	//Background pattern table A wires.
	wire [7:0]bgptadout;
	wire [10:0]bgptaaddra;
	wire [10:0]bgptaaddrb;
	wire [7:0]bgptadin;
	wire bgptawe;

    assign bgptadin = data;
    assign bgptaaddrb = id - 16'h8000;
    assign bgptawe = (id >= 16'h8000 && id <= 16'h87FF) ? write : 1'b0; 	 
	 
	RAMB16_S9_S9 #(
        .INIT_00(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_01(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_02(256'h00_FC_C6_C6_FC_C6_C6_FC_00_C6_C6_FE_C6_C6_6C_38_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_03(256'h00_C0_C0_C0_FC_C0_C0_FE_00_FE_C0_C0_FC_C0_C0_FE_00_F8_CC_C6_C6_C6_CC_F8_00_3C_66_C0_C0_C0_66_3C),
        .INIT_04(256'h00_7C_C6_C6_06_06_06_1E_00_7E_18_18_18_18_18_7E_00_C6_C6_C6_FE_C6_C6_C6_00_3E_66_C6_CE_C0_60_3E),
        .INIT_05(256'h00_C6_CE_DE_FE_F6_E6_C6_00_C6_C6_D6_FE_FE_EE_C6_00_7E_60_60_60_60_60_60_00_CE_DC_F8_F0_D8_CC_C6),
        .INIT_06(256'h00_CE_DC_F8_CE_C6_C6_FC_00_7A_CC_DE_C6_C6_C6_7C_00_C0_C0_FC_C6_C6_C6_FC_00_7C_C6_C6_D6_C6_C6_7C),
        .INIT_07(256'h00_10_38_7C_EE_C6_C6_C6_00_7C_C6_C6_C6_C6_C6_C6_00_18_18_18_18_18_18_7E_00_7C_C6_06_7C_C0_CC_78),
        .INIT_08(256'h00_FE_E0_70_38_1C_0E_FE_00_18_18_18_3C_66_66_66_00_C6_EE_7C_38_7C_EE_C6_00_C6_EE_FE_FE_D6_C6_C6),
        .INIT_09(256'h00_1C_24_24_1C_04_04_00_00_38_40_40_40_38_00_00_00_38_24_24_38_20_20_00_00_34_48_48_38_08_30_00),
        .INIT_0A(256'h00_24_24_24_38_20_20_00_00_08_14_0C_3A_48_30_00_00_10_10_10_3C_10_18_00_00_3C_40_78_44_38_00_00),
        .INIT_0B(256'h00_16_08_14_14_14_08_00_00_4C_70_50_48_40_40_00_00_30_48_08_08_00_08_00_00_10_10_10_00_10_00_00),
        .INIT_0C(256'h00_20_20_38_24_24_38_00_00_30_48_48_48_30_00_00_00_48_48_48_48_30_00_00_00_54_54_54_54_28_00_00),
        .INIT_0D(256'h00_18_20_20_20_70_20_00_00_78_04_38_40_38_00_00_00_10_10_10_1C_60_00_00_00_04_0A_38_48_48_30_00),
        .INIT_0E(256'h00_44_28_10_28_44_00_00_00_28_54_54_54_44_00_00_00_10_38_28_44_44_00_00_00_34_48_48_48_48_00_00),
        .INIT_0F(256'h00_00_00_00_7C_00_00_00_00_08_00_08_02_22_1C_00_00_7C_20_10_08_7C_00_00_00_18_24_04_1C_24_24_00),
        .INIT_10(256'h04_04_FC_00_00_00_00_01_20_20_3F_00_00_00_00_80_80_00_00_00_00_00_00_00_01_00_00_00_00_00_00_00),
        .INIT_11(256'h82_82_82_82_82_82_82_82_FF_00_00_00_00_00_FF_00_FE_02_02_02_02_02_FE_00_7F_40_40_40_40_40_7F_00),
        .INIT_12(256'h00_00_FF_80_00_00_00_80_00_00_FF_01_00_00_00_01_82_82_82_82_82_02_04_08_41_41_41_41_41_40_20_10),
        .INIT_13(256'h10_60_80_00_00_00_00_00_08_06_01_00_00_00_00_00_02_02_04_08_10_60_80_00_40_40_20_10_08_06_01_00),
        .INIT_14(256'h01_00_00_00_00_FC_04_04_80_00_00_00_00_3F_20_20_00_00_00_00_00_00_00_80_00_00_00_00_00_00_00_01),
        .INIT_15(256'h00_FF_00_00_00_00_00_FF_41_41_41_41_41_41_41_41_00_FE_82_82_82_82_82_82_00_7F_40_40_40_40_40_7F),
        .INIT_16(256'h80_00_00_00_80_FF_00_00_01_00_00_00_01_FF_00_00_08_04_02_82_82_82_82_82_10_20_40_41_41_41_41_41),
        .INIT_17(256'h00_00_00_00_00_80_60_10_00_00_00_00_00_01_06_08_00_80_60_10_08_04_02_02_00_01_06_08_10_20_40_40),
        .INIT_18(256'h00_00_00_00_00_7F_40_40_40_40_7F_00_00_00_00_00_00_00_FF_00_00_00_00_00_00_00_00_00_00_FF_00_00),
        .INIT_19(256'h20_20_20_20_10_08_04_02_80_80_00_00_00_00_00_00_00_00_01_01_02_0C_F0_00_00_80_40_20_10_0C_03_00),
        .INIT_1A(256'h00_00_00_00_00_3F_20_20_04_04_FC_80_80_80_80_80_00_00_C0_40_40_40_40_C0_00_00_1F_10_08_04_02_01),
        .INIT_1B(256'h1C_22_41_41_41_22_1C_00_00_80_80_80_80_80_80_80_80_80_80_80_80_FC_04_04_40_40_40_40_40_C0_00_00),
        .INIT_1C(256'h41_40_40_40_40_40_7F_00_00_FE_02_02_02_02_02_FE_00_7F_40_40_40_40_40_40_01_00_00_00_00_00_00_00),
        .INIT_1D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_61_41_43_00_61_41_43_00_40_40_41_41_41_41_41_41),
        .INIT_1E(256'h00_00_00_00_00_00_00_00_FF_FF_AA_55_AA_55_AA_55_AA_55_AA_55_AA_55_AA_55_AA_55_AA_55_AA_55_FF_FF),
        .INIT_1F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_61_41_43_00_61_41_43_00),
        .INIT_20(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_21(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_22(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_23(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_24(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_25(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_26(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_27(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_28(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_29(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2A(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2B(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2C(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2E(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_30(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_31(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_32(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_33(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_34(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_35(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_36(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_37(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_38(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_39(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3A(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3B(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3C(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3E(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00))	 
    BGPatternTableARAM (
        .DOA(bgptadout),          // Port B 8-bit Data Output
        .ADDRA(bgptaaddra),       // Port A 11-bit Address Input
        .ADDRB(bgptaaddrb),       // Port B 11-bit Address Input
        .CLKA(clk),               // Port A Clock
        .CLKB(clk),               // Port B Clock
        .DIB(bgptadin),           // Port A 8-bit Data Input
		.DIPB(1'b0),              // 1-bit Parity
        .ENA(1'b1),               // Port A RAM Enable Input
        .ENB(1'b1),               // Port B RAM Enable Input
        .SSRA(1'b0),              // Port A Synchronous Set/Reset Input
        .SSRB(1'b0),              // Port B Synchronous Set/Reset Input
        .WEA(1'b0),               // Port A Write Enable Input
        .WEB(bgptawe)             // Port B Write Enable Input
    );
	 
	//Background pattern table B wires.
	wire [7:0]bgptbdout;
	wire [10:0]bgptbaddra;
	wire [10:0]bgptbaddrb;
	wire [7:0]bgptbdin;
	wire bgptbwe;	
	 
	assign bgptbdin = data;
	assign bgptbaddrb = id - 16'h8800;
	assign bgptbwe = (id >= 16'h8800 && id <= 16'h8FFF) ? write : 1'b0;
	 
	RAMB16_S9_S9 #(
        .INIT_00(256'h00_7C_C6_06_3C_18_0C_7E_00_FE_E0_78_3C_0E_C6_7C_00_7E_18_18_18_18_38_18_00_7C_C6_C6_C6_C6_C6_7C),
        .INIT_01(256'h00_30_30_30_18_0C_C6_FE_00_7C_C6_C6_FC_C0_60_3C_00_7C_C6_06_06_FC_C0_FC_00_0C_0C_FE_CC_6C_3C_1C),
        .INIT_02(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_78_0C_06_7E_C6_C6_7C_00_7C_C6_C6_7C_C6_C6_7C),
        .INIT_03(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_04(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_05(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_06(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_07(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_08(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_09(256'h00_1C_24_24_1C_04_04_00_00_38_40_40_40_38_00_00_00_38_24_24_38_20_20_00_00_34_48_48_38_08_30_00),
        .INIT_0A(256'h00_24_24_24_38_20_20_00_00_08_14_0C_3A_48_30_00_00_10_10_10_3C_10_18_00_00_3C_40_78_44_38_00_00),
        .INIT_0B(256'h00_16_08_14_14_14_08_00_00_4C_70_50_48_40_40_00_00_30_48_08_08_00_08_00_00_10_10_10_00_10_00_00),
        .INIT_0C(256'h00_20_20_38_24_24_38_00_00_30_48_48_48_30_00_00_00_48_48_48_48_30_00_00_00_54_54_54_54_28_00_00),
        .INIT_0D(256'h00_18_20_20_20_70_20_00_00_78_04_38_40_38_00_00_00_10_10_10_1C_60_00_00_00_04_0A_38_48_48_30_00),
        .INIT_0E(256'h00_44_28_10_28_44_00_00_00_28_54_54_54_44_00_00_00_10_38_28_44_44_00_00_00_34_48_48_48_48_00_00),
        .INIT_0F(256'h00_00_00_00_7C_00_00_00_00_08_00_08_02_22_1C_00_00_7C_20_10_08_7C_00_00_00_18_24_04_1C_24_24_00),
        .INIT_10(256'hF8_F8_00_00_00_00_00_01_3F_3F_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_11(256'hFC_FC_FC_FC_FC_FC_FC_FC_FF_FF_FF_FF_FF_FF_00_00_FC_FC_FC_FC_FC_FC_00_00_7F_7F_7F_7F_7F_7F_00_00),
        .INIT_12(256'hFF_FF_00_00_00_00_00_00_FF_FF_00_00_00_00_00_01_FC_FC_FC_FC_FC_FC_F8_F0_7E_7E_7E_7E_7E_7F_3F_1F),
        .INIT_13(256'hE0_80_00_00_00_00_00_00_0F_07_00_00_00_00_00_00_FC_FC_F8_F0_E0_80_00_00_7F_7F_3F_1F_0F_07_00_00),
        .INIT_14(256'h00_00_00_00_00_F8_F8_F8_00_00_00_00_00_3F_3F_3F_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_01),
        .INIT_15(256'h00_FF_FF_FF_FF_FF_FF_00_7E_7E_7E_7E_7E_7E_7E_7E_00_FC_FC_FC_FC_FC_FC_FC_00_7F_7F_7F_7F_7F_7F_00),
        .INIT_16(256'h00_00_00_00_00_FF_FF_FF_00_00_00_00_01_FF_FF_FF_F0_F8_FC_FC_FC_FC_FC_FC_1F_3F_7F_7E_7E_7E_7E_7E),
        .INIT_17(256'h00_00_00_00_00_00_80_E0_00_00_00_00_00_01_07_0F_00_80_80_E0_F0_F8_FC_FC_00_01_07_0F_1F_3F_7F_7F),
        .INIT_18(256'h00_00_00_00_00_7F_7F_7F_7F_7F_00_00_00_00_00_00_FF_FF_00_00_00_00_00_00_00_00_00_00_00_FF_FF_FF),
        .INIT_19(256'h3F_3F_3F_3F_1F_0F_07_03_00_00_00_00_00_00_00_00_FF_FF_FE_FE_FC_F0_00_00_FF_FF_7F_3F_1F_0F_00_00),
        .INIT_1A(256'h00_00_00_00_00_3F_3F_3F_F8_F8_00_00_00_00_00_00_FF_FF_7F_7F_7F_7F_7F_7F_FF_FF_E0_E0_F0_F8_FC_FE),
        .INIT_1B(256'h1C_3C_7E_7E_7E_3C_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_F8_F8_F8_7F_7F_7F_7F_7F_FF_FF_FF),
        .INIT_1C(256'h7F_7F_7F_7F_7F_7F_00_00_00_FC_FC_FC_FC_FC_FC_00_00_7F_7F_7F_7F_7F_7F_7F_01_00_00_00_00_00_00_00),
        .INIT_1D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_7F_7F_7E_7E_7E_7E_7E_7E),
        .INIT_1E(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_1F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_7E_7E_7C_00_7E_7E_7C_00),
        .INIT_20(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_21(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_22(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_23(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_24(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_25(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_26(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_27(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_28(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_29(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2A(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2B(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2C(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2E(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_30(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_31(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_32(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_33(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_34(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_35(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_36(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_37(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_38(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_39(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3A(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3B(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3C(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3E(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00))
	BGPatternTableBRAM (
        .DOA(bgptbdout),          // Port B 8-bit Data Output
        .ADDRA(bgptbaddra),       // Port A 11-bit Address Input
        .ADDRB(bgptbaddrb),       // Port B 11-bit Address Input
        .CLKA(clk),               // Port A Clock
        .CLKB(clk),               // Port B Clock
        .DIB(bgptbdin),           // Port A 8-bit Data Input
		.DIPB(1'b0),              // 1-bit Parity
        .ENA(1'b1),               // Port A RAM Enable Input
        .ENB(1'b1),               // Port B RAM Enable Input
        .SSRA(1'b0),              // Port A Synchronous Set/Reset Input
        .SSRB(1'b0),              // Port B Synchronous Set/Reset Input
        .WEA(1'b0),               // Port A Write Enable Input
        .WEB(bgptbwe)             // Port B Write Enable Input
    );

	//Background attribute table wires.
	wire [7:0]bgatdout;
	wire [7:0]bgataddra;
	wire [7:0]bgataddrb;
	wire [7:0]bgatdin;
	wire bgatwe;	
	 
	assign bgatdin = data;
	assign bgataddrb = id - 16'hA500;
	assign bgatwe = (id >= 16'hA500 && id <= 16'hA5FF) ? write : 1'b0;
	 
	RAMB16_S9_S9 #(
        .INIT_00(256'hAA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA),
        .INIT_01(256'hAA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA),
        .INIT_02(256'hAA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA),
        .INIT_03(256'hFF_FF_FF_FF_FF_FF_FF_FF_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA),
        .INIT_04(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_05(256'h56_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_56_55_55_55_55_55_55_55),
        .INIT_06(256'hAA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55_55),
	    .INIT_07(256'hAA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA_AA))
	BGAttributeTableRAM (
        .DOA(bgatdout),            // Port B 8-bit Data Output
        .ADDRA({3'h0, bgataddra}), // Port A 11-bit Address Input
        .ADDRB({3'h0, bgataddrb}), // Port B 11-bit Address Input
        .CLKA(clk),                // Port A Clock
        .CLKB(clk),                // Port B Clock
        .DIB(bgatdin),             // Port A 8-bit Data Input
		.DIPB(1'b0),               // 1-bit Parity
        .ENA(1'b1),                // Port A RAM Enable Input
        .ENB(1'b1),                // Port B RAM Enable Input
        .SSRA(1'b0),               // Port A Synchronous Set/Reset Input
        .SSRB(1'b0),               // Port B Synchronous Set/Reset Input
        .WEA(1'b0),                // Port A Write Enable Input
        .WEB(bgatwe)               // Port B Write Enable Input
    );
	 
	//Sprite RAM wires.
	wire spwe;
	wire [9:0]spaddra;
    wire [7:0]spdin;
    wire [7:0]spaddrb;
    wire [31:0]spdout;
	 
	assign spwe = (id >= 16'hB000 && id <= 16'hB3FF) ? write : 1'b0;
    assign spaddra = id - 16'hB000;
	assign spdin = data;
	assign spaddrb = (currsprite) ? currsprite - 1'b1 : 8'h00;
	 
	BRAM_TDP_MACRO #(
        .BRAM_SIZE("36Kb"), // Target BRAM: "18Kb" or "36Kb"      
        .READ_WIDTH_A (8),  // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
        .READ_WIDTH_B (32), // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb") 
        .WRITE_WIDTH_A(8),  // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
        .WRITE_WIDTH_B(32), // Valid values are 1-36 (19-36 only valid when BRAM_SIZE="36Kb")
        .INIT_00(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_01(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_02(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_03(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_04(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_05(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_06(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_07(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        
        .INIT_08(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_09(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_0A(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_0B(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_0C(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_0D(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_0E(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_0F(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        
        .INIT_10(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_11(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_12(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_13(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_14(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_15(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_16(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_17(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
                        
        .INIT_18(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_19(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_1A(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_1B(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_1C(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_1D(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_1E(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF),
        .INIT_1F(256'h00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF__00_00_00_FF)
    ) SpriteRAM (
        .DOB(spdout),               // Port B 32-bit Data Output
        .ADDRA({2'b00, spaddra}),   // Port A 12-bit Address Input
        .ADDRB({2'b00, spaddrb}),   // Port B 10-bit Address Input
        .CLKA(clk),                 // Port A Clock
        .CLKB(clk),                 // Port B Clock
        .DIA(spdin),                // Port A 8-bit Data Input
        .DIB(32'h00000000),         // Port B 32-bit Data Input
        .ENA(1'b1),                 // Port A RAM Enable Input
        .ENB(1'b1),                 // Port B RAM Enable Input
        .RSTA(1'b0),                // 1-bit input port-A reset
        .RSTB(1'b0),                // 1-bit input port-B reset
        .WEA(spwe),                 // Port A Write Enable Input
        .WEB(1'b0)                  // Port B Write Enable Input
    );
	 
	 wire awe;
	 wire [10:0]aaddra;
	 wire [7:0]adin;
	 wire [10:0]aaddrb;
	 wire [7:0]adout;
	 
	 assign awe = (id >= 16'h9000 && id <= 16'h97FF) ? write : 1'b0;
	 assign aaddra = id - 16'h9000;
	 assign adin = data;
   
	 RAMB16_S9_S9 #(
        .INIT_00(256'hD0_70_F8_F8_F8_F0_E0_80_3E_0F_06_25_16_1F_0F_03_E0_30_F0_F0_E0_C0_00_00_1D_0D_4B_2D_3F_1F_07_00),
        .INIT_01(256'h30_70_7C_FE_ED_ED_F6_F6_E0_E0_F0_F0_F0_E0_C0_00_7D_1F_0D_4B_2D_3F_1F_07_00_3C_7E_7E_7E_7E_3C_00),
        .INIT_02(256'h04_64_00_12_00_09_27_00_6E_38_08_48_A0_D0_E0_80_76_1C_10_12_05_0B_07_01_00_00_00_60_E0_C0_80_00),
        .INIT_03(256'hEC_CC_9C_98_B8_F0_E0_C0_5C_B0_60_A4_68_F8_F0_C0_0F_0F_1F_1F_1F_0F_07_01_04_28_00_48_20_50_60_84),
        .INIT_04(256'hE0_E0_F8_FE_FF_FF_FB_BE_01_03_33_1D_0E_06_0B_1D_C0_E0_F8_F8_38_F0_E0_40_13_0B_0B_1D_0D_15_3A_7B),
        .INIT_05(256'h00_00_00_00_20_00_00_20_E0_E0_F0_F8_FC_F6_EE_F8_33_7B_FD_FE_EF_67_11_3F_BD_18_18_18_00_3C_18_18),
        .INIT_06(256'h01_00_C0_11_70_2C_D8_0A_EF_93_63_F2_FE_FC_BF_5F_09_91_C6_4F_7F_3F_FD_FA_68_FC_AE_F7_DA_77_3F_0C),
        .INIT_07(256'hFF_FF_FE_FE_FE_F6_F6_EE_9A_3E_FC_E0_F8_FC_FE_BE_07_07_0F_0E_1E_1D_1D_1E_04_00_20_10_6E_E8_93_50),
        .INIT_08(256'h3C_70_60_E0_E0_F0_F0_F0_1D_03_1F_1E_38_77_7F_3F_F8_E0_E0_E0_F0_F0_F0_E0_01_00_01_01_00_00_01_01),
        .INIT_09(256'h00_18_B8_B0_B0_C0_C0_00_1C_3F_3F_77_E3_F1_F1_F0_1C_0E_0E_07_07_03_01_01_00_00_00_00_18_BD_FF_99),
        .INIT_0A(256'h70_98_C0_08_58_62_38_20_18_38_30_30_7C_66_F6_FF_18_1C_0C_0C_02_00_01_01_7F_FF_FF_3F_FF_FF_FF_40),
        .INIT_0B(256'hFF_FF_FF_FF_FF_FF_FF_FF_F0_38_38_70_F0_E0_C0_80_07_07_07_07_07_0F_0F_0F_0E_05_4B_10_12_06_04_00),
        .INIT_0C(256'h03_01_00_01_02_07_1F_3F_00_00_00_00_00_00_78_3C_7A_37_0F_1F_3E_3F_7B_FE_00_00_08_3C_38_3C_08_00),
        .INIT_0D(256'h00_00_18_3C_3C_34_18_00_00_80_C0_C0_80_00_00_18_3E_1E_09_07_07_07_0E_1C_80_C0_C0_C0_C0_00_C0_80),
        .INIT_0E(256'h00_3D_1D_0B_07_07_07_07_00_00_66_66_66_00_00_00_70_F8_F0_08_78_38_38_38_FF_FF_FF_FF_FF_FF_FF_00),
        .INIT_0F(256'h81_80_A7_A3_A3_91_60_1F_74_A0_A4_80_20_40_00_00_01_07_23_AA_DD_6A_A1_48_3C_1C_83_8F_9F_3E_F8_F0),
        .INIT_10(256'hCC_DE_BE_7C_F0_E0_88_FC_07_07_07_07_1F_37_37_1F_E0_80_C0_F0_60_A8_5C_DE_07_0F_1F_1F_1C_0F_07_02),
        .INIT_11(256'h03_05_0D_0E_3E_36_7A_7D_00_00_00_00_02_00_00_02_80_80_38_1C_1C_38_D0_B8_07_07_18_7C_FC_F8_C7_7D),
        .INIT_12(256'h00_00_00_00_40_00_00_40_C0_E0_D0_B0_FC_7C_BE_FE_07_07_0F_1F_3E_3F_1F_0F_E0_F0_F8_FC_DE_EE_FC_F0),
        .INIT_13(256'hFF_93_9F_95_93_93_83_81_14_2D_16_3A_1D_4A_5C_A8_0F_17_1A_1C_1C_38_38_38_3C_66_C3_99_99_C3_66_3C),
        .INIT_14(256'h78_F0_E0_E0_C0_C0_00_00_5F_74_77_3F_3F_1F_07_00_FC_F8_F8_F0_C0_00_00_00_33_1B_1F_0F_03_00_00_00),
        .INIT_15(256'h14_3E_7C_5E_7C_7E_3F_14_A0_C0_E0_E0_40_00_00_00_7B_BD_DE_EF_FF_FF_FE_F8_FB_FC_7F_7F_1F_07_03_00),
        .INIT_16(256'h00_00_00_00_00_00_00_00_3F_1F_0F_1F_3F_7B_71_20_00_17_14_54_57_B4_17_00_00_49_49_49_49_49_E9_00),
        .INIT_17(256'hE0_40_60_F0_F0_60_40_E0_01_00_11_77_77_11_00_01_00_00_00_00_00_00_00_00_3C_66_C3_81_81_C3_66_3C),
        .INIT_18(256'hFE_DE_7E_FE_FC_7C_FC_78_3D_3F_1F_78_7C_7E_3F_1F_C0_70_F8_F8_FC_FC_FC_FC_03_0F_1F_1F_3F_3F_3F_37),
        .INIT_19(256'h00_00_00_00_00_00_40_20_00_00_00_00_20_60_60_60_00_C0_D8_F8_BC_BE_AF_B7_00_00_11_3B_7F_7F_F7_F7),
        .INIT_1A(256'hC0_80_80_00_00_00_00_00_00_08_18_30_F0_60_C0_80_18_00_00_48_00_00_00_00_1C_3E_7F_7F_7F_7F_3E_1C),
        .INIT_1B(256'hFF_01_7D_7D_7D_7D_7D_01_FF_01_41_41_41_41_7D_01_00_00_00_00_00_00_00_00_F0_F0_F0_E0_E0_E0_C0_C0),
        .INIT_1C(256'hD0_B8_78_F0_F8_DC_BE_7E_07_03_00_01_01_07_1F_3F_3C_7E_F3_C1_C1_F3_7E_3C_3C_7E_F3_C1_C1_F3_7E_3C),
        .INIT_1D(256'h07_07_0F_0F_0F_1F_1F_1F_FE_FE_C0_FC_FC_C0_FE_FE_20_30_98_36_4A_35_48_02_0A_09_05_01_00_00_00_00),
        .INIT_1E(256'h05_05_05_06_07_07_07_06_A0_F0_F0_F0_F0_E0_E0_E0_3B_7B_7B_79_3D_3F_1F_07_80_C0_C0_A0_60_60_60_C0),
        .INIT_1F(256'hC6_CE_DE_FE_FE_F6_E6_C6_FC_FC_FC_F8_F8_F0_C0_00_3F_3F_3F_1F_1F_0F_03_00_FC_C0_FE_E0_7F_80_F0_00),
        .INIT_20(256'h98_68_F0_E0_C0_00_01_02_1F_1F_0E_05_03_00_80_40_C0_C0_E0_F0_F8_3C_06_03_07_2F_07_13_00_00_00_00),
        .INIT_21(256'h10_30_E0_C0_00_00_00_00_0C_0F_07_03_10_08_00_00_17_37_37_17_17_F5_F6_F4_E8_E8_E8_E8_E8_AF_61_2F),
        .INIT_22(256'h00_FC_7E_1E_0C_01_05_05_3C_7E_E7_DB_DB_E7_7E_3C_38_7C_FE_FE_FE_FE_7C_38_BB_7E_26_A2_7A_1A_07_07),
        .INIT_23(256'h7E_FF_FF_FF_FF_FF_FF_7E_00_00_C0_30_98_E8_FC_FC_00_00_03_0E_1F_1F_3F_3F_00_70_F0_70_A0_40_F8_80),
        .INIT_24(256'h02_01_00_C0_E0_F0_68_98_40_80_00_03_05_0E_1F_1F_00_00_00_00_C0_E0_F0_E0_C0_70_3C_1F_0F_07_03_01),
        .INIT_25(256'hF8_FE_00_00_C0_E0_30_10_1F_7F_00_00_03_07_0F_0C_00_24_24_24_00_F4_F6_17_00_24_24_24_00_2F_6F_E8),
        .INIT_26(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_74_48_61_F5_B6_60_F8_84_1A_7C_BB_9F_4F_02_79_15),
        .INIT_27(256'hE0_58_AC_58_F0_20_00_00_07_1D_2A_55_6B_D4_A8_D9_00_00_00_00_00_00_00_00_A8_D8_AC_58_70_20_00_00),
        .INIT_28(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_C0_C0_00_00_00),
        .INIT_29(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2A(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2B(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2C(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2E(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_30(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_31(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_32(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_33(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_34(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_35(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_36(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_37(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_38(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_39(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3A(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3B(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3C(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3E(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00))
	 aRAM (
        .DOB(adout),              // Port B 8-bit Data Output
        .ADDRA(aaddra),           // Port A 11-bit Address Input
        .ADDRB(aaddrb),           // Port B 11-bit Address Input
        .CLKA(clk),               // Port A Clock
        .CLKB(clk),               // Port B Clock
        .DIA(adin),               // Port A 8-bit Data Input
		.DIPA(1'b0),              // 1-bit Parity
        .ENA(1'b1),               // Port A RAM Enable Input
        .ENB(1'b1),               // Port B RAM Enable Input
        .SSRA(1'b0),              // Port A Synchronous Set/Reset Input
        .SSRB(1'b0),              // Port B Synchronous Set/Reset Input
        .WEA(awe),                // Port A Write Enable Input
        .WEB(1'b0)                // Port B Write Enable Input	 
	 );

	 wire bwe;
	 wire [10:0]baddra;
	 wire [7:0]bdin;
	 wire [10:0]baddrb;
	 wire [7:0]bdout;
	 
	 assign bwe = (id >= 16'h9800 && id <= 16'h9FFF) ? write : 1'b0;
	 assign baddra = id - 16'h9800;
	 assign bdin = data;
	 
	 RAMB16_S9_S9 #(
        .INIT_00(256'hF8_70_00_00_10_20_00_00_00_20_31_32_19_00_00_00_C0_00_00_20_40_00_00_00_41_62_64_32_00_00_00_00),
        .INIT_01(256'h00_70_58_D8_EA_E2_F1_F0_E0_00_00_00_20_40_00_00_01_40_62_64_32_00_00_00_3C_42_A1_95_8D_9D_42_3C),
        .INIT_02(256'h00_60_09_8E_0A_04_01_00_0E_80_D0_F0_70_20_00_00_70_01_0B_0F_0E_04_01_00_00_00_00_00_00_00_00_00),
        .INIT_03(256'h10_30_60_60_40_00_00_00_C0_84_8C_4C_98_00_00_00_0F_07_00_00_08_04_00_00_04_00_50_F0_30_20_00_04),
        .INIT_04(256'hE0_E0_E0_C2_C3_C7_FC_FE_00_03_37_73_F1_F1_94_61_20_30_30_60_F8_F0_E0_E0_3A_54_54_32_03_0B_07_03),
        .INIT_05(256'h00_00_00_00_7C_FC_F8_78_E0_E0_F0_F8_FC_F0_EC_F8_03_43_6D_7E_2F_07_0B_07_91_00_00_18_00_24_00_18),
        .INIT_06(256'h01_08_40_00_60_64_D8_08_E7_F3_90_0A_86_4E_5F_3F_3D_FB_09_50_64_72_FA_FC_08_10_24_15_1A_06_00_00),
        .INIT_07(256'h00_00_00_00_00_08_08_10_80_F0_20_00_63_CF_FF_EF_07_07_0F_0F_1F_1D_1F_1F_00_80_08_00_06_48_03_10),
        .INIT_08(256'h2C_70_60_E0_E0_F0_F0_F0_02_0C_00_0C_38_77_6F_1F_40_E0_E0_E0_F0_F0_F0_E0_00_00_00_00_00_00_01_01),
        .INIT_09(256'h00_00_00_40_40_20_00_00_0C_36_36_77_E0_F0_F0_F0_00_0E_0E_07_07_03_01_01_00_00_00_00_10_91_F7_B5),
        .INIT_0A(256'h00_00_08_10_00_00_08_20_08_30_30_30_70_60_E0_E1_10_0C_0C_0C_0E_12_29_5F_00_00_00_26_26_00_00_3F),
        .INIT_0B(256'h00_00_00_00_00_00_00_00_70_30_20_70_F0_E0_C0_80_06_07_07_07_07_0F_0F_0F_00_00_10_06_00_00_00_00),
        .INIT_0C(256'h00_00_00_00_01_00_0E_0E_00_00_00_00_00_00_00_00_04_08_10_06_0E_3C_7C_F0_00_00_10_28_04_28_10_00),
        .INIT_0D(256'h00_00_00_24_14_18_00_00_00_00_00_00_00_00_00_00_00_01_06_00_03_07_0E_0C_00_00_00_00_00_C0_00_00),
        .INIT_0E(256'h00_02_02_04_01_03_07_06_00_00_00_66_66_00_00_00_00_00_08_70_10_38_38_38_00_00_00_66_66_00_00_FF),
        .INIT_0F(256'h01_00_25_21_20_11_00_00_E0_00_24_80_00_40_00_00_03_93_17_EE_50_4A_00_40_00_02_0C_00_04_3C_78_30),
        .INIT_10(256'hC4_DA_BA_7C_F0_E0_D0_E0_07_07_07_07_1F_3F_3F_1F_98_04_3C_88_60_D0_E0_C0_07_0F_0F_07_1C_0F_07_07),
        .INIT_11(256'h03_02_02_01_F1_E9_C5_83_00_00_00_00_07_0F_0F_07_00_C0_F8_3C_FC_F8_80_80_07_07_1F_7E_FF_FF_27_7F),
        .INIT_12(256'h00_00_00_00_E0_F0_F0_E0_C0_E0_E0_C0_DC_FF_FF_F3_07_07_0F_1F_1F_1F_1F_0F_00_00_18_3C_DC_F0_FC_F0),
        .INIT_13(256'h00_11_1F_17_11_11_00_00_30_25_52_38_91_68_C8_E0_00_08_04_08_1C_38_38_38_00_00_18_3C_3C_18_00_00),
        .INIT_14(256'hF8_F0_E0_00_00_00_00_00_27_0F_0B_00_10_08_00_00_BC_38_F8_F0_C0_00_00_00_0F_07_03_01_03_00_00_00),
        .INIT_15(256'h00_1A_04_16_14_0A_19_00_40_20_00_00_00_00_00_00_7E_FF_FF_FF_FF_FF_FE_F8_1F_9E_5F_1F_0F_07_03_00),
        .INIT_16(256'h00_00_00_00_00_00_00_00_00_0E_06_0E_1A_30_20_00_00_17_14_54_57_B4_17_00_00_49_49_49_49_49_E9_00),
        .INIT_17(256'hE0_40_C0_00_F0_C0_40_E0_01_00_10_44_45_10_00_01_00_00_00_00_00_00_00_00_24_42_99_3C_3C_99_42_24),
        .INIT_18(256'hFE_FE_FE_FE_FC_7C_FC_F8_1F_0B_07_1B_3D_7E_7F_6F_00_90_78_F8_FC_FC_7C_FC_00_0B_1F_07_23_36_1E_0F),
        .INIT_19(256'h3C_7E_C3_DF_DF_DF_7E_3C_00_00_00_00_00_00_00_80_00_00_80_C8_9C_AE_BE_FE_00_00_0D_07_03_07_07_1F),
        .INIT_1A(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_80_00_00_78_78_78_78_78_30_00_00_00_00_00_00_00_20_10_00),
        .INIT_1B(256'h00_FE_FE_FE_FE_FE_FE_FE_00_FE_82_82_82_82_82_FE_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_1C(256'h20_40_80_00_D8_FC_FE_FE_00_00_00_00_01_07_1F_3F_00_20_00_0C_0C_00_20_00_00_20_00_00_00_00_20_00),
        .INIT_1D(256'h07_07_0F_0F_0F_1F_1F_1F_00_FE_C0_C0_FC_C0_C0_FE_40_30_50_22_38_1E_04_00_19_04_16_05_0A_00_00_00),
        .INIT_1E(256'h01_01_01_00_00_00_00_00_C0_C0_C0_A0_00_80_E0_E0_1F_0F_2F_27_03_00_01_01_80_C0_C0_C0_80_80_80_80),
        .INIT_1F(256'h00_C6_CE_DE_FE_F6_E6_C6_FC_FC_FC_F8_F8_70_C0_00_2F_2F_33_11_19_0E_03_00_FC_E0_FE_F0_7F_00_00_00),
        .INIT_20(256'h00_00_08_04_02_11_09_06_08_0C_14_21_44_88_90_60_9C_9C_C8_E0_30_C8_04_02_7B_77_3B_3C_1F_07_00_00),
        .INIT_21(256'hC2_02_02_02_02_04_04_F8_40_40_42_40_50_28_20_1F_E7_07_C7_07_E7_07_06_04_E7_E4_E7_E4_E7_E0_6E_20),
        .INIT_22(256'hFC_02_00_00_00_01_01_01_00_00_00_18_18_00_00_00_38_7C_FE_FE_FE_BE_5C_38_00_00_00_00_08_00_00_00),
        .INIT_23(256'h24_66_E7_18_18_E7_66_24_00_00_C0_30_98_E8_FC_FC_00_00_03_0E_1F_1F_3F_3F_F0_80_00_00_80_40_F8_C0),
        .INIT_24(256'h06_09_11_22_04_08_00_00_60_90_88_44_20_00_00_00_00_C0_F0_38_18_CC_E4_C4_40_23_10_2C_37_7B_7D_7F),
        .INIT_25(256'hF8_FE_82_02_02_02_02_C2_1F_7F_41_40_40_42_40_40_FE_00_24_24_00_04_06_07_7F_00_24_24_00_20_60_E0),
        .INIT_26(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_80_00_00_00_00_00_20_00_08_02_00_00),
        .INIT_27(256'h40_08_04_08_50_20_80_C0_05_08_00_00_41_80_01_8A_C0_80_00_00_00_00_00_00_03_89_04_08_50_20_00_00),
        .INIT_28(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_C0_C0_00_00_00),
        .INIT_29(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2A(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2B(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2C(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2E(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_2F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_30(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_31(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_32(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_33(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_34(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_35(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_36(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_37(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_38(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_39(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3A(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3B(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3C(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3D(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3E(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00),
        .INIT_3F(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00))
    bRAM (
        .DOB(bdout),              // Port B 8-bit Data Output
        .ADDRA(baddra),           // Port A 11-bit Address Input
        .ADDRB(baddrb),           // Port B 11-bit Address Input
        .CLKA(clk),               // Port A Clock
        .CLKB(clk),               // Port B Clock
        .DIA(bdin),               // Port A 8-bit Data Input
		  .DIPA(1'b0),            // 1-bit Parity
        .ENA(1'b1),               // Port A RAM Enable Input
        .ENB(1'b1),               // Port B RAM Enable Input
        .SSRA(1'b0),              // Port A Synchronous Set/Reset Input
        .SSRB(1'b0),              // Port B Synchronous Set/Reset Input
        .WEA(bwe),                // Port A Write Enable Input
        .WEB(1'b0)                // Port B Write Enable Input	 
    );	 

//////////////////////////////////////////Display Buffer///////////////////////////////////////////	 
    assign nxt256pix  = next256pixel[9:1];
    assign cur256line =	currline ? ((currline + 1'b1) / 2) : 8'h00;
	 assign nxt256line = (vcount > 31 && vcount < 512) ? cur256line + 1'b1 : 8'h00;
	 
	 //No color out if not in drawing area.
	 assign lbrstb = (cur256line && nxt256pix) ? 1'b0 : 1'b1;
	 
	 //Select between odd line buffer and even line buffer
	 assign lbaddrb[8] = (cur256line % 2 == 1) ? 1'b0 : 1'b1;
	 assign lbaddrb[7:0] = nxt256pix - 1'b1;


//////////////////////////////////////////Buffer Fill FSM//////////////////////////////////////////	 
    wire leavewait;
    wire [1:0]bgatbits;
    wire bgptabit;
    wire bgptbbit;
    reg  [4:0]State = 3'b000;
    reg  [4:0]NextState = 3'b000;
    reg  [8:0]pix256draw = 9'h000;
 
    //Sprite registers and wires.
    wire spriteinrange;
    wire [7:0]spritex;
    wire [7:0]spritey;
    wire [7:0]spriteptrn;
    wire [1:0]upal;
    wire hmirror;
    wire vmirror;
    wire back;
    wire [2:0]invert;
    wire [2:0]normal;
    wire [10:0]address;
    reg  spbita = 1'b0;
    reg  spbitb = 1'b0;	 
    reg  [7:0]bfaddr = 8'h00;
    reg  bs = 1'b0;
    reg  [7:0]pix = 8'h00;
	 
    always @(State, leavewait, pix256draw, currsprite, spriteinrange, back) begin
	    case(State)
		    WAIT : NextState = leavewait ? NTAT : WAIT;
			NTAT : NextState = PTAB;
			PTAB : NextState = BUFF;
			BUFF : NextState = (pix256draw && (pix256draw < 256)) ? NTAT : NEXT;
			NEXT : NextState = SPRAM;
			SPRAM: NextState = spriteinrange ? SAB :
			                   (currsprite == 256 && !spriteinrange) ? WAIT :
			                    NEXT;
			SAB  : NextState = back ? WRIT0 : BUFF0;
			WRIT0: NextState = WRIT1;
			WRIT1: NextState = WRIT2;
			WRIT2: NextState = WRIT3;
			WRIT3: NextState = WRIT4;
			WRIT4: NextState = WRIT5;
			WRIT5: NextState = WRIT6;
			WRIT6: NextState = WRIT7;
			WRIT7: NextState = BUFF0;
			BUFF0: NextState = BUFF1;				
			BUFF1: NextState = BUFF2;				
			BUFF2: NextState = BUFF3;				
			BUFF3: NextState = BUFF4;				
			BUFF4: NextState = BUFF5;				
			BUFF5: NextState = BUFF6;				
			BUFF6: NextState = BUFF7;				
			BUFF7: NextState = (currsprite == 256) ? WAIT : NEXT;
			default : NextState = WAIT;
        endcase
    end
	 
	 always @(posedge clk) begin
        if(!nxt256line) 
		      State <= WAIT;
		  else
		      State <= NextState;
				
	     if(NextState == WAIT) begin
            lbwe = 1'b0;		  
		      pix256draw <= 9'h000;
            currsprite = 9'h000;
            bfaddr = 8'h00;
            bs <= 1'b0;				
		  end
		  
	     if(NextState == NTAT) begin	
            lbwe = 1'b0;		  
				pix256draw <= pix256draw + 1;				
		  end
		  
        if(NextState == PTAB) begin
		      lbwe = 1'b0;
        end
		  
		  if(NextState == BUFF) begin
		      lbwe = 1'b1;
        end
		  
		  if(NextState == NEXT) begin
		      lbwe = 1'b0;
				pix <= 8'h00;
				pix256draw <= 9'h000;
				currsprite = currsprite + 1;
				bfaddr = 8'h00;
				bs <= 1'b1;
		  end
		  
		  if(NextState == SAB) begin
		      bfaddr = hmirror ? spritex + 7 : spritex;
		  end

        if(NextState == WRIT0) begin
            bfaddr = hmirror ? spritex + 6 : spritex + 1;				
        end

        if(NextState == WRIT1) begin
            bfaddr = hmirror ? spritex + 5 : spritex + 2;
				if(lbcheck)
				    pix[0] <= 1'b1;
        end

        if(NextState == WRIT2) begin
            bfaddr = hmirror ? spritex + 4 : spritex + 3;
				if(lbcheck)
				    pix[1] <= 1'b1;
        end

        if(NextState == WRIT3) begin
            bfaddr = hmirror ? spritex + 3 : spritex + 4;
				if(lbcheck)
				    pix[2] <= 1'b1;
        end

        if(NextState == WRIT4) begin
            bfaddr = hmirror ? spritex + 2 : spritex + 5;
				if(lbcheck)
				    pix[3] <= 1'b1;
        end

        if(NextState == WRIT5) begin
            bfaddr = hmirror ? spritex + 1 : spritex + 6;
				if(lbcheck)
				    pix[4] <= 1'b1;
        end

        if(NextState == WRIT6) begin
            bfaddr = hmirror ? spritex     : spritex + 7;
				if(lbcheck)
				    pix[5] <= 1'b1;
        end

        if(NextState == WRIT7) begin		      
				if(lbcheck)
				    pix[6] <= 1'b1;
        end		  
		  
		  if(NextState == BUFF0) begin
		      if((!adout[7] && !bdout[7]) || (back && pix[0]))
				    lbwe = 1'b0;
				else
		          lbwe = 1'b1;
				if(lbcheck)
				    pix[7] <= 1'b1;
				bfaddr = hmirror ? spritex + 7 : spritex;
            spbita = adout[7];
				spbitb = bdout[7];				
		  end
		  
		  if(NextState == BUFF1) begin
		      if((!adout[6] && !bdout[6]) || (back && pix[1]))
				    lbwe = 1'b0;
				else
		          lbwe = 1'b1;
				bfaddr = hmirror ? spritex + 6 : spritex + 1;
				spbita = adout[6];
				spbitb = bdout[6];
		  end
		  
		  if(NextState == BUFF2) begin
		      if((!adout[5] && !bdout[5]) || (back && pix[2]))
				    lbwe = 1'b0;
				else
		          lbwe = 1'b1;
				bfaddr = hmirror ? spritex + 5 : spritex + 2;
				spbita = adout[5];
				spbitb = bdout[5];
		  end
		  
		  if(NextState == BUFF3) begin
		      if((!adout[4] && !bdout[4]) || (back && pix[3]))
				    lbwe = 1'b0;
				else
		          lbwe = 1'b1;
				bfaddr = hmirror ? spritex + 4 : spritex + 3;
				spbita = adout[4];
				spbitb = bdout[4];
		  end		  
		  
		  if(NextState == BUFF4) begin
		      if((!adout[3] && !bdout[3]) || (back && pix[4]))
				    lbwe = 1'b0;
				else
		          lbwe = 1'b1;
				bfaddr = hmirror ? spritex + 3 : spritex + 4;
				spbita = adout[3];
				spbitb = bdout[3];
		  end
		  
		  if(NextState == BUFF5) begin
		      if((!adout[2] && !bdout[2]) || (back && pix[5]))
				    lbwe = 1'b0;
				else
		          lbwe = 1'b1;
				bfaddr = hmirror ? spritex + 2 : spritex + 5;
				spbita = adout[2];
				spbitb = bdout[2];
		  end
		 
		  if(NextState == BUFF6) begin
		      if((!adout[1] && !bdout[1]) || (back && pix[6]))
				    lbwe = 1'b0;
				else
		          lbwe = 1'b1;
				bfaddr = hmirror ? spritex + 1 : spritex + 6;
			   spbita = adout[1];
				spbitb = bdout[1];
		  end
		  
		  if(NextState == BUFF7) begin
		      if((!adout[0] && !bdout[0]) || (back && pix[7]))
				    lbwe = 1'b0;
				else
		          lbwe = 1'b1;
				bfaddr = hmirror ? spritex     : spritex + 7;
				spbita = adout[0];
				spbitb = bdout[0];
		  end
	 end
	 
	 //Determine when it is time to go from WAIT to NTAT.
	 assign leavewait = (nxt256line && (vcount % 2 == 1'b0) && hcount < 10'h002) ? 1'b1 : 1'b0;
	 //Name table address.
	 assign ntaddra   = nxt256line ? (32 * ((nxt256line - 1) / 8) + ((pix256draw - 1) / 8)) : 10'h000;
	 //Attribute table address.
	 assign bgataddra = nxt256line ? (8  * ((nxt256line - 1) / 8) + ((pix256draw - 1) / 32)) : 10'h000;
	 //Pattern table addresses.
	 assign bgptaaddra = pix256draw ? (8 * ntdout + (nxt256line - 1) % 8) :10'h000;
	 assign bgptbaddra = pix256draw ? (8 * ntdout + (nxt256line - 1) % 8) :10'h000;
	 //Attribute table bits for palette MUX.
	 assign bgatbits = (ntaddra % 4 == 2'b00) ? bgatdout[7:6] :
	                   (ntaddra % 4 == 2'b01) ? bgatdout[5:4] :
					   (ntaddra % 4 == 2'b10) ? bgatdout[3:2] :
						bgatdout[1:0];
	 //Pattern table B bit for palette MUX.						 
	 assign bgptbbit = bgptbdout[~(pix256draw - 1) % 8];
	 //Pattern table A bit for palette MUX.
	 assign bgptabit = bgptadout[~(pix256draw - 1) % 8];
    //Break down the sprite data into its separate parts.	 
	 assign spritex       = spdout[31:24];
	 assign spritey       = spdout[7:0];
	 assign spriteptrn    = spdout[15:8];
	 assign spriteinrange = (currsprite && (nxt256line - 1'b1 >= spritey) && 
	                         nxt256line - 1'b1 - spritey < 8) ? 1'b1 : 1'b0;
	 assign upal          = spdout[17:16];
	 assign hmirror       = spdout[22];
	 assign vmirror       = spdout[23];
	 assign back          = spdout[21];
    //Get sprite graphic info with or without vertical mirroring.
	 assign invert  = ~(nxt256line - 1'b1 - spritey);
	 assign normal  = (nxt256line - 1'b1 - spritey);
	 assign address = spriteptrn * 8;	 
	 assign aaddrb  = address + (vmirror ? invert : normal);
	 assign baddrb  = aaddrb;	 
	 //Palette MUX
	 assign lbdin = ({bs, bgatbits, bgptbbit, bgptabit} == 5'h00) ? bgpal0  :
	                ({bs, bgatbits, bgptbbit, bgptabit} == 5'h01) ? bgpal1  :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h02) ? bgpal2  :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h03) ? bgpal3  :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h04) ? bgpal4  :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h05) ? bgpal5  :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h06) ? bgpal6  :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h07) ? bgpal7  :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h08) ? bgpal8  :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h09) ? bgpal9  :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h0A) ? bgpal10 :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h0B) ? bgpal11 :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h0C) ? bgpal12 :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h0D) ? bgpal13 :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h0E) ? bgpal14 :
						 ({bs, bgatbits, bgptbbit, bgptabit} == 5'h0F) ? bgpal15 :
                   ({bs, upal    , spbitb  , spbita  } == 5'h10) ? sppal0  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h11) ? sppal1  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h12) ? sppal2  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h13) ? sppal3  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h14) ? sppal4  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h15) ? sppal5  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h16) ? sppal6  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h17) ? sppal7  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h18) ? sppal8  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h19) ? sppal9  :
						 ({bs, upal    , spbitb  , spbita  } == 5'h1A) ? sppal10 :
						 ({bs, upal    , spbitb  , spbita  } == 5'h1B) ? sppal11 :
						 ({bs, upal    , spbitb  , spbita  } == 5'h1C) ? sppal12 :
						 ({bs, upal    , spbitb  , spbita  } == 5'h1D) ? sppal13 :
						 ({bs, upal    , spbitb  , spbita  } == 5'h1E) ? sppal14 :
						 sppal15;
			 
	 //Write to odd or even line buffer.
	 assign lbaddra[8] = ~lbaddrb[8];
	 //Line buffer address.
	 assign lbaddra[7:0] = bs ? bfaddr : pix256draw - 1'b1;
	 //Determine final pixel color.
	 assign colorout = (hcount < 112 || hcount > 623 || !currline) ? 8'h00 :
	                   !lbdout ? basecolor :                    
	                   lbdout;

////////////////////////////////////////////Base Timing////////////////////////////////////////////
    always @(posedge clk25MHz) begin
	     //Horizontal timing.
	     hcount <= hcount + 1'b1;
		  if(hcount == 704)
		      hsync  <= 1'b0;
		  if(hcount == 800) begin
		      hcount <= 10'h001;
				hsync  <= 1'b1;
				vcount <= vcount + 1'b1;
		  end
		  
		  //Vertical timing.
		  if(vcount == 523)
		      vsync  <= 1'b0;
		  if(vcount == 525) begin
		      vcount <= 10'h001;
				vsync  <= 1'b1;
		  end
		  
		  //Visible pixel counters.
		  if(hcount >= 47 && hcount <= 686)
		      nextpixel  <= nextpixel  + 1;
		  else
		      nextpixel <= 0;
		  if(hcount >= 46 && hcount <= 685)
		      nextpixel2 <= nextpixel2 + 1;
		  else
 		      nextpixel2 <= 0;
		  
		  //Visible line counters.
		  if(vcount >= 33 && hcount == 800)
		      currline <= currline + 1;
		  if(vcount >= 513 && hcount == 800)
            currline <= 0;	  

        //256 resolution pixel counter.
        if(hcount >= 109 && hcount <= 621)
            next256pixel <= next256pixel + 1;
        else
            next256pixel <= 1'b0;
				
        //Vertical blank.
		  if(vcount == 514)
		      vblank <= 1'b1;
		  else 
		      vblank <= 1'b0;
				
        //Draw linebuffer data to screen.
        vga <= colorout;				
	 end
	 
endmodule
