`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/14 23:59:02
// Design Name: 
// Module Name: priority_encoder4x2
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


module priority_encoder4x2 (i, a);

    input [3:0] i;
    output [1:0] a;

reg [1:0] a;

always @(i)
begin
    if (i == 4'b0000) a = 2'b00;
    else if (i[3] == 1) a = 2'b11;
    else if (i[2] == 1) a = 2'b10;
    else if (i[1] == 1) a = 2'b01;
    else a = 2'b00;
end

endmodule


