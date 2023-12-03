`timescale 1ns / 1ps
//100Hz 0.01s
module traffic_light(clk, rst, S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED,
                     S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                     S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT);
                     

input clk, rst;

output reg S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN; //walk green 4
output reg S_W_RED, N_W_RED, W_W_RED, E_W_RED;         //walk red 4
output reg S_GREEN, N_GREEN, W_GREEN, E_GREEN;         //car green 4
output reg S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW;     //car yellow 4
output reg S_RED, N_RED, W_RED, E_RED;                 //car red 4
output reg S_LEFT, N_LEFT, W_LEFT, E_LEFT;             //car left 4



reg [4:0] state; //week11 page5
parameter A     = 5'b00000,
          AtoD  = 5'b00001,
         D     = 5'b00010,
         DtoF  = 5'b00011,
         F     = 5'b00100,
         FtoE1 = 5'b00101,
         E1    = 5'b00110,
         E1toG = 5'b00111,
         G     = 5'b01000,
         GtoE2 = 5'b01001,
         E2    = 5'b01010,
         E2toA = 5'b01011,
         B     = 5'b01100,
         BtoA1 = 5'b01101,
         A1    = 5'b01110,
         A1toC = 5'b01111,
         C     = 5'b10000,
         CtoA2 = 5'b10001,
         A2    = 5'b10010,
         A2toE3= 5'b10011,
         E3    = 5'b10100,
         E3toH = 5'b10101,
         H     = 5'b10110,
         HtoB  = 5'b10111;
     
integer cnt;


//Clcok
integer cnt_clock; //CNT_1000Hz;
//integer cnt_watch; //cnt_watch;
reg clk_clock; // CLK_1000Hz;
//reg SET;

reg [3:0] hour_10, hour_1, min_10, min_1, sec_1, sec_10, he, h4; //h1, h2, m1, m2, s1, s2

/*initial begin
    cnt_clock = 0;
end*/

always @(posedge clk_clock or negedge rst) begin
    if(!rst) begin
    hour_10 = 4'b0001; //4'b0001: day, 4'b0000: night
    hour_1 = 4'b0000;
    min_10 = 4'b0000;
    min_1 = 4'b0000;
    sec_10 = 4'b0000;
    sec_1 = 4'b0000;
    end
    end
//Clock: To make 100Hz
/*always @(posedge clk) begin
    if(cnt_clock < 50) cnt_clock = cnt_clock + 1;
    else begin
        cnt_clock = 0;
        clk_clock = ~clk_clock;
    end
end*/

//Clock: Count up
always @(posedge clk or negedge rst) begin
    if(!rst)
    cnt_clock = 0;
    else begin
    cnt_clock = cnt_clock + 1;
//cnt_watch = cnt_watch + 1;
if(cnt_clock == 100) begin //1 second
    sec_1 = sec_1 + 1;
    cnt_clock = 0;
end
//count up
if(sec_1 == 10) begin
    sec_1 = 0;
    sec_10 = sec_10 + 1;
end
if(sec_10 == 6) begin
    sec_10 = 0;
    min_1 = min_1 + 1;
end
if(min_1 == 10) begin
    min_1 = 0;
    min_10 = min_10 + 1;
end
if(min_10 == 6) begin
    min_10 = 0;
    hour_1 = hour_1 + 1;
end
if( (hour_10 == 3) || ((hour_10 == 2) && ((hour_1 >= 4) && hour_1 < 10)) ) begin
    hour_10 = 0;
    hour_1 = 0;
end
else if(hour_1 == 10) begin
    hour_1 = 0;
    hour_10 = hour_10 + 1;
end

end
end

//day = ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3))
//!day = !( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) )

                     
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= A;
    end
    else begin
        if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3))) begin //day
            case(state)
                A : if(cnt == 500) state <= AtoD; //5seconds
                AtoD : if(cnt == 100) state <= D;
                D : if(cnt == 500) state <= DtoF;
                DtoF : if(cnt == 100) state <= F;
                F : if(cnt == 500) state <= FtoE1;
                FtoE1 : if(cnt == 100) state <= E1;
                E1 : if(cnt == 500) state <= E1toG;
                E1toG : if(cnt == 100) state <= G;
                G : if(cnt == 500) state <= GtoE2;
                GtoE2 : if(cnt == 100) state <= E2;
                E2 : if(cnt == 500) state <= E2toA;
                E2toA : if(cnt == 100) state <= A;
                default : state <= A;
            endcase
        end
        else //night
            case(state)
                B : if(cnt == 1000) state <= BtoA1; //10seconds
                BtoA1 : if(cnt == 100) state <= A1;
                A1 : if(cnt == 1000) state <= A1toC;
                A1toC : if(cnt == 100) state <= C;
                C : if(cnt == 1000) state <= CtoA2;
                CtoA2 : if(cnt == 100) state <= A2;
                A2 : if(cnt == 1000) state <= A2toE3;
                A2toE3 : if(cnt == 100) state <= E3;
                E3 : if(cnt == 1000) state <= E3toH;
                E3toH : if(cnt == 100) state <= H;
                H : if(cnt == 1000) state <= HtoB;
                HtoB : if(cnt == 100) state <= B;
                default : state <= B;
            endcase
        end
end
            
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt <= 0;
    end
    else begin
        case(state)
            A : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3))) //day
            begin
            if(cnt >= 500) cnt <= 0;
            else cnt <= cnt + 1;
            end
            AtoD : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            D : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 500) cnt <= 0;
            else cnt <= cnt + 1;
            end
            DtoF : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            F : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 500) cnt <= 0;
            else cnt <= cnt + 1;
            end
            FtoE1 : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            E1 : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 500) cnt <= 0;
            else cnt <= cnt + 1;
            end
            E1toG : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            G : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 500) cnt <= 0;
            else cnt <= cnt + 1;
            end
            GtoE2 : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            E2 : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 500) cnt <= 0;
            else cnt <= cnt + 1;
            end
            E2toA : if(((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            
            
            B : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) )) //!day, night
            begin
            if(cnt >= 1000) cnt <= 0;
            else cnt <= cnt + 1;
            end
            BtoA1 : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            A1 : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 1000) cnt <= 0;
            else cnt <= cnt + 1;
            end
            A1toC : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            C : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 1000) cnt <= 0;
            else cnt <= cnt + 1;
            end
            CtoA2 : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            A2 : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 1000) cnt <= 0;
            else cnt <= cnt + 1;
            end
            A2toE3 : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            E3 : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 1000) cnt <= 0;
            else cnt <= cnt + 1;
            end
            E3toH : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
            H : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 1000) cnt <= 0;
            else cnt <= cnt + 1;
            end
            HtoB : if(!( ((hour_10 == 0) && (hour_1 >= 8)) || (hour_10 == 1) || ((hour_10 == 2) && (hour_1 <= 3)) ))
            begin
            if(cnt >= 100) cnt <= 0;
            else cnt <= cnt + 1;
            end
          default : if(cnt >= 500) cnt <= 0;
                     else cnt <= cnt + 1;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
        {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
      S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
      S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000; //start with A
      else begin
        case(state)
            A : if(cnt <= 250)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000;
                else if(cnt <= 300)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1100_1100_0000_0011_0000; //blink off
                else if(cnt <= 350)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000; //blink on
                else if(cnt <= 400)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1100_1100_0000_0011_0000; //blink off
                else if(cnt <= 450)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000; //blink on
                else if(cnt <= 500)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1100_1100_0000_0011_0000; //blink off
           AtoD : if(cnt <= 100)
               {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_1100_0011_0000;                
           D : if(cnt <= 500)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_0000_0011_1100;  //no blinking              
           DtoF : if(cnt <= 100)
               {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_1100_0011_0000;
           F : if(cnt <= 500)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0100_1011_0010_0000_1101_0010; //no blinking
           FtoE1 : if(cnt <= 100)
               {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_0010_1101_0010;
           E1 : if(cnt <= 250)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1100_0011_0011_0000_1100_0000;
                else if(cnt <= 300)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0011_0011_0000_1100_0000;//blink off
                else if(cnt <= 350)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1100_0011_0011_0000_1100_0000; //blink on
                else if(cnt <= 400)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0011_0011_0000_1100_0000; //blink off
                else if(cnt <= 450)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1100_0011_0011_0000_1100_0000; //blink on
                else if(cnt <= 500)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0011_0011_0000_1100_0000; //blink off                
           E1toG : if(cnt <= 100)
               {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1000_0111_0001_0010_1100_0000;
           G : if(cnt <= 250)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1000_0111_0001_0000_1110_0001;
                else if(cnt <= 300)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0111_0001_0000_1110_0001; //blink off
                else if(cnt <= 350)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1000_0111_0001_0000_1110_0001; //blink on
                else if(cnt <= 400)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0111_0001_0000_1110_0001; //blink off
                else if(cnt <= 450)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1000_0111_0001_0000_1110_0001; //blink on
                else if(cnt <= 500)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0111_0001_0000_1110_0001; //blink off
           GtoE2 : if(cnt <= 100)
               {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_0001_1110_0000;
           E2 : if(cnt <= 250)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1100_0011_0011_0000_1100_0000;
                else if(cnt <= 300)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0011_0011_0000_1100_0000; //blink off
                else if(cnt <= 350)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1100_0011_0011_0000_1100_0000; //blink on
                else if(cnt <= 400)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0011_0011_0000_1100_0000; //blink off
                else if(cnt <= 450)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1100_0011_0011_0000_1100_0000; //blink on
                else if(cnt <= 500)
                {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0011_0011_0000_1100_0000; //blink off
           E2toA : if(cnt <= 100)
               {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
                S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_0011_1100_0000;

//night
       B : if(cnt <= 500)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0001_1110_0100_0000_1011_0100;
           else if(cnt <= 600)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1110_0100_0000_1011_0100;
           else if(cnt <= 700)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0001_1110_0100_0000_1011_0100;
           else if(cnt <= 800)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1110_0100_0000_1011_0100;
           else if(cnt <= 900)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0001_1110_0100_0000_1011_0100;
           else if(cnt <= 1000)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1110_0100_0000_1011_0100;
       BtoA1 : if(cnt <= 100)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_0100_1011_0000;
       A1 : if(cnt <= 500)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000;
           else if(cnt <= 600)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1100_1100_0000_0011_0000;
           else if(cnt <= 700)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000;
           else if(cnt <= 800)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1100_1100_0000_0011_0000;
           else if(cnt <= 900)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000;
           else if(cnt <= 1000)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1100_1100_0000_0011_0000;
       A1toC : if(cnt <= 100)
           {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0010_1111_1000_0100_0011_0000;
       C : if(cnt <= 500)
           {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
          S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
          S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0010_1101_1000_0000_0111_1000;
          else if(cnt <= 600)
           {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
          S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
          S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1101_1000_0000_0111_1000;
          else if(cnt <= 700)
           {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
          S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
          S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0010_1101_1000_0000_0111_1000;
          else if(cnt <= 800)
           {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
          S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
          S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1101_1000_0000_0111_1000;
          else if(cnt <= 900)
           {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
          S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
          S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0010_1101_1000_0000_0111_1000;
          else if(cnt <= 1000)
           {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
          S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
          S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1101_1000_0000_0111_1000;
      CtoA2 : if(cnt <= 100)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
          S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
          S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_1000_0111_0000;
      A2 : if(cnt <= 500)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000;
           else if(cnt <= 600)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1100_1100_0000_0011_0000;
           else if(cnt <= 700)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000;
           else if(cnt <= 800)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1100_1100_0000_0011_0000;
           else if(cnt <= 900)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0011_1100_1100_0000_0011_0000;
           else if(cnt <= 1000)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1100_1100_0000_0011_0000;
       A2toE3 : if(cnt <= 100)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_1100_0011_0000;
       E3 : if(cnt <= 500)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1100_0011_0011_0000_1100_0000;
           else if(cnt <= 600)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0011_0011_0000_1100_0000;
           else if(cnt <= 700)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1100_0011_0011_0000_1100_0000;
           else if(cnt <= 800)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0011_0011_0000_1100_0000;
           else if(cnt <= 900)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b1100_0011_0011_0000_1100_0000;
           else if(cnt <= 1000)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_0011_0011_0000_1100_0000;
       E3toH : if(cnt <= 100)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_0011_1100_0000;
       H : if(cnt <= 1000)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_0000_1100_0011;
       HtoB : if(cnt <= 100)
          {S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED, 
           S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
           S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT} = 24'b0000_1111_0000_0000_1100_0000;
       endcase
   end
end                         
                         
                    
endmodule