`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:29 11/29/2016 
// Design Name: 
// Module Name:    MUX_32bit_8to1 
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
module MUX_32bit_8to1(
    input [31:0] _000,
    input [31:0] _001,
    input [31:0] _010,
    input [31:0] _011,
    input [31:0] _100,
    input [31:0] _101,
    input [31:0] _110,
    input [31:0] _111,
    input [2:0] sel,
    output [31:0] out
    );

	assign out = (sel == 3'b000) ? _000 :
					 (sel == 3'b001) ? _001 :
					 (sel == 3'b010) ? _010 :
					 (sel == 3'b011) ? _011 :
					 (sel == 3'b100) ? _100 :
					 (sel == 3'b101) ? _101 :
					 (sel == 3'b110) ? _110 :
					 (sel == 3'b111) ? _111 :
					 32'dz;
endmodule
