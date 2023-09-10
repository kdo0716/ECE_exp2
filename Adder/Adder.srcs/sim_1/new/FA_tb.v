`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/10 21:42:22
// Design Name: 
// Module Name: FA_tb
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


module FA_tb();

reg [1:0] x, y, z;
wire s, c;

FA tb(
.x(x),
.y(y),
.z(z),
.s(s),
.c(c)
);

initial begin
x=1'b0;
y=1'b0;
z=1'b0;
#10;

x=1'b0;
y=1'b0;
z=1'b1;
#10;

x=1'b0;
y=1'b1;
z=1'b0;
#10;

x=1'b0;
y=1'b1;
z=1'b1;
#10;

x=1'b1;
y=1'b0;
z=1'b0;
#10;

x=1'b1;
y=1'b0;
z=1'b1;
#10;

x=1'b1;
y=1'b1;
z=1'b0;
#10;

x=1'b1;
y=1'b1;
z=1'b1;
#10;

$finish;
end
endmodule

