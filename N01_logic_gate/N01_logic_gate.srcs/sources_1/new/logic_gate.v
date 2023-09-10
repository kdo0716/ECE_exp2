module logic_gate(a, b, x, y, z);

input a, b;

output v, w, x, y, z;

wire v, w, x, y, z;

//and gate
assign v = a & b;
//or gate
assign w = a | b;
//xor gate
assign x = a ^ b;
//nor gate
assign y = ~(a | b);
//nand gate
assign z = ~(a & b);

endmodule
