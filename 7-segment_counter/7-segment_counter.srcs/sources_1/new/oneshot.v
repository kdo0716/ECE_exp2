`timescale 1ns / 1ps
//upcounter of 7-segment from 0 to 9 when you push the button
//if i push the button at number 9, it will start from 0 again
//sub module
module oneshot(clk, rst, btn, btn_trig);

input clk, rst,btn;
reg btn_reg;
output reg btn_trig;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        btn_reg <= 0;
        btn_trig <= 0;
    end
    else begin
        btn_reg <= btn;
        btn_trig <= btn & ~btn_reg;
    end
end

endmodule

