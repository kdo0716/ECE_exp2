module FA(x, y, z, c, s);

input x, y, z;
output c, s;

wire s1, c1, c2;

HA u1(x, y, s1, c1);
HA u2(z, s1, s, c2);

assign c = c1 | c2;


endmodule
