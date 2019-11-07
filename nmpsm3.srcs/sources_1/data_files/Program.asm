.size 1024

;------------------------------------Addressable hardware list-------------------------------------
;0x0000 - 0x0007 ROM controller.
;0x0010          Timer 0.
;0x0011          Timer 1.
;0x0012          Input MUX - ROM data.
;0x0013          Input MUX - Switches.
;0x0020          LED controller.
;0x0024 - 0x0027 Seven segment controller.
;0x0030 - 0x0033 Input MUX - Clock data.
;0x0034          Input MUX - Microphone data.

;-------------------------------------VGA Controller addresses-------------------------------------
;0x8000 - 0x87FF Background pattern table A.
;0x8800 - 0x8FFF Background pattern table B.
;0x9000 - 0x97FF Sprite pattern table A.
;0x9800 - 0x9FFF Sprite pattern table B.
;0xA000 - 0xA3FF Name table.
;0xA400 - 0xA4FF Unused.
;0xA500 - 0xA5FF Background attribute table.
;0xA600 - 0xA60F Background pallettes 0 through 15.
;0xA610 - 0xA61F Sprite pallettes 0 through 15.
;0xA700          Base color (background color).
;0xB000 - 0xB3FF Sprite RAM (256 sprites).

;--------------------------------------Sprite RAM Memory Map---------------------------------------
;0xB000 - 0xb01F Bouncing sprites (8 sprites).
;0xB020 - 0xB05F Rotation sprites (16 sprites).
;0xB0D0 - 0xB0FF Samus sprites (12 sprites).
;0xB100 - 0xB2FF Audio sprites.

;---------------------------------------------Defines----------------------------------------------
;ASCII numbers.
.alias ZERO                 #$30
.alias ONE                  #$31
.alias TWO                  #$32
.alias THREE                #$33
.alias FOUR                 #$34
.alias FIVE                 #$35
.alias SIX                  #$36
.alias SEVEN                #$37
.alias EIGHT                #$38
.alias NINE                 #$39

;ASCII letters.
.alias A                    #$41
.alias B                    #$42
.alias C                    #$43
.alias D                    #$44
.alias E                    #$45
.alias F                    #$46
.alias G                    #$47
.alias H                    #$48
.alias I                    #$49
.alias J                    #$4A
.alias K                    #$4B
.alias L                    #$4C
.alias M                    #$4D
.alias N                    #$4E
.alias O                    #$4F
.alias P                    #$50
.alias Q                    #$51
.alias R                    #$52
.alias S                    #$53
.alias T                    #$54
.alias U                    #$55
.alias V                    #$56
.alias W                    #$57
.alias X                    #$58
.alias Y                    #$59
.alias Z                    #$5A

.alias a                    #$61
.alias b                    #$62
.alias c                    #$63
.alias d                    #$64
.alias e                    #$65
.alias f                    #$66
.alias g                    #$67
.alias h                    #$68
.alias i                    #$69
.alias j                    #$6A
.alias k                    #$6B
.alias l                    #$6C
.alias m                    #$6D
.alias n                    #$6E
.alias o                    #$6F
.alias p                    #$70
.alias q                    #$71
.alias r                    #$72
.alias s                    #$73
.alias t                    #$74
.alias u                    #$75
.alias v                    #$76
.alias w                    #$77
.alias x                    #$78
.alias y                    #$79
.alias z                    #$7A

;ASCII symbols.
.alias SPACE                #$20
.alias COLON                #$3A
.alias COMMA                #$2C
.alias PERIOD               #$2E
.alias CR                   #$0D                    ;Carriage return.
.alias FSLASH               #$2F                    ;Forward slash.
.alias LBAR                 #$5F                    ;Underscore.
.alias MBAR                 #$2D                    ;Minus sign.
.alias UBAR                 #$FF                    ;Upper bar.
.alias STAR                 #$2A                    ;Multiply sign.
.alias OPEN_C_BRACE         #$7B                    ;Open curly brace.

;Output port IDs.
.alias LEDTBL               #$0000                  ;
.alias TIMELOTBL            #$0001                  ;
.alias SEG7INDEXTBL         #$0002                  ;
.alias SEG7TBL              #$0003                  ;
.alias LOOKUPADDR           #$0004                  ;ROM addresses.
.alias MESSAGETBL           #$0005                  ;
.alias PALETTETBL           #$0006                  ;
.alias SPRITETBL            #$0007                  ;
.alias SAMUSTBL             #$0006                  ;

.alias SET_BAUD             #$0200                  ;
.alias TX_STORE_BYTE        #$0201                  ;
.alias TX_FLUSH             #$0202                  ;UART control.
.alias TX_PURGE             #$0203                  ;
.alias RX_NEXT_BYTE         #$0204                  ;
.alias RX_PURGE             #$0205                  ;

.alias DOT0                 #$A288                  ;
.alias DOT1                 #$A294                  ;Name table addresses-->
.alias DOT2                 #$A2E8                  ;for clock dots.
.alias DOT3                 #$A2F4                  ;

.alias LOSEC                #$A29B                  ;
.alias HISEC                #$A296                  ;Starting addresses of-->
.alias LOMIN                #$A28F                  ;clock digits in name-->
.alias HIMIN                #$A28A                  ;table.
.alias LOHOUR               #$A283                  ;

.alias A                    #$A29F                  ;Name table positions-->
.alias B                    #$A2FF                  ;of A and P in clock.

.alias TIMER0               #$0010                  ;Timers
.alias TIMER1               #$0011                  ;

.alias LEDIO                #$0020                  ;LED controller.
.alias LEDIO2               #$0021                  ;Upper LED controller.

.alias SEG0                 #$0024                  ;
.alias SEG1                 #$0025                  ;7 segment display
.alias SEG2                 #$0026                  ;
.alias SEG3                 #$0027                  ;

;Input port IDs.
.alias UARTDATA             #$0003                  ;
.alias TXCOUNT              #$0004                  ;UART ports.
.alias RXCOUNT              #$0005                  ;

.alias ROMDATA              #$0012                  ;ROM data
.alias SWITCHES             #$0013                  ;Switches

.alias SEC                  #$0030                  ;
.alias MIN                  #$0031                  ;Clock data
.alias HOUR                 #$0032                  ;
.alias BLINK                #$0033                  ;

.alias MICDATA              #$0034                  ;Mic data

;RAM aliases.
.alias ledIndex             $0000
.alias timeIndex            $0001
.alias segIndex             $0002
.alias switchReg            $0003
.alias waitReg              $0004

.alias sp0y                 $0010                   ;
.alias sp1y                 $0011                   ;
.alias sp2y                 $0012                   ;
.alias sp3y                 $0013                   ;Bouncing sprite y positions.
.alias sp4y                 $0014                   ;
.alias sp5y                 $0015                   ;
.alias sp6y                 $0016                   ;
.alias sp7y                 $0017                   ;

.alias sp0x                 $0018                   ;
.alias sp1x                 $0019                   ;
.alias sp2x                 $001A                   ;
.alias sp3x                 $001B                   ;Bouncing sprite x positions.
.alias sp4x                 $001C                   ;
.alias sp5x                 $001D                   ;
.alias sp6x                 $001E                   ;
.alias sp7x                 $001F                   ;

.alias sp0m                 $0020                   ;
.alias sp1m                 $0021                   ;
.alias sp2m                 $0022                   ;
.alias sp3m                 $0023                   ;Bouncing sprite move directions.
.alias sp4m                 $0024                   ;
.alias sp5m                 $0025                   ;
.alias sp6m                 $0026                   ;
.alias sp7m                 $0027                   ;

.alias palRegs              $0030                   ;Thru $4F
.alias tempReg0             $0050
.alias tempReg1             $0051
.alias tempReg2             $0052
.alias tempReg3             $0053
.alias colCount             $0054
.alias rowCount             $0055
.alias numIn                $0056
.alias numOffset            $0057
.alias AMPMReg0             $0058
.alias AMPMReg1             $0059
.alias startReg             $005A
.alias stopReg              $005B
.alias mIndexReg            $005C
.alias bcDelReg             $005D
.alias bcReg                $005E
.alias checkReg             $005F
.alias palDelReg            $0060
.alias mirDelReg            $0061
.alias mirPtrReg            $0062
.alias audPtrReg            $0063
.alias audCtrReg            $0064
.alias audHldReg            $0065
.alias miscReg              $0066
.alias atDelReg             $0067
.alias atStatReg            $0068
.alias callReg              $0069
.alias clearReg             $006A
.alias swReg                $006B
.alias anDelReg             $006C
.alias samROMReg            $006D
.alias samXReg              $006E
.alias movDelReg            $006F
.alias samM0Reg             $0090
.alias samM1Reg             $0091
.alias samM2Reg             $0092
.alias micDelReg            $0093
.alias micStaReg            $0094
.alias micSmpReg            $0095
.alias waitStateReg         $0096
.alias audioRegs            $0100                   ;Through $17F(128 total).

.alias uartTxByte           $0180                   ;
.alias uartRxByte           $0181                   ;UART value registers.
.alias uartTxCount          $0182                   ;
.alias uartRxCount          $0183                   ;

.alias bufCurPointer        $0184                   ;Pointer to current position in uart buffer.
.alias bufEndPointer        $0185                   ;Pointer to last position in uart buffer.               
.alias uartBuf              $0186                   ;thru $01A1.

;Constants.
.alias UPRIGHT              #$20
.alias UPLEFT               #$60
.alias DOWNRIGHT            #$A0
.alias DOWNLEFT             #$E0
.alias PALREGS              #$30
.alias AT0                  #$1B
.alias AT1                  #$C6
.alias AT2                  #$B1
.alias AT3                  #$6C

.alias SPRITEREGS           #$0100                  ;Start of sprite audio regs.
.alias ENDAUDIOREGS         #$0180                  ;End of sprite audio regs.
.alias PPUAUDSPSTART        #$B100                  ;Start address of audio sprites in PPU.
.alias PPUAUDSPEND          #$B300                  ;End address of audio sprites in PPU.

;-------------------------------------------Start of code------------------------------------------
    jump Reset                                      ;
    jump Interrupt0                                 ;
    jump Interrupt1                                 ;Reset and interrupt vectors.
    jump Interrupt2                                 ;
    jump Interrupt3                                 ;

Reset:
    call ClearRegs
    call ClearBouncingSprites
    call SetDefaultPalettes
    call InitLEDIndex
    call Init7SegsIndex
    
    load micSmpReg, #$0080  
    load samROMReg, #$40
    load samXReg  , #$E5
    load samM0Reg , #$03
    load samM1Reg , #$03
    load samM2Reg , #$03
    load AMPMReg1 , #$11
    load tempReg0 , #5
    out  tempReg0 , TIMER0
    out  tempReg0 , TIMER1  
    
    load uartTxByte #$D9                            ;Set UART baud rate to 230400.
    out  uartTxByte SET_BAUD                        ;
    
    ein0
    ein1
    ein2

MainLoop:
    comp waitReg  , #1                              ;Check to see if current--> 
    jpz  MainLoop                                   ;frame processing is done.
    din2                                            ;Disable VBlank interrupt.
    
    load waitReg  , #1                              ;Process current frame data.
    add  micDelReg, #1
    comp micDelReg, #3
    clz GetAudioData
    
    ein2                                            ;Enable VBlank interrupt.
    jump MainLoop                                   ;Run main loop forever.
    
;The following function sets all the register values to 0.
ClearRegs:
    load 0 #$3FF                                    ;
    load 1 #0                                       ;
    ClearRegsLoop:                                  ;Start at top register and-->
    stor 1 (0)                                      ;decrement through them setting-->
    sub  0 #1                                       ;them all to 0.
    jpnz ClearRegsLoop                              ;
    ret                                             ;
    
Interrupt0:
    out  timeIndex, TIMELOTBL
    in   tempReg0 , ROMDATA
    or   tempReg0 , #0
    clz  InitLEDIndex
    
    out  timeIndex, TIMELOTBL
    in   tempReg0 , ROMDATA
    out  tempReg0 , TIMER0
    
    out  ledIndex , LEDTBL
    in   tempReg0 , ROMDATA
    out  tempReg0 , LEDIO
    
    add  timeIndex, #1
    add  ledIndex , #1
    rtie
    
InitLEDIndex:
    load ledIndex , #0
    load timeIndex, #0
    ret
    
Interrupt1:
    comp segIndex , #$20
    clz  Init7SegsIndex
    
    load tempReg0 , segIndex
    load tempReg2 , SEG0
    call DoSeg
    
    add  tempReg0 , #1
    load tempReg2 , SEG1
    call DoSeg
    
    add  tempReg0 , #1
    load tempReg2 , SEG2
    call DoSeg
    
    add  tempReg0 , #1
    load tempReg2 , SEG3
    call DoSeg
    
    load tempReg0 , #$B0
    out  tempReg0 , TIMER1
    
    add  segIndex , #1    
    rtie

DoSeg:
    out  tempReg0 , SEG7INDEXTBL
    in   tempReg1 , ROMDATA
    out  tempReg1 , SEG7TBL
    in   tempReg1 , ROMDATA
    out  tempReg1 , tempReg2
    ret
    
Init7SegsIndex:
    load segIndex , #0
    ret
    
Interrupt2:
Interrupt3:
    load waitReg  , #0
    call DoMessage
    call DoClock
    call DoBaseColor
    call DoBouncingSprites
    call DoPaletteChange
    call DoSpriteMirroring
    call DoSpriteAudio
    call DoAttribChange
    call DoSpritePriority
    call DoUART                                     ;Check for waiting data in UART. 
    rtie
    
DoFunction:
    in   switchReg, SWITCHES
    and  switchReg, swReg
    DoSubFunction:
    comp switchReg, swReg
    jpz  RunFunction
    jump ClearFunction
    RunFunction:
    jump (callReg)   
    ClearFunction:
    jump (clearReg)
    DoZeroFunction:
    in   switchReg, SWITCHES
    jump DoSubFunction
    
DoUART:
    call CheckUART                                  ;Get any waiting bytes from UART.
    call EchoByte                                   ;Echo byte back to terminal.
    ret
    
CheckUART:
    in   uartRxByte, UARTDATA                       ;Get UART byte.
    comp uartRxByte, #0                             ;See if it is a valid byte.
    rtz                                             ;If not, return.
    
    out  uartRxByte, LEDIO2                         ;Echo byte to the upper LEDs.
    out  uartRxByte, TX_STORE_BYTE                  ;Echo byte back to terminal.
    out  uartRxByte, RX_NEXT_BYTE                   ;Move to next position.
    jump CheckUART  
    
EchoByte:
    out  tempReg0,   TX_FLUSH                       ;Flush tx output.
    ret                                             ;
    
DoClock:
    load swReg    , #$01
    load callReg  , #LoadClock
    load clearReg , #ClearClock
    jump DoFunction
    
LoadClock:
    in   tempReg0 , BLINK
    or   tempReg0 , #0
    clnz DrawDots
    or   tempReg0 , #0
    clz  ClearDots
    in   tempReg0 , HOUR
    and  tempReg0 , #$00F0
    clnz DrawOne
    and  tempReg0 , #$00F0
    clz  ClearOne
    
    in   tempReg0 , SEC
    call NibbleShift
    load numOffset, LOSEC
    call DisplayDigit
    
    in   tempReg0 , SEC
    and  tempReg0 , #$F0
    load numOffset, HISEC
    call DisplayDigit
    
    in   tempReg0 , MIN
    call NibbleShift
    load numOffset, LOMIN
    call DisplayDigit
    
    in   tempReg0 , MIN
    and  tempReg0 , #$F0
    load numOffset, HIMIN
    call DisplayDigit
    
    in   tempReg0 , HOUR
    call NibbleShift
    load numOffset, LOHOUR
    call DisplayDigit
    
    call AMPM
    load tempReg0 , AMPMReg0
    comp tempReg0 , #0
    clz  AM
    load tempReg0 , AMPMReg0
    comp tempReg0 , #0
    clnz PM            
    ret

DrawDots:
    load tempReg0 , #$6F
    out  tempReg0 , DOT0
    out  tempReg0 , DOT1
    out  tempReg0 , DOT2
    out  tempReg0 , DOT3    
    ret

ClearDots:
    load tempReg0 , #$FF
    out  tempReg0 , DOT0
    out  tempReg0 , DOT1
    out  tempReg0 , DOT2
    out  tempReg0 , DOT3 
    ret

DrawOne:
    load tempReg0 , #$44
    out  tempReg0 , #$A280
    load tempReg0 , #$4D
    out  tempReg0 , #$A281
    load tempReg0 , #$50
    out  tempReg0 , #$A2A0
    load tempReg0 , #$47
    out  tempReg0 , #$A2A1
    out  tempReg0 , #$A2C1
    load tempReg0 , #$55
    out  tempReg0 , #$A2E1
    ret
    
ClearOne:
    load tempReg0 , #$FF
    out  tempReg0 , #$A280
    out  tempReg0 , #$A281
    out  tempReg0 , #$A2A0
    out  tempReg0 , #$A2A1
    out  tempReg0 , #$A2C1
    out  tempReg0 , #$A2E1
    ret

NibbleShift:
    asl  tempReg0
    asl  tempReg0
    asl  tempReg0
    asl  tempReg0
    ret

DisplayDigit:
    load colCount , #4
    load rowCount , #4
    DoCol:
    out  tempReg0 , LOOKUPADDR
    in   numIn    , ROMDATA
    out  numIn    , numOffset
    add  tempReg0 , #1
    add  numOffset, #1
    sub  colCount , #1
    jpnz DoCol
    load colCount , #4
    DoRow:
    sub rowCount  , #1
    add numOffset , #$1C
    or  rowCount  , #0
    rtz
    jump DoCol

AMPM:
    load tempReg0 , AMPMReg1
    in   tempReg1 , HOUR
    stor tempReg1 , AMPMReg1
    comp tempReg0 , #%00010001
    rtnz
    comp tempReg1 , #%00010010
    rtnz
    
ToggleAMPM:
    xor  AMPMReg0 , #$00FF
    ret

AM:
    load tempReg1 , #$0A
    out  tempReg1 , A
    load tempReg1 , #$FF
    out  tempReg1 , B    
    ret
    
PM:
    load tempReg1 , #$FF
    out  tempReg1 , A
    load tempReg1 , #$19
    out  tempReg1 , B   
    ret
    
ClearClock:
    load startReg , #$A2FF
    load stopReg ,  #$A27F
    call ClearMessage
    ret

;Draw and clear on screen messages.
DoMessage:
    load swReg     , #$00
    load callReg   , #ClearDemoMessage
    load clearReg  , #DrawDemoMessage
    call DoZeroFunction    
    load swReg     , #$01
    load callReg   , #DrawTiledClockMessage
    load clearReg  , #ClearTiledClockMessage
    call DoFunction    
    load swReg     , #$02
    load callReg   , #DrawSpriteAudioMessage
    load clearReg  , #ClearSpriteAudioMessage
    call DoFunction    
    load swReg     , #$04
    load callReg   , #DrawBaseColorMessage
    load clearReg  , #ClearBaseColorMessage
    call DoFunction    
    load swReg     , #$08
    load callReg   , #DrawBouncingSpritesMessage
    load clearReg  , #ClearBouncingSpritesMessage
    call DoFunction    
    load swReg     , #$10
    load callReg   , #DrawAttributeTableMessage
    load clearReg  , #ClearAttributeTableMessage
    call DoFunction       
    load swReg     , #$20
    load callReg   , #DrawSpritePriorityMessage
    load clearReg  , #ClearSpritePriorityMessage
    call DoFunction    
    load swReg     , #$40
    load callReg   , #DrawPaletteChangeMessage
    load clearReg  , #ClearPaletteChangeMessage
    call DoFunction    
    load swReg     , #$80
    load callReg   , #DrawSpriteMirroringMessage
    load clearReg  , #ClearSpriteMirroringMessage
    call DoFunction
    ret
    
DrawDemoMessage:
    load mIndexReg , #$15
    load startReg  , #$A1F5
    load stopReg   , #$A1DF
    call DrawMessage
    ret    
    
ClearDemoMessage:
    load startReg , #$A1F5
    load stopReg  , #$A1DF
    call ClearMessage
    ret    
    
DrawTiledClockMessage:
    load mIndexReg, #$20
    load startReg , #$A20A
    load stopReg  , #$A1FF
    call DrawMessage
    ret

ClearTiledClockMessage:
    load startReg , #$A20A
    load stopReg  , #$A1FF
    call ClearMessage
    ret

DrawSpriteAudioMessage:
    load mIndexReg, #$2C
    load startReg , #$A21B
    load stopReg  , #$A20F
    call DrawMessage
    ret
    
ClearSpriteAudioMessage:
    load startReg , #$A21B
    load stopReg  , #$A20F
    call ClearMessage
    ret
    
DrawBaseColorMessage:
    load mIndexReg, #$36
    load startReg , #$A229
    load stopReg  , #$A21F
    call DrawMessage
    ret
    
ClearBaseColorMessage:
    load startReg , #$A229
    load stopReg  , #$A21F
    call ClearMessage
    ret
    
DrawBouncingSpritesMessage:
    load mIndexReg, #$46
    load startReg , #$A23F
    load stopReg  , #$A22F
    call DrawMessage 
    ret
    
ClearBouncingSpritesMessage:
    load startReg , #$A23F
    load stopReg  , #$A22F
    call ClearMessage 
    ret   
    
DrawAttributeTableMessage:
    load mIndexReg, #$55
    load startReg , #$A24E
    load stopReg  , #$A23F
    call DrawMessage
    ret
    
ClearAttributeTableMessage:
    load startReg , #$A24E
    load stopReg  , #$A23F
    call ClearMessage
    ret
    
DrawSpritePriorityMessage:
    load mIndexReg, #$64
    load startReg , #$A25E
    load stopReg  , #$A24F
    call DrawMessage
    ret
    
ClearSpritePriorityMessage:
    load startReg , #$A25E
    load stopReg  , #$A24F
    call ClearMessage
    ret
    
DrawPaletteChangeMessage:
    load mIndexReg, #$72
    load startReg , #$A26D
    load stopReg  , #$A25F
    call DrawMessage
    ret
    
ClearPaletteChangeMessage:
    load startReg , #$A26D
    load stopReg  , #$A25F
    call ClearMessage
    ret
    
DrawSpriteMirroringMessage:
    load mIndexReg, #$82
    load startReg , #$A27F
    load stopReg  , #$A26F
    call DrawMessage
    ret
    
ClearSpriteMirroringMessage:
    load startReg , #$A27F
    load stopReg  , #$A26F
    call ClearMessage
    ret
    
DrawMessage:
    out  mIndexReg, MESSAGETBL
    in   tempReg0 , ROMDATA
    out  tempReg0 , startReg
    sub  startReg , #1
    sub  mIndexReg, #1
    comp startReg , stopReg
    jpnz DrawMessage
    ret

ClearMessage:
    load mIndexReg, #$FF
    out  mIndexReg, startReg
    sub  startReg , #1
    comp startReg , stopReg
    jpnz ClearMessage
    ret
    
DoBaseColor:
    in   switchReg , SWITCHES
    and  switchReg , #$04
    comp switchReg , #$04
    clz  UpdateBaseColor
    comp switchReg , #$04
    clnz ClearBaseColor
    ret
    
UpdateBaseColor:
    add  bcDelReg  , #1
    comp bcDelReg  , #$20
    clz  IncrementBaseColor
    out  bcReg     , #$A700
    ret

IncrementBaseColor:
    add  bcReg     , #1
    load bcDelReg  , #0
    ret
    
ClearBaseColor:
    load bcReg     , #0
    out  bcReg     , #$A700
    load bcDelReg  , #0
    ret

DoBouncingSprites:
    load swReg     , #$08
    load callReg   , #UpdateBouncingSprites
    load clearReg  , #ClearBouncingSprites
    call DoFunction
    call DrawBouncingSprites
    ret

UpdateBouncingSprites:
    call CheckBouncingSpritesStart    
    load tempReg0 , #$20
    UpdateBouncingSpritesLoop:
    load tempReg3 , (tempReg0)
    comp tempReg3 , UPLEFT
    clz  MoveUpLeft
    comp tempReg3 , UPRIGHT
    clz  MoveUpRight
    comp tempReg3 , DOWNLEFT
    clz  MoveDownLeft
    comp tempReg3 , DOWNRIGHT
    clz  MoveDownRight    
    add  tempReg0 , #1
    comp tempReg0 , #$28
    jpnz UpdateBouncingSpritesLoop    
    ret

MoveUpRight:
    call CheckYMin
    comp checkReg , #1
    jpz  ChangeToDownRight
    call CheckXMax
    comp checkReg , #1
    jpz  ChangeToUpLeft
    load tempReg1 , tempReg0
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    add  tempReg2 , #1
    stor tempReg2 , (tempReg1)
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    sub  tempReg2 , #1
    stor tempReg2 , (tempReg1)
    ret
    
MoveUpLeft:
    call CheckYMin
    comp checkReg , #1
    jpz  ChangeToDownLeft
    call CheckXMin
    comp checkReg , #1
    jpz  ChangeToUpRight
    load tempReg1 , tempReg0
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    sub  tempReg2 , #1
    stor tempReg2 , (tempReg1)
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    sub  tempReg2 , #1
    stor tempReg2 , (tempReg1)
    ret
    
MoveDownRight:
    call CheckYMax
    comp checkReg , #1
    jpz  ChangeToUpRight
    call CheckXMax
    comp checkReg , #1
    jpz  ChangeToDownLeft
    load tempReg1 , tempReg0
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    add  tempReg2 , #1
    stor tempReg2 , (tempReg1)
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    add  tempReg2 , #1
    stor tempReg2 , (tempReg1)
    ret
    
MoveDownLeft:
    call CheckXMin
    comp checkReg , #1
    jpz  ChangeToDownRight
    call CheckYMax
    comp checkReg , #1
    jpz  ChangeToUpLeft
    load tempReg1 , tempReg0
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    sub  tempReg2 , #1
    stor tempReg2 , (tempReg1)
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    add  tempReg2 , #1
    stor tempReg2 , (tempReg1)
    ret
    
CheckYMin:
    load tempReg1 , tempReg0
    sub  tempReg1 , #16
    load tempReg2 , (tempReg1)
    comp tempReg2 , #0
    jpz  ExtentReached
    load checkReg , #0
    ret
    
CheckYMax:
    load tempReg1 , tempReg0
    sub  tempReg1 , #16
    load tempReg2 , (tempReg1)
    comp tempReg2 , #231
    jpz  ExtentReached
    load checkReg , #0
    ret
    
CheckXMin:
    load tempReg1 , tempReg0
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    comp tempReg2 , #0
    jpz  ExtentReached
    load checkReg , #0
    ret
    
CheckXMax:
    load tempReg1 , tempReg0
    sub  tempReg1 , #8
    load tempReg2 , (tempReg1)
    comp tempReg2 , #247
    jpz  ExtentReached
    load checkReg , #0
    ret
    
ExtentReached:
    load checkReg , #1
    ret

ChangeToDownRight:
    load tempReg1 , DOWNRIGHT
    stor tempReg1 , (tempReg0)
    ret
    
ChangeToDownLeft:
    load tempReg1 , DOWNLEFT
    stor tempReg1 , (tempReg0)
    ret
    
ChangeToUpRight:
    load tempReg1 , UPRIGHT
    stor tempReg1 , (tempReg0)
    ret
    
ChangeToUpLeft:
    load tempReg1 , UPLEFT
    stor tempReg1 , (tempReg0)
    ret
    
ClearBouncingSprites:
    load tempReg0 , #$0F
    load tempReg1 , #$FF
    YClearLoop:
    add  tempReg0 , #1
    stor tempReg1 , (tempReg0)
    comp tempReg0 , #$17
    jpnz YClearLoop 
    ret
    
CheckBouncingSpritesStart:
    comp sp0y     , #$FF
    rtnz
    load sp0y     , #11
    load sp1y     , #22
    load sp2y     , #33
    load sp3y     , #44
    load sp4y     , #55
    load sp5y     , #66
    load sp6y     , #77
    load sp7y     , #88
    load sp0x     , #11
    load sp1x     , #22
    load sp2x     , #33
    load sp3x     , #44
    load sp4x     , #55
    load sp5x     , #66
    load sp6x     , #77
    load sp7x     , #88
    load sp0m     , DOWNRIGHT
    load sp1m     , DOWNRIGHT
    load sp2m     , DOWNRIGHT
    load sp3m     , DOWNRIGHT
    load sp4m     , DOWNRIGHT
    load sp5m     , DOWNRIGHT
    load sp6m     , DOWNRIGHT
    load sp7m     , DOWNRIGHT
    ret
    
DrawBouncingSprites:
    load tempReg0 , #$10
    load tempReg1 , #$B000
    FillYLoop:
    load tempReg2 , (tempReg0)
    out  tempReg2 , tempReg1
    add  tempReg0 , #1
    add  tempReg1 , #4
    comp tempReg0 , #$18
    jpnz FillYLoop
    
    load tempReg0 , #$18
    load tempReg1 , #$B003
    FillXLoop:
    load tempReg2 , (tempReg0)
    out  tempReg2 , tempReg1
    add  tempReg0 , #1
    add  tempReg1 , #4
    comp tempReg0 , #$20
    jpnz FillXLoop
    
    load tempReg0 , #$20
    load tempReg1 , #$B002
    FillMLoop:    
    load tempReg2 , (tempReg0)
    out  tempReg2 , tempReg1
    add  tempReg0 , #1
    add  tempReg1 , #4
    comp tempReg0 , #$28
    jpnz FillMLoop
    
    load tempReg0 , #$04
    load tempReg1 , #$B001
    FillPatternLoop:
    out  tempReg0 , tempReg1
    add  tempReg1 , #4
    comp tempReg1 , #$B021
    jpnz FillPatternLoop
    ret
    
DoPaletteChange:
    load swReg    , #$40
    load callReg  , #ChangePalettes
    load clearReg , #SetDefaultPalettes
    jump DoFunction
    
ChangePalettes:
    add  palDelReg, #1
    comp palDelReg, #$10
    rtnz
    load palDelReg, #0
    load tempReg0 , #$A600
    load tempReg2 , PALREGS
    ChangePalettesLoop:
    comp tempReg2 , #$30
    jpz  NextPalette
    comp tempReg2 , #$34
    jpz  NextPalette
    comp tempReg2 , #$38
    jpz  NextPalette
    comp tempReg2 , #$3C
    jpz  NextPalette
    comp tempReg2 , #$40
    jpz  NextPalette
    comp tempReg2 , #$44
    jpz  NextPalette
    comp tempReg2 , #$48
    jpz  NextPalette
    comp tempReg2 , #$4C
    jpz  NextPalette
    load tempReg1 , (tempReg2)
    add  tempReg1 , #1
    stor tempReg1 , (tempReg2)
    out  tempReg1 , tempReg0
    NextPalette:
    add  tempReg0 , #1
    add  tempReg2 , #1
    comp tempReg0 , #$A620
    jpnz ChangePalettesLoop
    ret
    
SetDefaultPalettes:
    load tempReg0 , #$A600
    load tempReg3 , PALREGS
    load tempReg1 , #0
    SetDefaultPalettesLoop:
    out  tempReg1 , PALETTETBL
    in   tempReg2 , ROMDATA
    out  tempReg2 , tempReg0
    stor tempReg2 , (tempReg3)
    add  tempReg1 , #1
    add  tempReg0 , #1
    add  tempReg3 , #1
    comp tempReg0 , #$A620
    jpnz SetDefaultPalettesLoop
    ret
    
;------------------------------------Sprite Mirroring Routines-------------------------------------
DoSpriteMirroring:
    load swReg    , #$80                            ;Switch 8 controls the sprite mirroring.
    load callReg  , #SpriteMirror                   ;Mirroring entry function.
    load clearReg , #ClearSpriteMirror              ;Clear mirroring sprites.
    jump DoFunction                                 ;
    
SpriteMirror:
    add  mirDelReg, #1                              ;
    comp mirDelReg, #$04                            ;Update mirroring sprites every 4th frame.
    rtnz                                            ;
    
    load tempReg0 , #$B020                          ;Set address to PPU mirroring sprite RAM.
    
    SpriteLoadLoop:
    out  mirPtrReg, SPRITETBL
    in   tempReg1 , ROMDATA
    out  tempReg1 , tempReg0
    add  mirPtrReg, #1
    add  tempReg0 , #1
    and  mirPtrReg, #$FF
    comp mirPtrReg, #$40
    jpz  FinishSpriteLoadLoop
    comp mirPtrReg, #$80
    jpz  FinishSpriteLoadLoop
    comp mirPtrReg, #$C0
    jpz  FinishSpriteLoadLoop
    comp mirPtrReg, #$00
    jpz  FinishSpriteLoadLoop
    jump SpriteLoadLoop    
    FinishSpriteLoadLoop:    
    load mirDelReg, #0  
    ret
    
ClearSpriteMirror:
    load tempReg0 , #$B020
    load tempReg1 , #$FF
    ClearSpriteMirrorLoop:
    out  tempReg1 , tempReg0    
    add  tempReg0 , #1
    comp tempReg0 , #$B060
    jpnz ClearSpriteMirrorLoop
    load mirDelReg, #0
    load mirPtrReg, #0   
    ret

;--------------------------------------Audio Sprite Routines---------------------------------------
DoSpriteAudio:
    load swReg    , #$02                            ;2nd switch controls audio sprites.
    load callReg  , #SpriteAudio                    ;Audio sprite entry function.
    load clearReg , #ClearSpriteAudio               ;Clear audio sprites function.
    jump DoFunction                                 ;

SpriteAudio:
    load tempReg0 , #$A000
    load tempReg1 , #$78
    AudioBackgroundTopLoop:
    out  tempReg1 , tempReg0
    add  tempReg0 , #1
    comp tempReg0 , #$A020
    jpnz AudioBackgroundTopLoop
    load tempReg1 , #$79
    AudioBackgroundMidLoop:
    out  tempReg1 , tempReg0
    add  tempReg0 , #1
    comp tempReg0 , #$A1A0
    jpnz AudioBackgroundMidLoop
    load tempReg1 , #$7A
    AudioBackgroundBotLoop:
    out  tempReg1 , tempReg0
    add  tempReg0 , #1
    comp tempReg0 , #$A1C0
    jpnz AudioBackgroundBotLoop
    call DisplayAudioSprites                        ;Draw audio sprites on the display.
    call DisplayMag                                 ;Draw magnification factor on display.
    ret                                             ;
    
ClearSpriteAudio:
    load tempReg1 , #$FF                            ;Blank sprite.
    load tempReg0 , #$A000                          ;
    
    ClearSpriteAudioLoop:
    out  tempReg1 , tempReg0
    add  tempReg0 , #1
    comp tempReg0 , #$A1C0
    jpnz ClearSpriteAudioLoop
    
    out  tempReg1 , tempReg0                        ;
    add  tempReg0 , #1                              ;Clear magnification factor from display.
    out  tempReg1 , tempReg0                        ;
    add  tempReg0 , #1                              ;
    out  tempReg1 , tempReg0                        ;
    
    load tempReg0 , PPUAUDSPSTART                   ;Base address in PPU sprite RAM.
    load tempReg1 , #$FF                            ;Move sprite off screen.
    
    RemoveAudioSprites:
    out  tempReg1 , tempReg0                        ;
    add  tempReg0 , #1                              ;Loop to write #$FF into all-->
    comp tempReg0 , PPUAUDSPEND                     ;audio sprite RAM.  This will-->
    jpnz RemoveAudioSprites                         ;move the sprites off screen.
    ret                                             ;
    
DisplayAudioSprites:
    load tempReg0 , PPUAUDSPSTART                   ;Base address in PPU sprite RAM.
    load tempReg1 , #0                              ;Sprite X location.
    load tempReg2 , SPRITEREGS                      ;Base address in CPU audio sprite RAM.
    load tempReg3 , #$A0                            ;Audio sprite pattern table address.
    
    DisplayAudioSpritesLoop:
    load miscReg  , (tempReg2)                      ;Get sprite audio data from CPU memory.
    xor  miscReg  , #$007F                          ;Compute proper positon on display.
    sub  miscReg  , #$10                            ;
    out  miscReg  , tempReg0                        ;Set sprite Y position in PPU RAM.
    
    add  tempReg0 , #1                              ;Set sprite pattern in PPU RAM.
    out  tempReg3 , tempReg0                        ;
    
    add  tempReg0 , #1                              ;Set property bit in PPU RAM.
    load miscReg  , #2                              ;No flipping, foreground sprite,-->
    out  miscReg  , tempReg0                        ;pallette %$10.
    
    add  tempReg0 , #1                              ;Store sprite X position in PPU RAM.
    out  tempReg1 , tempReg0                        ;
    
    add  tempReg2 , #1                              ;Move to next sprite in CPU memory.
    add  tempReg1 , #2                              ;Move x by 2 pixels for next sprite.
    add  tempReg0 , #1                              ;Move to next sprite in PPU RAM.
    
    comp tempReg0 , PPUAUDSPEND                     ;Check if more sprites to process(128 total).
    jpnz DisplayAudioSpritesLoop                    ;Loop if more sprites to process.
    ret                                             ;
    
DisplayMag:
    comp micSmpReg, #$0200
    jpnz Check02X
    load tempReg1 , #$78
    load tempReg2 , #$01
    load tempReg3 , #$21
    
    Check02X:
    comp micSmpReg, #$0100
    jpnz Check04X
    load tempReg1 , #$78
    load tempReg2 , #$02
    load tempReg3 , #$21    
    
    Check04X:
    comp micSmpReg, #$0080
    jpnz Check08X
    load tempReg1 , #$78
    load tempReg2 , #$04
    load tempReg3 , #$21    
    
    Check08X:
    comp micSmpReg, #$0040
    jpnz Check16X
    load tempReg1 , #$78
    load tempReg2 , #$08
    load tempReg3 , #$21    
    
    Check16X:
    comp micSmpReg, #$0020
    jpnz Check32X
    load tempReg1 , #$01
    load tempReg2 , #$06
    load tempReg3 , #$21  
    
    Check32X:
    comp micSmpReg, #$0010
    jpnz LoadMag
    load tempReg1 , #$03
    load tempReg2 , #$02
    load tempReg3 , #$21  
    
LoadMag:
    load tempReg0 , #$A000
    out  tempReg1 , tempReg0
    add  tempReg0 , #1
    out  tempReg2 , tempReg0
    add  tempReg0 , #1
    out  tempReg3 , tempReg0
    ret
    
GetAudioData:
    load micDelReg, #0                              ;Zero the mic delay register.
    load audPtrReg, SPRITEREGS                      ;Get base address of audio sprites RAM.
    
    in   audHldReg, MICDATA                         ;Get audio input data.
    asl  audHldReg                                  ;Check if mag button depressed.
    clc  MagChangeButtonPushed                      ;If so, change magnification.
    
    in   audHldReg, MICDATA
    asl  audHldReg
    clnc MagChangeButtonReleased
    
    GetAudioLoop:
    add  audCtrReg, #1                              ;Delay to for specified sampling time.
    comp audCtrReg, micSmpReg                       ;Check if tie for another sample.
    jpnz GetAudioLoop
    load audCtrReg, #0
    
    in   audHldReg, MICDATA                         ;Get audio data from port. 
    and  audHldReg, #$0FFF                          ;Keep only audio data bits.
    lsr  audHldReg                                  ;
    lsr  audHldReg                                  ;Keep only upper 7 bits.
    lsr  audHldReg                                  ;
    lsr  audHldReg                                  ;
    lsr  audHldReg                                  ;
    
    sub  audHldReg, #8
    stor audHldReg, (audPtrReg)
    add  audPtrReg, #1
    comp audPtrReg, ENDAUDIOREGS
    jpnz GetAudioLoop
    load audPtrReg, #0
    ret
    
MagChangeButtonReleased:
    load micStaReg, #0
    ret
    
MagChangeButtonPushed:
    rol  micStaReg
    jpc  DebounceDone
    load micStaReg, #$8000
    ret
    
DebounceDone:
    ror  micStaReg
    ror  micStaReg
    clnc ChangeMag
    load micStaReg, #$8001
    ret
    
ChangeMag:
    comp micSmpReg, #$0200                          ;If at 1x magnification, -->
    jpz  ChangeTo2X                                 ;change to 2x magnification.
    
    comp micSmpReg, #$0100                          ;If at 2x magnification, -->
    jpz  ChangeTo4X                                 ;change to 4x magnification.
    
    comp micSmpReg, #$0080                          ;If at 4x magnification, -->
    jpz  ChangeTo8X                                 ;change to 8x magnification.
    
    comp micSmpReg, #$0040                          ;If at 8x magnification, -->
    jpz  ChangeTo16X                                ;change to 16x magnification.
    
    comp micSmpReg, #$0020                          ;If at 16x magnification, -->
    jpz  ChangeTo32X                                ;change to 32x magnification.
    
    comp micSmpReg, #$0010                          ;If at 32x magnification, -->
    jump ChangeTo1X                                 ;change to 1x magnification.

ChangeTo1X:
    load micSmpReg, #$0200                          ;Change to 1x magnification.
    ret                                             ;
ChangeTo2X:
    load micSmpReg, #$0100                          ;Change to 2x magnification.
    ret                                             ;
ChangeTo4X:
    load micSmpReg, #$0080                          ;Change to 4x magnification.
    ret                                             ;
ChangeTo8X:
    load micSmpReg, #$0040                          ;Change to 8x magnification.
    ret                                             ;
ChangeTo16X:
    load micSmpReg, #$0020                          ;Change to 16x magnification.
    ret                                             ;
ChangeTo32X:
    load micSmpReg, #$0010                          ;Change to 32x magnification.
    ret                                             ;
;--------------------------------------------------------------------------------------------------
    
DoAttribChange:
    load swReg    , #$10
    load callReg  , #AttributeTable
    load clearReg , #ClearAttributeTable
    jump DoFunction

AttributeTable:
    add  atDelReg , #1
    comp atDelReg , #8
    rtnz
    load atDelReg , #0
    add  atStatReg, #1
    comp atStatReg, #4
    clz  ResetAttributeReg
    load tempReg0 , #$A580
    SetAttributeTableLoop:
    comp atStatReg, #0
    jpnz NextCheck1
    load tempReg1 , AT0    
    NextCheck1:
    comp atStatReg, #1
    jpnz NextCheck2
    load tempReg1 , AT1
    NextCheck2:
    comp atStatReg, #2
    jpnz NextCheck3
    load tempReg1 , AT2
    NextCheck3:
    comp atStatReg, #3
    jpnz FinishCheck
    load tempReg1 , AT3    
    FinishCheck:
    out  tempReg1, tempReg0
    add  tempReg0 , #1    
    comp tempReg0 , #$A5A0
    jpnz SetAttributeTableLoop
    ret
    
ResetAttributeReg:
    load atStatReg, #0
    ret
    
ClearAttributeTable:
    load tempReg0 , #$A580
    load tempReg1 , #0
    ClearAttributeTableLoop:
    out  tempReg1 , tempReg0
    add  tempReg0 , #1    
    comp tempReg0 , #$A5A0
    jpnz ClearAttributeTableLoop
    ret
    
DoSpritePriority:
    load swReg    , #$20
    load callReg  , #UpdateSpritePriority
    load clearReg , #ClearSpritePriority
    jump DoFunction
    
    ;anDelReg, samROMReg, samXReg, movDelReg
    ;samM0Reg, samM1Reg, samM2Reg
    
UpdateSpritePriority:
    load tempReg0 , #$A33F
    load tempReg1 , #$7C
    DrawPillarsLoop:
    add  tempReg0 , #3
    out  tempReg1 , tempReg0
    add  tempReg0 , #1
    out  tempReg1 , tempReg0
    comp tempReg0 , #$A3BF
    jpnz DrawPillarsLoop
    
    add anDelReg  , #1
    add movDelReg , #1
    
    call CheckSamusMovement
    call CheckSamusAnimation
    
    DrawSamus:
    load tempReg0 , #$B0D0
    load tempReg1 , samROMReg
    
    GetSamusROMLoop:
    out  tempReg1 , PALETTETBL
    in   tempReg2 , ROMDATA
    out  tempReg2 , tempReg0
    add  tempReg0 , #1
    add  tempReg1 , #1
    out  tempReg1 , PALETTETBL
    in   tempReg2 , ROMDATA
    out  tempReg2 , tempReg0
    add  tempReg0 , #3
    add  tempReg1 , #1
    comp tempReg0 , #$B100
    jpnz GetSamusROMLoop
    
    load tempReg0 , samXReg
    
    LoadSamusMX:
    out  samM0Reg , #$B0D2
    out  tempReg0 , #$B0D3
    out  samM0Reg , #$B0DA
    out  tempReg0 , #$B0DB
    out  samM0Reg , #$B0E2
    out  tempReg0 , #$B0E3
    out  samM0Reg , #$B0EE
    out  tempReg0 , #$B0EF
    
    add  tempReg0 , #8
    
    out  samM1Reg , #$B0D6
    out  tempReg0 , #$B0D7
    out  samM1Reg , #$B0DE
    out  tempReg0 , #$B0DF
    out  samM1Reg , #$B0E6
    out  tempReg0 , #$B0E7
    out  samM1Reg , #$B0F2
    out  tempReg0 , #$B0F3
    
    add  tempReg0 , #8
    
    out  samM2Reg , #$B0EA
    out  tempReg0 , #$B0EB
    out  samM2Reg , #$B0F6
    out  tempReg0 , #$B0F7
    
    ret
    
CheckSamusMovement:
    comp movDelReg, #2
    jpz  UpdateSamusPosition
    ret
    
CheckSamusAnimation:
    comp anDelReg , #8
    jpz  UpdateSamusAnimation
    ret
    
UpdateSamusAnimation:
    add  samROMReg, #$18
    comp samROMReg, #$A0
    clz  ResetSamusROMReg
    load anDelReg , #0
    ret
    
ResetSamusROMReg:
    load samROMReg, #$40
    ret
    
UpdateSamusPosition:
    load movDelReg, #0
    sub  samXReg  , #1
    and  samXReg  , #$FF
    
    load tempReg0 , samXReg
    
    comp tempReg0 , #$20
    clz  SwitchM0Priority
    comp tempReg0 , #$40
    clz  SwitchM0Priority
    comp tempReg0 , #$60
    clz  SwitchM0Priority
    comp tempReg0 , #$80
    clz  SwitchM0Priority
    comp tempReg0 , #$A0
    clz  SwitchM0Priority
    comp tempReg0 , #$C0
    clz  SwitchM0Priority
    comp tempReg0 , #$E0
    clz  SwitchM0Priority
    
    add  tempReg0 , #8
    
    comp tempReg0 , #$20
    clz  SwitchM1Priority
    comp tempReg0 , #$40
    clz  SwitchM1Priority
    comp tempReg0 , #$60
    clz  SwitchM1Priority
    comp tempReg0 , #$80
    clz  SwitchM1Priority
    comp tempReg0 , #$A0
    clz  SwitchM1Priority
    comp tempReg0 , #$C0
    clz  SwitchM1Priority
    comp tempReg0 , #$E0
    clz  SwitchM1Priority
    
    add  tempReg0 , #8
    
    comp tempReg0 , #$20
    clz  SwitchM2Priority
    comp tempReg0 , #$40
    clz  SwitchM2Priority
    comp tempReg0 , #$60
    clz  SwitchM2Priority
    comp tempReg0 , #$80
    clz  SwitchM2Priority
    comp tempReg0 , #$A0
    clz  SwitchM2Priority
    comp tempReg0 , #$C0
    clz  SwitchM2Priority
    comp tempReg0 , #$E0
    clz  SwitchM2Priority
    
    ret
    
SwitchM0Priority:
    xor  samM0Reg , #$20
    ret
    
SwitchM1Priority:
    xor  samM1Reg , #$20
    ret
    
SwitchM2Priority:
    xor  samM2Reg , #$20
    ret
    
ClearSpritePriority:
    load tempReg0 , #$A320
    load tempReg1 , #$FF
    ClearPillarsLoop:
    out  tempReg1 , tempReg0
    add  tempReg0 , #1
    comp tempReg0 , #$A3C0    
    jpnz ClearPillarsLoop
    load tempReg0 , #$B0D0
    ClearWalkingSpritesLoop:
    out  tempReg1 , tempReg0    
    add  tempReg0 , #1
    comp tempReg0 , #$B100
    jpnz ClearWalkingSpritesLoop
    load samROMReg, #$40
    load samXReg  , #$E5
    load samM0Reg , #$03
    load samM1Reg , #$03
    load samM2Reg , #$03
    ret
