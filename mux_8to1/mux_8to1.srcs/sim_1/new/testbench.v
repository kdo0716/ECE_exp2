`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 22:21:53
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
reg [3:0] I0, I1, I2, I3, I4, I5, I6, I7;
reg [2:0] S0, S1, S2;
//output
wire [3:0] Y;

mux_8to1 tb(
    .I0(I0),
    .I1(I1),
    .I2(I2),
    .I3(I3),
    .I4(I4),
    .I5(I5),
    .I6(I6),
    .I7(I7),
    .S0(S0),
    .S1(S1),
    .S2(S2),
    .Y(Y)
);

initial begin
    S0 = 1'b0; S1 = 1'b0; S2 = 1'b0;
    I0 = 4'b0000; I1 = 4'b0001; I2 = 4'b0010; I3 = 4'b0011;
    I4 = 4'b0100; I5 = 4'b0101; I6 = 4'b0110; I7 = 4'b0111;
    #10 S2=1'b0;
        S1=1'b0;
        S0=1'b0;
    #10 S2=1'b0;
        S1=1'b0;
        S0=1'b1;
    #10 S2=1'b0;
        S1=1'b1;
        S0=1'b0;
    #10 S2=1'b0;
        S1=1'b1;
        S0=1'b1;
    #10 S2=1'b1;
        S1=1'b0;
        S0=1'b0;
    #10 S2=1'b1;
        S1=1'b0;
        S0=1'b1;
    #10 S2=1'b1;
        S1=1'b1;
        S0=1'b0;
    #10 S2=1'b1;
        S1=1'b1;
        S0=1'b1;
    #10;
$finish;
end     
endmodule
