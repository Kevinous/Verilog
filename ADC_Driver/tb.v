`timescale 1ns/1ps
module tb;
	reg clk;

	reg SDO;

	wire CS, SCLK;//, SDO;
	wire DIN;
	wire [15:0] data;

initial begin 
clk = 1'b0;
SDO = 1'b1;
end
//assign SDO = 1'b1;
always begin 
	#5 clk <= ~clk;
	
end


 top the_ads7883(
	.clk(clk), .nrst(1'b1),//low active
	.aCS(CS), .aSCLK(SCLK),
	.aSDO(SDO),
	.adata(data),
	.aDIN(DIN)
);

endmodule 