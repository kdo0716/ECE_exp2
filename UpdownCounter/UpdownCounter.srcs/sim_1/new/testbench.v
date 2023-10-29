`timescale 1ns / 1ps

module testbench();

reg clk, rst;
reg x;
wire [2:0] state;

UpdownCounter tb(clk, rst, x, state);

initial begin
    clk <= 0;
    rst <= 1;
    x <= 0;
    #10 rst <= 0;
    #10 rst <= 1; // 0001/0
//Up
    #20 x <= 1; // 0001/1 -> 0011
    #20 x <= 0; // 0011/0 -> 0011
    #20 x <= 1; // 0011/1 -> 0101
    #20 x <= 0; // 0101/0 -> 0101
    #20 x <= 1; // 0101/1 -> 0111
    #20 x <= 0; // 0111/0 -> 0111
    #20 x <= 1; // 0111/1 -> 1001
    #20 x <= 0; // 1001/0 -> 1001
    #20 x <= 1; // 1001/1 -> 1011
    #20 x <= 0; // 1011/0 -> 1011
    #20 x <= 1; // 1011/1 -> 1101
    #20 x <= 0; // 1101/0 -> 1101
    #20 x <= 1; // 1101/1 -> 1111
    #20 x <= 0; // 1111/0 -> 1111
    #20 x <= 1; // 1111/1 -> 0000
    #20 x <= 0; // 0001/0 -> 0000 
//Down    
    #20 x <= 1; // 0000/1 -> 1110
    #20 x <= 0; // 1110/0 -> 1110
    #20 x <= 1; // 1110/1 -> 1100
    #20 x <= 0; // 1100/0 -> 1100
    #20 x <= 1; // 1100/1 -> 1010
    #20 x <= 0; // 1010/0 -> 1010
    #20 x <= 1; // 1010/1 -> 1000
    #20 x <= 0; // 1000/0 -> 1000
    #20 x <= 1; // 1000/1 -> 0110
    #20 x <= 0; // 0110/0 -> 0110
    #20 x <= 1; // 0110/1 -> 0100
    #20 x <= 0; // 0100/0 -> 0100
    #20 x <= 1; // 0100/1 -> 0010
    #20 x <= 0; // 0010/0 -> 0010
    #20 x <= 1; // 0010/1 -> 0000
    #20 x <= 0; // 0000/0 -> 0001
    //�ٽ� Up
    #20 x <= 1; //0001/1 -> 0011
    #20 x <= 0; //0011/0 -> 0011
end

always begin
    #5 clk <= ~clk;
end

endmodule
