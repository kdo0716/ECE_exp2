`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/14 23:26:28
// Design Name: 
// Module Name: decoder3x8
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


module decoder3x8(a, b, c, D);

input a, b, c;

output [7:0] D;

reg [7:0] D;

always @(a, b, c)
    case({a, b, c})
        3'b000 : D = 8'b00000001;
        3'b001 : D = 8'b00000010;
        3'b010 : D = 8'b00000100;
        3'b011 : D = 8'b00001000;
        3'b100 : D = 8'b00010000;
        3'b101 : D = 8'b00100000;
        3'b110 : D = 8'b01000000;
        default : D = 8'b10000000;
    endcase

endmodule
