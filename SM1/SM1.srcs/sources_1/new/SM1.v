`timescale 1ns / 1ps

module SM1(clk, rst, x, y, state);

input clk, rst, x;
output reg [1:0] state;
output reg y;

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

always @(negedge rst or posedge clk) begin
    if(!rst) state <= S0;
    else begin
        case(state)
            S0: state <= x ? 2'b01 : 2'b00;
            S1: state <= x ? 2'b11 : 2'b00;
            S2: state <= x ? 2'b10 : 2'b00;
            S3: state <= x ? 2'b10 : 2'b00;
        endcase
    end
end
always @(negedge rst or posedge clk) begin
    if(!rst) y <= 0;
    else begin
        case(state)
            S0: y <= 1'b0;
            S1: y <= x ? 1'b0 : 1'b1;
            S2: y <= x ? 1'b0 : 1'b1;
            S3: y <= x ? 1'b0 : 1'b1;
        endcase
    end
end
endmodule

/*기본코드
module SM1(clk, rst, x, y, state);

input clk, rst, x;
output reg [1:0] state;
output reg y;

always @(negedge rst or posedge clk) begin
    if(!rst) state <= 2'b00;
    else if(state == 2'b00 && x == 1'b0) {state,y} <= 3'b000;
    else if(state == 2'b00 && x == 1'b1) {state,y} <= 3'b010;
    else if(state == 2'b01 && x == 1'b0) {state,y} <= 3'b001;
    else if(state == 2'b01 && x == 1'b1) {state,y} <= 3'b110;
    else if(state == 2'b10 && x == 1'b0) {state,y} <= 3'b001;
    else if(state == 2'b10 && x == 1'b1) {state,y} <= 3'b100;
    else if(state == 2'b11 && x == 1'b0) {state,y} <= 3'b001;
    else if(state == 2'b11 && x == 1'b1) {state,y} <= 3'b100;
end
    
endmodule
*/
/*삼항 연산자 코드
module SM1(clk, rst, x, y, state);

input clk, rst, x;
output reg [1:0] state;
output reg y;

always @(negedge rst or posedge clk) begin
    if(!rst) state <= 2'b00;
    else begin
        if      (state == 2'b00) {state,y} <= x ? 3'b010 : 3'b000;
        else if(state == 2'b01) {state,y} <= x ? 3'b110 : 3'b001;
        else if(state == 2'b10) {state,y} <= x ? 3'b100 : 3'b001;
        else if(state == 2'b11) {state,y} <= x ? 3'b100 : 3'b001;
    end
end

endmodule
*/
/* case문 이용
module SM1(clk, rst, x, y, state);

input clk, rst, x;
output reg [1:0] state;
output reg y;

always @(negedge rst or posedge clk) begin
    if(!rst) state <= 2'b00;
    else begin
        case(state)
            2'b00: {state,y} <= x ? 3'b010 : 3'b000;
            2'b01: {state,y} <= x ? 3'b110 : 3'b001;
            2'b10: {state,y} <= x ? 3'b100 : 3'b001;
            2'b11: {state,y} <= x ? 3'b100 : 3'b001;
        endcase
    end
end

endmodule
*/