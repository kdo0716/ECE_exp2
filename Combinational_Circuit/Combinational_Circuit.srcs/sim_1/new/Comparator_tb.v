`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/13 13:52:03
// Design Name: 
// Module Name: Comparator_tb
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


module Comparator_tb();

reg [7:0] a, b;
wire x, y, z;

Comparator tb(
    .a(a),
    .b(b),
    .x(x),
    .y(y),
    .z(z)
    );
    
 initial begin
 //a<b : z
 a = 4'b0011;
 b = 4'b1000;
 #10
 //a>b : x
 a = 4'b0111;
 b = 4'b0001;
 #10
 //a>b : x
 a = 4'b1001;
 b = 4'b0001;
 #10
 //a<b : z
 a = 4'b1011;
 b = 4'b1111;
 #10
 
 $finish;
 end
endmodule
