`timescale 1ns / 1ps

module testbench();

reg clk, rst;
reg [3:0] bin;
wire [7:0] bcd;

bin2bcd tb(clk, rst, bin, bcd);

initial begin
    clk <= 0;
    rst <= 1;
    bin <= 4'b0000;
    #10 rst <= 0;
    #10 rst <= 1;
    #30 bin <= 4'b0001;
    #30 bin <= 4'b0010;
    #30 bin <= 4'b0011;
    #30 bin <= 4'b0100;
    #30 bin <= 4'b0101;
    #30 bin <= 4'b0110;
    #30 bin <= 4'b0111;
    #30 bin <= 4'b1000;
    #30 bin <= 4'b1001;
    #30 bin <= 4'b1010;
    #30 bin <= 4'b1011;
    #30 bin <= 4'b1100;
    #30 bin <= 4'b1101;
    #30 bin <= 4'b1110;
    #30 bin <= 4'b1111;
    #30 bin <= 4'b0001;
end

always begin 
    #5 clk <= ~clk;
end

endmodule
