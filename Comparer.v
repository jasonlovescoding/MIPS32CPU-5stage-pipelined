`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:03:51 11/23/2016 
// Design Name: 
// Module Name:    Comparer 
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
module Comparer(
    input [31:0] D1,
    input [31:0] D2,
    input CmpOp,
    output Zero,
    output LZero
    );
	
	wire [31:0] CmpRst = (CmpOp == 0) ? D1 : // 与0比较
								(CmpOp == 1) ? D1 - D2: // 两数比较
								32'dz;
	assign Zero = (CmpRst==0);
	assign LZero = CmpRst[31];
	
endmodule
