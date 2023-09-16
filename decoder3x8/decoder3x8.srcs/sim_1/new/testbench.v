`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/14 23:33:51
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 10ns / 100ps

module testbench();
// input
reg a, b, c;
//output
wire [7:0] D;
// Instantiate the U1
decoder3x8 u1(a, b, c, D);
// Specify input stimulus
initial begin
        a = 0; b = 0; c = 0;
    #10 a = 0; b = 0; c = 1;
    #10 a = 0; b = 1; c = 0;
    #10 a = 0; b = 1; c = 1;
    #10 a = 1; b = 0; c = 0;
    #10 a = 1; b = 0; c = 1;
    #10 a = 1; b = 1; c = 0;
    #10 a = 1; b = 1; c = 1;
    #10 a = 0; b = 0; c = 0;
end
endmodule
