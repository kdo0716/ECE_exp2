module bin2bcd(clk, rst, led_out, bcd_out);

input clk, rst;
input [7:0] led_out;
reg [11:0] bcd;
output reg [11:0] bcd_out;

reg [2:0] i;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        bcd <= {4'd0, 4'd0, 4'd0};
        i <= 0;
     end
     else begin
        if(i==0) begin
            bcd[11:1] <= 11'b0000_0000_000;
            bcd[0] <= led_out[7];
            end
            else begin
            bcd[11:9] <= (bcd[11:8] >= 3'd5) ? bcd[11:8] + 2'd3 : bcd[11:8];
            bcd[8:5] <= (bcd[7:4] >= 3'd5) ? bcd[7:4] + 2'd3 : bcd[7:4];
            bcd[4:1] <= (bcd[3:0] >= 3'd5) ? bcd[3:0] + 2'd3 : bcd[3:0];
            bcd[0] <= led_out[7-i];
         end
         i <= i+1;
         end
      end
      
      always @(negedge rst or posedge clk) begin
        if(!rst) bcd_out <= {4'd0, 4'd0, 4'd0};
        else if(i==0) bcd_out <= bcd;
        end
        
     endmodule