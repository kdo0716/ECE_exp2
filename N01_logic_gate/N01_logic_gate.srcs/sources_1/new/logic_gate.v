`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/10 19:29:03
// Design Name: 
// Module Name: logic_gate
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


module logic_gate(a, b, x, y, z, p, q);

input a, b;

output x, y, z, p, q;

wire x, y, z, p, q;

//and gate
assign x = a & b;
//or gate
assign y = a | b;

//nor gate
assign p = ~(a | b);
//nand gate
assign q = ~(a & b);


//xor gate
assign z = a ^ b;
endmodule