`timescale 1ns / 1ps
//week7 page5

module counter8(clk, rst, cnt, blink_cnt);

input clk, rst;
output reg [7:0] cnt;
output reg [7:0] blink_cnt;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt <= 8'd0000_0000;
        blink_cnt <= 8'd0000_0000;
    end
    else cnt <= cnt + 1;
         blink_cnt <= blink_cnt + 1;
end

endmodule
