`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/23 09:13:56
// Design Name: 
// Module Name: adc_driver
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
//adc driver for ads8860 test    - 16bit 1MSPS   
//50M SCLK 100M clk
//970ns 1.03MSPS 
//unsisgned output data
module adc_driver(
	input clk, nrst,//low active
	output reg CONVST, SCLK, DIN,
	input SDO,
	output reg [15:0] data,
    output reg Enable
);
	reg [15:0] shift_reg;//16 bit or 14 bit
	reg [3:0] p_count;
	reg [5:0] wait_count;
	reg [6:0] sample_count, last_clkcnt, last_datacnt;

	reg[2:0] cstate, nstate;

	parameter IDLE = 3'b001;
	parameter WAIT = 3'b010;
	parameter SAMPLE = 3'b100;

initial begin 
	p_count = 4'b0; wait_count = 3'b0; sample_count = 7'b0; data = 16'b0;
	last_clkcnt = 7'b0;last_datacnt = 7'b0; cstate = IDLE; shift_reg = 'b0;
	DIN = 'b1; Enable = 'b0;  end

//ok
always@(posedge clk or negedge nrst) begin
	if(!nrst) 	cstate <= IDLE;
	else cstate <= nstate;
end

//ok
always@(posedge clk or negedge nrst) begin
	if(!nrst)	p_count <= 4'b0;
	else p_count <= p_count + 4'b1;
end

//last for 500ns-710ns
//set CONVST to high
always@( posedge clk or negedge nrst) begin
	if(!nrst) 	wait_count <= 6'd0;
	else if((cstate == WAIT)&& (wait_count < 6'd60))//|| nstate == WAIT)
	wait_count <= wait_count + 1'b1;
	else wait_count <= 6'd0;
end

//but SCLK period is 20ns, 20*16 = 320ns
always@( posedge clk or negedge nrst) begin
	if(!nrst) 	sample_count <= 7'b0;
	else if((cstate == SAMPLE)&& (sample_count < 7'd40))// || nstate == WAIT)
	sample_count <= sample_count + 1'b1;
	else sample_count <= 7'b0;
end


always@(*) begin
	nstate = IDLE;
	case(cstate)
		IDLE:begin
			if(p_count == 4'd15)	nstate <= WAIT;
			else nstate <= IDLE;
		end
		WAIT:begin
			if(wait_count == 6'd60)	nstate <= SAMPLE;
			else nstate <= WAIT;	
		end
		SAMPLE:begin
			if(sample_count == 7'd40) nstate <= WAIT;
			else nstate <= SAMPLE;
		end
		default:begin
			nstate <= IDLE;
		end
	endcase
end

always@(posedge clk or negedge nrst) begin 
	if(!nrst) begin
		CONVST <= 1'b1;
		SCLK <= 1'b1;
		shift_reg <= 'b0;
	end
	else begin
	case(cstate)
		IDLE:begin
			CONVST <= 1'b1;
			SCLK <= 1'b1;
			shift_reg <= 'b0;
			Enable <= 1'b0;
		end
		WAIT:begin
			CONVST <= 1'b1;
			SCLK <= 1'b1;
			shift_reg <= 'b0;
			last_clkcnt <= 6'b0;
			last_datacnt <= 6'b0;
			Enable <= 1'b0;
		end
		SAMPLE:begin
			CONVST <= 1'b0;	
			if((sample_count - last_clkcnt == 2'd1)||(sample_count== 2)) begin
				SCLK = ~SCLK;
				last_clkcnt <= sample_count;
//first negedge do nothing, the first low level let AD change SDO value
//shift_reg receive data after second negedge
				if((sample_count > 7'd2)&&(!SCLK)&&(sample_count < 7'd34))begin
					shift_reg <={shift_reg[14:0],SDO};
				end

			end
			if(sample_count > 7'd33)	data <= shift_reg;
			if(sample_count == 7'd34)    Enable <= 1'b1;
			if(sample_count == 7'd35)    Enable <= 1'b0;	
		end
		default:begin
			CONVST <=1'b1;
			SCLK <= 1'b1;
			shift_reg <= 'b0;
			data <= 16'b0;
			last_clkcnt <= 6'b0;
			last_datacnt <= 6'b0;
		end
	endcase
	end
end
endmodule 
