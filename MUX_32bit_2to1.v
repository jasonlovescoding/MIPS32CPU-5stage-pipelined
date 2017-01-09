`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:15:48 11/17/2016 
// Design Name: 
// Module Name:    MUX_32bit_2to1 
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
module MUX_32bit_2to1(
    input [31:0] _0,
    input [31:0] _1,
    input sel,
    output [31:0] out
    );
	 
	assign out = (sel == 0) ? _0 :
					 (sel == 1) ? _1 :
					 32'dz;

endmodule
