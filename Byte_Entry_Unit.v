`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:05:11 12/07/2016 
// Design Name: 
// Module Name:    Byte_Entry_Unit 
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
module Byte_Entry_Unit(
    input [1:0] A1_0,
    input [1:0] BEControl,
    output [3:0] BE
    );
	assign BE = (BEControl==2'b01 && A1_0==2'b00) ? 4'b0001 : // 01: ×Ö½Ú
					(BEControl==2'b01 && A1_0==2'b01) ? 4'b0010 :
					(BEControl==2'b01 && A1_0==2'b10) ? 4'b0100 :
					(BEControl==2'b01 && A1_0==2'b11) ? 4'b1000 :
					(BEControl==2'b10 && A1_0==2'b00) ? 4'b0011 : // 10: °ë×Ö
					(BEControl==2'b10 && A1_0==2'b10) ? 4'b1100 : 
					4'b1111;
endmodule
