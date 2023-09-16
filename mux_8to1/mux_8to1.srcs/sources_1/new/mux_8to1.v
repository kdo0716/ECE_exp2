`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 21:59:10
// Design Name: 
// Module Name: mux_8to1
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


module mux_8to1(I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2, Y);

output Y;
input [7:0] I0, I1, I2, I3, I4, I5, I6, I7;
input S0, S1, S2;

assign Y = S2 ? (S1 ? (S0 ? I7 : I6) : (S0 ? I5 : I4)) : (S1 ? (S0 ? I3 : I2) : (S0 ? I1 : I0));

endmodule
