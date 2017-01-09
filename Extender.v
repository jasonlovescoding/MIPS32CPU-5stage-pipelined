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
    input [15:0] Imm16, // Ҫ����չ��16λ������
    input ExtOp, // �����Ƿ�����չ(1)�����߼���չ(0)
    output [31:0] Ext32 // ��չ�Ľ��
    );
	assign Ext32 = ExtOp ? { {16{Imm16[15]}}, Imm16} : {16'b0, Imm16};
endmodule
