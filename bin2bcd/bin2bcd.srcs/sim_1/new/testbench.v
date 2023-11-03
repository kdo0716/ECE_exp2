`timescale 1ns / 1ps

module testbench();

reg clk, rst;
reg btn;
wire [7:0] seg_data;
wire [7:0] seg_sel;
reg [3:0] state_bin;
wire [7:0] state_bcd;

seg_array tb(clk, rst, btn, seg_data, seg_sel);

initial begin
    clk <= 0;
    rst <= 1;
    state_bin <= 4'b0000;
    #10 rst <= 0;
    #10 rst <= 1;
    #30 state_bin <= 4'b0001;
    #30 state_bin <= 4'b0010;
    #30 state_bin <= 4'b0011;
    #30 state_bin <= 4'b0100;
    #30 state_bin <= 4'b0101;
    #30 state_bin <= 4'b0110;
    #30 state_bin <= 4'b0111;
    #30 state_bin <= 4'b1000;
    #30 state_bin <= 4'b1001;
    #30 state_bin <= 4'b1010;
    #30 state_bin <= 4'b1011;
    #30 state_bin <= 4'b1100;
    #30 state_bin <= 4'b1101;
    #30 state_bin <= 4'b1110;
    #30 state_bin <= 4'b1111;
    #30 state_bin <= 4'b0001;
end

always begin 
    #5 clk <= ~clk;
end

endmodule
