`timescale 1ns / 1ps

module testbench();

reg clk, rst;

wire S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED,
                     S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                     S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT;
integer cnt;
                     
traffic_light tb(rst, clk, S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN, S_W_RED, N_W_RED, W_W_RED, E_W_RED,
                     S_GREEN, N_GREEN, W_GREEN, E_GREEN, S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,
                     S_RED, N_RED, W_RED, E_RED, S_LEFT, N_LEFT, W_LEFT, E_LEFT);
                     
initial begin
    clk <= 0;
    rst <= 1;
    #5 rst <= 0;
    #5 rst <= 1;
    end
    
always begin
    #0.01 clk <= ~clk; //#100Hz
end


endmodule
