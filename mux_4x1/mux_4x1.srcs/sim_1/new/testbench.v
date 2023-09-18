`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/18 09:19:45
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
// input
reg [3:0] I0, I1, I2, I3;
reg [1:0] S0, S1;
// output
wire [1:0] Y;

mux_4x1 tb(
    .I0(I0),
    .I1(I1),
    .I2(I2),
    .I3(I3),
    .S0(S0),
    .S1(S1),
    .Y(Y)
);

initial begin
    S0 = 1'b0; S1 = 1'b0;
    I0 = 2'b00; I1 = 2'b01; I2 = 2'b10; I3 = 2'b11;
    #10 S1 = 1'b0;
        S0 = 1'b0;
    #10 S1 = 1'b0;
        S0 = 1'b1;
    #10 S1 = 1'b1;
        S0 = 1'b0;
    #10 S1 = 1'b1;
        S0 = 1'b1;
    #10;
    $finish;
end
endmodule
