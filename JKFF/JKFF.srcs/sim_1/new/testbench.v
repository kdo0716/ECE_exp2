`timescale 1ns / 1ps



module testbench();

reg clk;
reg [1:0] J, K;
wire Q;

JKFF tb(clk, J, K, Q);

initial begin //(2'b00 -> 2'b01 -> 2'b00 -> 2'b10 -> 2'b00 -> 2'b11 -> 2'b00)
    clk <= 0;
    #30 J <= 1'b0;
        K <= 1'b0;
    #30 J <= 1'b0;
        K <= 1'b1;
    #30 J <= 1'b0;
        K <= 1'b0;
    #30 J <= 1'b1;
        K <= 1'b0;
    #30 J <= 1'b0;
        K <= 1'b0;
    #30 J <= 1'b1;
        K <= 1'b1;
    #30 J <= 1'b0;
        K <= 1'b0;    
end

always begin
    #5 clk <= ~clk;
end
        
endmodule
