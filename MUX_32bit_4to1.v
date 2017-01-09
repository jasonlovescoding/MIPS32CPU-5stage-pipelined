`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:03:27 11/16/2016 
// Design Name: 
// Module Name:    MUX_32bit_4to1 
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
module MUX_32bit_4to1(
    input [31:0] _00,
    input [31:0] _01,
    input [31:0] _10,
    input [31:0] _11,
    input [1:0] sel,
    output [31:0] out
    );

	assign out = (sel == 2'b00) ? _00 :
					 (sel == 2'b01) ? _01 :
					 (sel == 2'b10) ? _10 :
					 (sel == 2'b11) ? _11 :
					 32'dz;
endmodule
