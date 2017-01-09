`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:10:01 12/07/2016 
// Design Name: 
// Module Name:    Byte_Halfword_Extender 
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
module Byte_Halfword_Extender(
    input [31:0] RD,
    input [2:0] BHExtOp,
    output [31:0] BHExt32
    );
	assign BHExt32 = (BHExtOp == 3'b001) ? {{24{RD[7]}}, RD[7:0]} : // 001: �з����ֽ���չ
						  (BHExtOp == 3'b010) ? {24'b0, RD[7:0]} : // 010: �޷����ֽ���չ
						  (BHExtOp == 3'b011) ? {{16{RD[15]}}, RD[15:0]} : // 011: �з��Ű�����չ
						  (BHExtOp == 3'b100) ? {16'b0, RD[15:0]} : // 100: �޷��Ű�����չ
						  RD;

endmodule
