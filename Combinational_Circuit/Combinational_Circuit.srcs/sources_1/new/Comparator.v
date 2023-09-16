`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/13 13:32:41
// Design Name: 
// Module Name: Comparator
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


module Comparator(a, b, x, y, z);

input [3:0] a, b;

output x, y, z;

wire x, y, z;

// x : A>B case
assign x = (a > b) ? 1'b1 : 1'b0;

// y : A=B case
assign y = (a == b) ? 1'b1 : 1'b0;

// z : A<B case
assign z = (a < b) ? 1'b1 : 1'b0;

endmodule
