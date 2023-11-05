`timescale 1ns / 1ps

module testbench();

reg clk, rst;
reg btn;
//reg [3:0] state_bin;
//wire [7:0] state_bcd;
wire [7:0] seg_data;
wire [7:0] seg_sel;
//reg [3:0] bcd;

seg_array tb(clk, rst, btn, seg_data, seg_sel);

initial begin
    clk <= 0;
    rst <= 1;
    btn <= 0;
    #10 rst <= 0;
    #10 rst <= 1;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    #35 btn <= 1;
    #35 btn <= 0;
    end

always begin 
    #5 clk <= ~clk;
end

endmodule
