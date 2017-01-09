`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:55:18 11/23/2016 
// Design Name: 
// Module Name:    F_D_Reg 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module F_D_Reg(
    input [31:0] InstrF,
    input [31:0] PCplus4F,
	 input eretD, // 当D级流水线上是eret且目前不需要暂停时 同reset
	 input clk,
	 input reset,
	 input enable,
    output reg [31:0] InstrD,
    output reg [31:0] PCplus4D
    );
	
	/*initial begin
		InstrD <= 0;
		PCplus4D <= 0;
	end*/
	
	always@(posedge clk) begin
		if (reset || (eretD && enable)) begin
			InstrD <= 0;
			PCplus4D <= 0;
		end
		else if (enable) begin
			InstrD <= InstrF;
			PCplus4D <= PCplus4F;
		end
	end
	
endmodule
