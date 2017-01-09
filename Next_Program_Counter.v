`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:44:01 11/15/2016 
// Design Name: 
// Module Name:    Next_Program_Counter 
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
module Next_Program_Counter(
    input [31:0] PCplus4,			// 目前指令地址
	 input [25:0] Imm26,		// j类型指令跳转计算用
	 input [31:0] RegAddr,	// jr跳转计算用
    input [1:0] NPCControl, // 控制下条指令逻辑
    output [31:0] nPC		 // 下条指令地址
    );
	assign nPC = (NPCControl == 2'b00) ? PCplus4 + {{14{Imm26[15]}} ,Imm26[15:0], 2'b00}:	// branch
					 (NPCControl == 2'b01) ? {PCplus4[31:28] ,Imm26, 2'b00} :	// jump
					 (NPCControl == 2'b10) ? RegAddr : // jr
					 32'dz;
	
endmodule
