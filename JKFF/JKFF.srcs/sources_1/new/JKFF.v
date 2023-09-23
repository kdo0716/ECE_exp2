`timescale 1ns / 1ps


module JKFF(clk, J, K, Q);

input J, K, clk;
output reg Q;

always @(posedge clk)
begin
    case ({J, K})
    2'b00: begin
    Q <= Q; //No change
    end
    2'b01: begin
    Q <= 0; //Reset
    end
    2'b10: begin
    Q <= 1; //Set
    end
    2'b11: begin
    Q <= ~Q; //Complement(toggle)
    end
    endcase
end

endmodule
