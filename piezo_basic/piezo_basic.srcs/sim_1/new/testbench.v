`timescale 1us / 1ns //time unit 1ns / 1ps => 1us / 1ns

module testbench();

reg clk, rst;
reg [7:0] btn;
wire piezo;

testbench piezo_basic(clk, rst, btn, piezo);

initial begin
    clk <= 0;
    rst <= 1;
    btn <= 8'b00000000;
    #1e+6; rst <= 0; //1MHz
    #1e+6; rst <= 1;
    #1e+6; btn <= 8'b00000001; //do
    #1e+6; btn <= 8'b00000010; //re
/*  #1e+6; btn <= 8'b00000100; //mi
    #1e+6; btn <= 8'b00001000; //fa
    #1e+6; btn <= 8'b00010000; //sol
    #1e+6; btn <= 8'b00100000; //la
    #1e+6; btn <= 8'b01000000; //ssi
    #1e+6; btn <= 8'b10000000; //do */
end

always begin
    #0.5 clk <= ~clk;
end

endmodule
