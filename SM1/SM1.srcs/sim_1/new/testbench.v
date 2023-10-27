`timescale 1ns / 1ps

module testbench();

reg clk, rst, x;
wire [1:0] state;
wire y;

SM1 tb(clk, rst, x, y, state);

initial begin
    clk <= 0;
    rst <= 0;
    #5 rst <= 1;
    #5 rst <= 0;
    
    #30 x <= 1;
    #30 x <= 0;
    #30 x <= 1;
    #30 x <= 0;
    #30 x <= 1;
    #30 x <= 0;
    #30 x <= 1;
    #30 x <= 0;

end

always begin
        #5 clk <= ~clk;
end

endmodule
