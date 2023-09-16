`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 01:16:47
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


module testbench();
//input
reg [3:0] i;
//output
wire [1:0] a;

priority_encoder4x2 tb(
    .i(i),
    .a(a)
);
// Specify input stimulus
initial begin
         i = 4'b0000;
    #10  i = 4'b1000;  
    #10  i = 4'b1011;
    #10  i = 4'b0101;
    #10  i = 4'b0001;
end
endmodule

