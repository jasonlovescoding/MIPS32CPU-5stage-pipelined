`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:05:34 11/24/2016 
// Design Name: 
// Module Name:    D_E_Reg 
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
module D_E_Reg(
    input [31:0] SrcAD,
    input [31:0] SrcBD,
    input [31:0] shamtD,
    input [31:0] ext32D,
    input [31:0] InstrD,
	 input [31:0] PCplus8D, 
	 input clk,
	 input reset,
    output reg [31:0] SrcAE,
    output reg [31:0] SrcBE,
    output reg [31:0] shamtE,
    output reg [31:0] ext32E,
    output reg [31:0] InstrE,
	 output reg [31:0] PCplus8E
    );
	
	/*initial begin
		SrcAE <= 0;
		SrcBE <= 0;
		shamtE <= 0;
		ext32E <= 0;
		InstrE <= 0;
		PCplus8E <= 0;
	end*/
	
	always@(posedge clk) begin
		if (reset) begin
			SrcAE <= 0;
			SrcBE <= 0;
			shamtE <= 0;
			ext32E <= 0;
			InstrE <= 0;
			PCplus8E <= 0;
		end
		else begin
			SrcAE <= SrcAD;
			SrcBE <= SrcBD;
			shamtE <= shamtD;
			ext32E <= ext32D;
			InstrE <= InstrD;;
			PCplus8E <= PCplus8D;
		end
	end
endmodule
