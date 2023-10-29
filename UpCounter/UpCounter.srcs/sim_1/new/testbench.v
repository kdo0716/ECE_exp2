`timescale 1ns / 1ps

module testbench();

reg clk, rst;
reg x;
wire [1:0] state;

UpCounter tb(clk, rst, x, state);

initial begin
    clk <= 0;
    rst <= 1;
    x <= 0;
    #10 rst <= 0;
    #10 rst <= 1; // 00/0
    #50 x <= 1; // 00/1 -> 01
    #50 x <= 0; // 01/0 -> 01
    #50 x <= 1; // 01/1 -> 10
    #50 x <= 0; // 10/0 -> 10
    #50 x <= 1; // 10/1 -> 11
    #50 x <= 0; // 11/0 -> 11 
    #50 x <= 1; // 11/1 -> 00
    #50 x <= 0;
end

always begin
    #5 clk <= ~clk;
end

endmodule
