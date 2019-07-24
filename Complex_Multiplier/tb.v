`timescale 1ns/1ps
module tb;
reg [3:0] a, b, c, d;
wire [8:0] out_real;
wire [8:0] out_im;
top U1(.a(a),.b(b),.c(c),.d(d),.out_real(out_real),.out_im(out_im));
initial
begin
a=2;b=2;c=5;d=4;
#10
a=4;b=3;c=2;d=1;
#10
a=3;b=2;c=3;d=4;
end
endmodule