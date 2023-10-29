`timescale 1ns / 1ps

module testbench();

reg clk, rst, x;
wire [1:0] state;
wire y;

SM1 tb(clk, rst, x, y, state);

initial begin
    clk <= 0;
    rst <= 1;
    x <= 0;
    #5 rst <= 0;
    #5 rst <= 1;
    
    #80 x <= 1; // 00 input 1 -> 01 output 0 <4.1.1>
    #20 x <= 0; // 01 input 0 -> 00 output 1 <4.1.2>
/*    #20 x <= 1; // 00 input 1 -> 01 output 01 output 1
    #30 x <= 0; // 01 input
*/    
end

always begin
        #15 clk <= ~clk;
end

endmodule
