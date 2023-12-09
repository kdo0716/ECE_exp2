`timescale 1ns / 1ps

 

module traffic_light(clk, rst, btn, scale10, scale100, scale200, EMERGENCY,

                    s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                    s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l,

                    LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out);                  

 

input clk, rst;

input btn; //plus one hour button

input scale10, scale100, scale200; //time speed x10, x100, x200

input EMERGENCY; //EMERGENCY

 

output reg s_w_g, n_w_g, w_w_g, e_w_g; // walk green

output reg s_w_r, n_w_r, w_w_r, e_w_r; // walk red

output reg s_g, n_g, w_g, e_g; // car green

output reg s_y, n_y, w_y, e_y; // car yellow

output reg s_r, n_r, w_r, e_r; // car red

output reg s_l, n_l, w_l, e_l; // car left

 

output LCD_E;

output reg LCD_RS, LCD_RW;

output reg [7:0] LCD_DATA;

output reg [7:0] LED_out;

 

reg [4:0] state; //state for basic traffic signal

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

   

integer cnt; //counter for basic traffic signal

integer cnt_LCD;

reg x = 0;

 

reg DAY;

integer cnt_speed; //counter for time speed x10, x100, x200

 

reg [2:0] L_state; //state for LCD

parameter DELAY = 3'b000,

          FUNCTION_SET = 3'b001,

          DISP_ONOFF = 3'b010,

          ENTRY_MODE = 3'b011,

          LINE1 = 3'b100,

          LINE2 = 3'b101,

          DELAY_T = 3'b110,

          CLEAR_DISP = 3'b111;

 

reg [3:0] hour_10, hour_1, min_10, min_1, sec_10, sec_1;

 

reg [4:0] state_now;

reg [3:0] state_s; //restore state for LCD state

reg [9:0] s4, s3, s2, s1, s0;

 

reg btn_reg;

reg btn_trig;

 

//oneshot module

always @(posedge clk or negedge rst) begin

    if(!rst) begin

        btn_reg <= 0;

        btn_trig <= 0;

    end

    else begin

        btn_reg <= btn;

        btn_trig <= btn & ~btn_reg;

    end

end

 

//EMERGENCY oneshot

reg EMERGENCY_reg;

reg EMERGENCY_t;

always @(posedge clk or negedge rst) begin

    if(!rst) begin

        EMERGENCY_reg <= 0;

        EMERGENCY_t <= 0;

    end

    else begin

        EMERGENCY_reg <= EMERGENCY;

        EMERGENCY_t <= EMERGENCY & ~EMERGENCY_reg;

    end

end

 

//time speed x10, x100, x200

always @(posedge clk or negedge rst) begin

   if(!rst) begin //reset valiables

      sec_1 <= 0;

      sec_10 <= 0;

      min_1 <= 0;

      min_10 <= 0;

      hour_1 <= 0;

      hour_10 <= 0;

   end

   else begin

     if(scale10) begin         //time speed x10

        if(cnt_speed >= 89) begin //89, because LCD is erased every second

            sec_1 = sec_1 + 1;

            cnt_speed = 0;

        end

        else begin

            cnt_speed = cnt_speed + 10; //x10

        end

     end                      

     else if(scale100)          //time speed x100

            sec_1 = sec_1 + 1;

     else if(scale200)          //time speed x200

            sec_1 = sec_1 + 2;

     else begin

        if(cnt_speed >= 99) begin  

            sec_1 = sec_1 + 1;

            cnt_speed = 0;

        end

        else begin

            cnt_speed = cnt_speed + 1;

        end

     end

   

//clock    

      if(btn_trig) begin

        if((hour_10 != 2) && (hour_1 == 9)) begin

            hour_10 = hour_10 + 1;

            hour_1 = 0;

        end

        else if((hour_10 == 2) && (hour_1 >= 3)) begin

            hour_10 = 0;

            hour_1 = 0;

        end

        else hour_1 = hour_1 + 1;

      end

      else begin

      if(sec_1 >= 10) begin

         sec_10 = sec_10 + 1;

         sec_1 = 0;

      end

      if(sec_10 == 6) begin

         min_1 = min_1 + 1;

         sec_10 = 0;

      if(min_1 == 10) begin

         min_10  = min_10 + 1;

         min_1 = 0;

      end

      if(min_10 == 6) begin

         hour_1 = hour_1 + 1;

         min_10 = 0;

      end

        if((hour_10 == 3) || (hour_10 == 2) && ((hour_1 >= 4) && (hour_1 <10))) begin // day changing time 23:59->00:00

            hour_1 = 0;

            hour_10 = 0;

        end

        else if (hour_1 == 10) begin

            hour_10 = hour_10 + 1;

            hour_1 = 0;

        end

   end

end

end

end

     

//define day time(08:00~23:00), night time(23:00~8:00)    

always @(posedge clk or negedge rst) begin

   if(!rst) begin

   DAY <= 0;

   end

   else begin

      if((hour_10 == 0 && hour_1 >= 8) || (hour_10 == 1 && hour_1 <= 9) || (hour_10 == 2 && hour_1 < 3)) // DAY : 8~23 //here

      DAY <= 1;

      else                                                                                                // NIGHT : 23~7

      DAY <= 0;

   end

end

 

//EMERGENCY & time speed                  

always @(posedge clk or negedge rst) begin

    if(!rst) begin

        state <= A;

        cnt <= 0;

    end

    else if(EMERGENCY_t || x) begin

        state <= (cnt >= 1600) ? state_now : ((cnt >= 100 && x == 1) ? A : state_now); //here
        if(cnt >= 1600) cnt <= 0; //after 1+15seconds

            else if(!x)

                cnt <= 0;

                else if(x) begin

                    if(scale10) cnt <= cnt + 10; //time speed x10

                    else if(scale100) cnt <= cnt + 100; //time speed x100

                    else if(scale200) cnt <= cnt + 200; //time speed x200

                    else cnt <= cnt + 1;

                 end      

        x <= (cnt >= 1600) ? 0 : 1;

    end  

    else begin

        state_now <= state; //restore present state to comeback after 15seconds

        if(DAY) begin //make possible to speed up (x10, x100, x200) for every states

            case(state)

                A : if(cnt >= 500) begin

                        state <= AtoD;

                        cnt <= 0;

                    end

                    else if(scale10) cnt <= cnt + 10;

                    else if(scale100) cnt <= cnt + 100;

                    else if(scale200) cnt <= cnt + 200;

                    else cnt <= cnt + 1; // green/red light 5s

                AtoD : if(cnt >= 100) begin

                            state <= D;

                            cnt <= 0;

                        end

                        else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;// yellow light 1s

                D : if(cnt >= 500) begin

                        state <= DtoF;

                        cnt <= 0;

                    end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                   

                DtoF : if(cnt >= 100) begin

                            state <= F;

                            cnt <= 0;

                        end

                        else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                F : if(cnt >= 500) begin

                        state <= FtoE1;

                        cnt <= 0;

                    end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                   

                FtoE1 : if(cnt >= 100) begin

                            state <= E1;

                            cnt <= 0;

                        end

                        else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                E1 : if(cnt >= 500) begin

                            state <= E1toG;

                            cnt <= 0;

                      end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                     

                E1toG : if(cnt >= 100) begin

                            state <= G;

                            cnt <= 0;

                        end

                        else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                G : if(cnt >= 500) begin

                        state <= GtoE2;

                        cnt <= 0;

                    end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                   

                GtoE2 : if(cnt >= 100) begin

                            state <= E2;

                            cnt <= 0;

                        end

                        else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                E2 : if(cnt >= 500) begin

                        state <= E2toA;

                        cnt <= 0;

                     end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;                  

                E2toA : if(cnt >= 100) begin

                         state <= A;

                        end

                        else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                default : begin

                            state <= A;

                         if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                    end              

           endcase

        end

        else if(!DAY) begin

            case(state)

                B : if(cnt >= 1000) begin

                        state <= BtoA1;

                        cnt <= 0;

                     end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;  // green/red light 10s

                BtoA1 : if(cnt >= 200) begin

                            state <= A1;

                            cnt <= 0;

                         end

                         else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1; // yellow light 1s

                A1 : if(cnt >= 1000) begin

                            state <= A1toC;

                            cnt <= 0;

                      end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                A1toC : if(cnt >= 200) begin

                            state <= C;

                            cnt <= 0;

                         end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;                        

                C : if(cnt >= 1000) begin

                        state <= CtoA2;

                        cnt <= 0;

                    end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;                  

                CtoA2 : if(cnt >= 200) begin

                            state <= A2;

                            cnt <= 0;

                        end

                        else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                A2 : if(cnt >= 1000) begin

                        state <= A2toE3;

                        cnt <= 0;

                     end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;                  

                A2toE3 : if(cnt >= 200) begin

                            state <= E3;

                            cnt <= 0;

                         end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;                        

                E3 : if(cnt >= 1000) begin

                        state <= E3toH;

                        cnt <= 0;

                     end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                E3toH : if(cnt >= 200) begin

                            state <= H;

                            cnt <= 0;

                         end

                         else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                H : if(cnt >= 1000) begin

                            state <= HtoB;

                            cnt <= 0;

                    end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;

                HtoB : if(cnt >= 200) begin

                        state <= B;

                        cnt <= 0;

                       end else if(scale10) cnt <= cnt + 10;

                        else if(scale100) cnt <= cnt + 100;

                        else if(scale200) cnt <= cnt + 200;

                        else cnt <= cnt + 1;                    

                default : begin

                            state <= B;

                           if(scale10) cnt <= cnt + 10;

                            else if(scale100) cnt <= cnt + 100;

                            else if(scale200) cnt <= cnt + 200;

                            else cnt <= cnt + 1;

                    end      

            endcase

        end

    end

end          

 

//define basic traffic_light signal

always @(posedge clk or negedge rst) begin

    if(!rst)

        {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

        s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000; // A

      else begin

        case(state)

            A : if(cnt <= 250)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000;

                else if(cnt <= 300)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1100_1100_0000_0011_0000; // blink off

                else if(cnt <= 350)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000; // blink on

                else if(cnt <= 400)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1100_1100_0000_0011_0000; // blink off

                else if(cnt <= 350)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000; // blink on

                else if(cnt <= 400)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1100_1100_0000_0011_0000; // blink off

                else if(cnt <= 450)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000; // blink off

                else if(cnt <= 490)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1100_1100_0000_0011_0000; // blink off
                else if(cnt <= 500)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000; // blink on

           AtoD : if(cnt <= 50)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_0000_1100_0011_0000;

                else if(cnt <= 100)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1100_0000_1100_0011_0000;              

           D : if(cnt <= 500)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

               s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1111_0000_0000_0011_1100;  // no blinking        

           DtoF : if(cnt <= 100)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1111_0000_1100_0011_0000;

           F : if(cnt <= 500)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

               s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0100_1011_0010_0000_1101_0010; // no blinking

           FtoE1 : if(cnt <= 100)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0100_1011_0000_0010_1101_0010;

           E1 : if(cnt <= 250)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0011_0000_1100_0000;

                else if(cnt <= 300)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1000_0011_0011_0000_1100_0000; // blink off

                else if(cnt <= 350)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0011_0000_1100_0000; // blink on

                else if(cnt <= 400)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1000_0011_0011_0000_1100_0000; // blink off

                else if(cnt <= 450)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0011_0000_1100_0000; // blink on

                else if(cnt <= 500)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1000_0011_0011_0000_1100_0000; // blink off              

           E1toG : if(cnt <= 50)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0001_0010_1100_0000;

                else if(cnt <= 100)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1000_0011_0001_0010_1100_0000;

           G : if(cnt <= 500)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1000_0111_0001_0000_1110_0001;

           GtoE2 : if(cnt <= 100)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1000_0111_0001_0001_1110_0001;

           E2 : if(cnt <= 250)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0011_0000_1100_0000;

                else if(cnt <= 300)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_0011_0011_0000_1100_0000; // blink off

                else if(cnt <= 350)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0011_0000_1100_0000; // blink on

                else if(cnt <= 400)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_0011_0011_0000_1100_0000; // blink off

                else if(cnt <= 450)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0011_0000_1100_0000; // blink on

                else if(cnt <= 500)

                {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_0011_0011_0000_1100_0000; // blink off

           E2toA : if(cnt <= 50)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0000_0011_1100_0000;

                else if(cnt <= 100)

               {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_0011_0000_0011_1100_0000;

               

 

//night

       B : if(cnt <= 1000)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0001_1110_0100_0000_1011_0100;

       BtoA1 : if(cnt <= 200)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0001_1110_0100_0100_1011_0000;

       A1 : if(cnt <= 500)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000;

           else if(cnt <= 600)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0010_1100_1100_0000_0011_0000;

           else if(cnt <= 700)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000;

           else if(cnt <= 800)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0010_1100_1100_0000_0011_0000;

           else if(cnt <= 900)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000;

           else if(cnt <= 1000)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0010_1100_1100_0000_0011_0000;

       A1toC : if(cnt <= 100)

           {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1000_0100_0011_0000;

            else if(cnt <= 200)

            {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0010_1100_1000_0100_0011_0000;  

       C : if(cnt <= 1000)

           {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0010_1101_1000_0000_0111_1000;

      CtoA2 : if(cnt <= 200)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0010_1101_1000_1000_0111_0000;

      A2 : if(cnt <= 500)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000;

           else if(cnt <= 600)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1100_1100_0000_0011_0000;

           else if(cnt <= 700)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000;

           else if(cnt <= 800)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1100_1100_0000_0011_0000;

           else if(cnt <= 900)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_1100_0000_0011_0000;

           else if(cnt <= 1000)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1100_1100_0000_0011_0000;

       A2toE3 : if(cnt <= 100)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0011_1100_0000_1100_0011_0000;

            else if(cnt <= 200)

           {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1100_0000_1100_0011_0000;

       E3 : if(cnt <= 500)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0011_0000_1100_0000;

           else if(cnt <= 600)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_0011_0011_0000_1100_0000;

           else if(cnt <= 700)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0011_0000_1100_0000;

           else if(cnt <= 800)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_0011_0011_0000_1100_0000;

           else if(cnt <= 900)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0011_0000_1100_0000;

           else if(cnt <= 1000)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_0011_0011_0000_1100_0000;

       E3toH : if(cnt <= 100)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b1100_0011_0000_0011_1100_0000;

            else if(cnt <= 200)

           {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_0011_0000_0011_1100_0000;

       H : if(cnt <= 1000)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1111_0000_0000_1100_0011;

       HtoB : if(cnt <= 200)

          {s_w_g, n_w_g, w_w_g, e_w_g, s_w_r, n_w_r, w_w_r, e_w_r,

                s_g, n_g, w_g, e_g, s_y, n_y, w_y, e_y, s_r, n_r, w_r, e_r, s_l, n_l, w_l, e_l} = 24'b0000_1111_0000_0011_1100_0000;

       endcase

   end

end

 

//LCD CLOCK BEGIN //

always @(posedge clk or negedge rst) begin

if(!rst) state_s <= 4'b0000;

else begin

    if((state == 5'b00000) || (state == 5'b01110) || (state == 5'b10010)) //(A or A1 or A2)

        state_s <= 4'b0001; //A

    else if(state == 5'b01100)

        state_s <= 4'b0010; //B

    else if(state == 5'b10000)

        state_s <= 4'b0011; //C

    else if(state == 5'b00010)

        state_s <= 4'b0100; //D

    else if((state == 5'b00110) || (state == 5'b01010) || (state == 5'b10100)) //(E1 or E2 or E3)

        state_s <= 4'b0101; //E

    else if(state == 5'b00100)

        state_s <= 4'b0110; //F

    else if(state == 5'b01000)

        state_s <= 4'b0111; //G

    else if(state == 5'b10110)

        state_s <= 4'b1000; //H

    end

end

 

always @(posedge clk or negedge rst) begin //to visible LCD state(day) or state(night)

if(!rst) begin

    s4 <= 10'b0_0_1000_0000;

    s3 <= 10'b0_0_1000_0000;

    s2 <= 10'b0_0_1000_0000;

    s1 <= 10'b0_0_1000_0000;

    s0 <= 10'b0_0_1000_0000;

end

else begin

    if(DAY) begin //day

        s4 <= 10'b1_0_0010_0000; //

        s3 <= 10'b1_0_0110_0100; // d

        s2 <= 10'b1_0_0110_0001; // a

        s1 <= 10'b1_0_0111_1001; // y

        s0 <= 10'b1_0_0010_0000; //

    end

    else if(!DAY) begin

        s4 <= 10'b1_0_0110_1110; // n

        s3 <= 10'b1_0_0110_1001; // i

        s2 <= 10'b1_0_0110_0111; // g

        s1 <= 10'b1_0_0110_1000; // h

        s0 <= 10'b1_0_0111_0100; // t

    end

end

end

//LCD basic          

always @(posedge clk or negedge rst) begin

   if(!rst) L_state = DELAY;

   else begin

      case(L_state)

        DELAY : begin

            LED_out = 8'b1000_0000;

            if(cnt_LCD == 69) L_state = FUNCTION_SET;

        end

        FUNCTION_SET : begin

            LED_out = 8'b0100_0000;

            if(cnt_LCD == 9) L_state = DISP_ONOFF;

        end

        DISP_ONOFF : begin

           LED_out = 8'b0010_0000;

           if(cnt_LCD == 9) L_state = ENTRY_MODE;

        end

           ENTRY_MODE : begin

           LED_out = 8'b0001_0000;

        if(cnt_LCD == 9) L_state = LINE1;

        end

           LINE1 : begin

           LED_out = 8'b0000_1000;

        if(cnt_LCD == 29) L_state = LINE2;

        end

           LINE2 : begin

           LED_out = 8'b0000_0100;

        if(cnt_LCD == 29) L_state = DELAY_T;

        end

           DELAY_T : begin

           LED_out = 8'b0000_0010;

        if(cnt_LCD == 34) L_state = CLEAR_DISP;

        end

        CLEAR_DISP : begin

           LED_out = 8'b0000_0001;

           if(cnt_LCD == 4) L_state = LINE1;

        end

        default : L_state = DELAY;

        endcase

   end

end

 

always @(posedge clk or negedge rst)

   begin

      if(!rst) cnt_LCD = 0;

   else begin

      case(L_state)

         DELAY :

            if(cnt_LCD >= 69) cnt_LCD = 0;

            else cnt_LCD = cnt_LCD + 1;

         FUNCTION_SET :

            if(cnt_LCD>= 9) cnt_LCD = 0;

            else cnt_LCD = cnt_LCD + 1;

         DISP_ONOFF :

            if(cnt_LCD >= 9) cnt_LCD = 0;

            else cnt_LCD = cnt_LCD + 1;

         ENTRY_MODE :

            if(cnt_LCD >= 9) cnt_LCD = 0;

            else cnt_LCD = cnt_LCD + 1;

         LINE1 :

            if(cnt_LCD >= 29) cnt_LCD = 0;

            else cnt_LCD = cnt_LCD + 1;

         LINE2 :

            if(cnt_LCD >= 29) cnt_LCD = 0;

            else cnt_LCD = cnt_LCD + 1;

         DELAY_T :

            if(cnt_LCD >= 34) cnt_LCD = 0;

            else cnt_LCD = cnt_LCD + 1;

         CLEAR_DISP :

            if(cnt_LCD >= 4) cnt_LCD = 0;

            else cnt_LCD = cnt_LCD + 1;

         default : L_state = DELAY;

      endcase

   end

end

 

 

//text

always @(posedge clk or negedge rst) begin

   if(!rst)

      {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000;

   else begin

      case(L_state)

         FUNCTION_SET :

            {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000;

         DISP_ONOFF :

            {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100;

         ENTRY_MODE :

            {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110;  

LINE1 :                                                       //text LCD LINE1 (Time : xx:xx:xx)

   begin

      case(cnt_LCD)

         00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000;

         01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100; // T

         02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1001; // i

         03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1101; // m

         04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0101; // e

         05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //

         06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :

         07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //

         08 : begin                                          // hour_10

         {LCD_RS, LCD_RW} = 2'b10;

         LCD_DATA = 8'b0011_0000 + hour_10;                  

         end

         09 : begin                                          // hour_1

         {LCD_RS, LCD_RW} = 2'b10;

         LCD_DATA = 8'b0011_0000 + hour_1;

         end

         10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :

         11 : begin                                          // min_10

         {LCD_RS, LCD_RW} = 2'b10;

         LCD_DATA = 8'b0011_0000 + min_10;

         end

         12 : begin                                          // min_1

         {LCD_RS, LCD_RW} = 2'b10;

         LCD_DATA = 8'b0011_0000 + min_1;

         end

         13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :

         14 : begin                                          // sec_10

         {LCD_RS, LCD_RW} = 2'b10;

         LCD_DATA = 8'b0011_0000 + sec_10;

         end

         15 : begin                                          // sec_1

         {LCD_RS, LCD_RW} = 2'b10;

         LCD_DATA = 8'b0011_0000 + sec_1;

         end

         16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //

         default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //

      endcase

   end

LINE2 : case(cnt_LCD)                                                   //text LCD LINE2 (State : @ (day/night) )

                00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000;

                01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //

                02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0011; // S

                03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0100; // t

                04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0001; // a

                05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0100; // t

                06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0101; // e

                07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //

                08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :

                09 : begin                                          // sec_10

                    {LCD_RS, LCD_RW} = 2'b10;

                    LCD_DATA = 8'b0100_0000 + state_s;   //print one among ABCDEFGH

                end

                10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1000; // (

                11 : {LCD_RS, LCD_RW, LCD_DATA} = s4; //    n

                12 : {LCD_RS, LCD_RW, LCD_DATA} = s3; //d   i

                13 : {LCD_RS, LCD_RW, LCD_DATA} = s2; //a   g

                14 : {LCD_RS, LCD_RW, LCD_DATA} = s1; //y   h

                15 : {LCD_RS, LCD_RW, LCD_DATA} = s0; //    t        day or night

                16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1001; // )

                default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //

            endcase

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