`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/23 09:16:02
// Design Name: 
// Module Name: top
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

module top(
	input clk,
	output aCS, aSCLK, aDIN,
	input aSDO,
	output aEnable
);

wire [15:0] adata;

 adc_driver the_ads7883(
	.clk(clk), .nrst(1'b1),//low active
	.CONVST(aCS), .SCLK(aSCLK),
	.SDO(aSDO),
	.data(adata),
	.DIN(aDIN),
	.Enable(aEnable)
);
ila_0 your_instance_name (
	.clk(clk), // input wire clk


	.probe0(adata), // input wire [15:0]  probe0  
	.probe1(aSCLK), // input wire [0:0]  probe1
	.probe2(aSDO), // input wire [0:0]  probe2 
	.probe3(aDIN), // input wire [0:0]  probe3 
	.probe4(aCS) // input wire [0:0]  probe4
);

endmodule 