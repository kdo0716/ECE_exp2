`timescale 1ns / 1ps

module Clock(clk, rst);

input clk, rst;
reg [44:0] cnt_clock; //sec_1 (0~9):10, sec_10 (0~5):6, min_1 (0~9):10, min_10 (0~5):6, hour_1 (0~9):10, hour_10 (0~2):3 10+6+10+6+10+3=45
reg [5:0] sec_1, sec_10, min_1, min_10, hour_1, hour_10;

always @(posedge clk or negedge rst) begin
    cnt_clock = cnt_clock + 1; //1Hz with 1second
    
    if(!rst) begin
        cnt_clock = 0;
        sec_1 = sec_1 + 1;
        if(sec_1 > 9) begin
            sec_1 = 0;
            sec_10 = sec_10 + 1;
            if(sec_10 > 5) begin
                sec_10 = 0;
                min_1 = min_1 + 1;
                if(min_1 > 9) begin
                    min_1 = 0;
                    min_10 = min_10 + 1;
                    if(min_10 > 5) begin
                        min_10 = 0;
                        hour_1 = hour_1 + 1;
                        if(hour_1 > 9) begin
                            hour_1 = 0;
                            hour_10 = hour_10 + 1;
                            if(hour_10 == 2 && hour_1 > 3) begin
                                hour_10 = 0; hour_1 = 0;
                            end
                         end
                     end
                 end
              end
          end
      end    
end  

/* if (08:00<=cnt<23:00)
    day <= 1; */


    
endmodule
