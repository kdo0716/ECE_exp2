`timescale 1ns / 1ps
//page 6

module seg_btn(clk, rst, btn, seg);

input clk, rst;
input [9:0] btn;
wire [9:0] btn_trig;
reg [3:0] state;
output reg [7:0] state;

/*
oneshot_universal #(.WIDTH(10)) 01(clk, rst, btn[9:0], btn_trig[9:0]);
*/
endmodule