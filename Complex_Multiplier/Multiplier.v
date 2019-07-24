
module Multiplier(a,b,c,d,out_real,out_im);
 
input[3:0]a,b,c,d;
 
output[8:0]out_real,out_im;
 
wire[7:0]sub1,sub2,add1,add2;
 
Wallace U1(.x(a),.y(c),.out(sub1));
Wallace U2(.x(b),.y(d),.out(sub2));
Wallace U3(.x(a),.y(d),.out(add1));
Wallace U4(.x(b),.y(c),.out(add2));

assign out_real=sub1-sub2; 
assign out_im=add1+add2;
 
endmodule
