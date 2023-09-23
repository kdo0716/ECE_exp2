`timescale 1ns / 1ps


module testbench();

reg clk, rst, T;
wire Q;

TFF_oneshot tb(clk, rst, T, Q);

initial begin
    clk <= 0;
    rst <= 1;
    T <= 0;
    #10 rst <= 0;
    #10 rst <= 1;
    #80 T <= 1;
    #100 T <= 0;
    #80 T <= 1;
    #100 T <= 0;
    #80 T <= 1;
    #100 T <= 0;
end

always begin
    #5 clk <= ~clk;
end

endmodule
