`timescale 1ns / 1ps

//declare variables (page 6)
module text_LCD_basic(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out);

input rst, clk;

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;
output reg [7:0] LED_out;

wire LCD_E;
reg LCD_RS, LCD_RW;

reg [2:0] state;
parameter DELAY = 3'b000,
          FUNCTION_SET = 3'b001,
          ENTRY_MODE   = 3'b010,
          DISP_ONOFF   = 3'b011,
          LINE1        = 3'b100,
          LINE2        = 3'b101,
          DELAY_T      = 3'b110,
          CLEAR_DISP   = 3'b111;
          
integer cnt; //cnt increases by one per clock

//change state (page 7)
always @(posedge clk or negedge rst)
begin
    if(!rst)
        state = DELAY;
    else
    begin
        case(state)
            DELAY : begin
                LED_out = 8'b1000_0000;
                if(cnt == 70) state = FUNCTION_SET;
            end
            FUNCTION_SET : begin
                LED_out = 8'b0100_0000;
                if(cnt == 30) state = DISP_ONOFF;
            end
            DISP_ONOFF : begin
                LED_out = 8'b0010_0000;
                if(cnt == 30) state = ENTRY_MODE;
            end
            ENTRY_MODE : begin
                LED_out = 8'b0001_0000; 
                if(cnt == 30) state = LINE1;
            end
            LINE1 : begin
                LED_out = 8'b0000_1000;
                if(cnt == 20) state = LINE2;
            end
            LINE2 : begin
                LED_out = 8'b0000_0100;
                if(cnt == 20) state = DELAY_T;
            end
            DELAY_T : begin
                LED_out = 8'b0000_0010;
                if(cnt == 5) state = CLEAR_DISP;
            end
            CLEAR_DISP : begin
                LED_out = 8'b0000_0001;
                if(cnt == 5) state = LINE1;
            end
            default : state = DELAY;
        endcase
    end
end
// repeat LINE1->LINE2->DELAY_T->CLEAR_DISP
// (page 8)
always @(posedge clk or negedge rst)
begin
    if(!rst)
        cnt = 0;
    else begin
        case(state)
            DELAY :
                if(cnt >= 70) cnt = 0;
                else cnt = cnt + 1;
            FUNCTION_SET :
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            DISP_ONOFF :
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            ENTRY_MODE :
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            LINE1 :
                if(cnt >= 20) cnt = 0;
                else cnt = cnt + 1;
            LINE2 :
                if(cnt >= 20) cnt = 0;
                else cnt = cnt + 1;
            DELAY_T :
                if(cnt >= 5) cnt = 0;
                else cnt = cnt + 1;
            CLEAR_DISP :
                if(cnt >= 5) cnt = 0;
                else cnt = cnt + 1;
            default : state = DELAY;
        endcase
    end
end

//print out instructions against state (page 9)
always @(posedge clk or negedge rst)
begin
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_00000000; 
    else begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000; //if I use only LINE1, change to 10'b0_0_00110000;
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100;
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110; //If I want to shift screen, change to 10'b0_0_0000_0111;
                
// (page 9) first line : HELLO WORLD
LINE1 :
    begin
        case(cnt)
            00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000; //if I want to change start address, change LCD_DATA to address that I want (10'b0_0_1000_0011)
            01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
            02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1000; //H
            03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101; //E
            04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100; //L
            05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100; //L
            06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1111; //O
            07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
            08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0111; //W
            09 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1111; //O
            10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0010; //R
            11 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100; //L
            12 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0100; //D
            13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0001; //!
            14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
            15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
            16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
            default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
        endcase
    end
// (page 12) Secon line : my name & my student number
LINE2 :
    begin
        case(cnt)
            00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000; //if I want to change start address in LINE2, change LCD_DATA to address that I want (10'b0_0_1100_0011)
            01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; //2
            02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; //0
            03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; //2
            04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; //0
            05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; //4
            06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; //4
            07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; //0
            08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; //0
            09 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001; //1
            10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; //4
            11 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
            12 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1011; //K
            13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0100; //D
            14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_1001; //Y
            15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
            16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
            default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
        endcase
    end
//(page 13) DELAY_T : keep LCD screen during specific state , CLEAR_DISP : erase all LCD screen
        DELAY_T :
            {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
        CLEAR_DISP :
            {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001;
        default :
            {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000;
        endcase
    end
end


assign LCD_E = clk;


endmodule
