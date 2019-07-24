module  top(a,b,c,d,out_real,out_im);    
  input  [3:0]  a,  b,  c,  d;    
  output  [8:0]  out_real;    
  output  [8:0]  out_im;    
 
  Multiplier U1(.a(a),  .b(b),  .c(c),  .d(d),  .out_real(out_real),    
                .out_im(out_im));  

endmodule 
