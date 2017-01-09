`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:47 11/14/2016 
// Design Name: 
// Module Name:    EXT 
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
module Extender (
    input [15:0] Imm16, // 要被拓展的16位立即数
    input ExtOp, // 决定是符号拓展(1)还是逻辑拓展(0)
    output [31:0] Ext32 // 拓展的结果
    );
	assign Ext32 = ExtOp ? { {16{Imm16[15]}}, Imm16} : {16'b0, Imm16};
endmodule
