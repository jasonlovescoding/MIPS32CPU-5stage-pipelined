`timescale 1ns / 1ps
`define AND 4'b0000
`define OR 4'b0001
`define XOR 4'b0010
`define NOR 4'b0011
`define ADD 4'b0100
`define SUB 4'b0101
`define SLL 4'b0110
`define SRL 4'b0111
`define SRA 4'b1000
`define LUI 4'b1001
`define SLT 4'b1010
`define SLTU 4'b1011
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:11 11/14/2016 
// Design Name: 
// Module Name:    ALU 
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
module Arithmetic_Logic_Unit(
    input [31:0] SrcA,	// 第1个操作数
    input [31:0] SrcB,	// 第2个操作数
    input [3:0] ALUControl, // 控制运算逻辑
    output [31:0] ALURst // 运算结果
    );
	wire [31:0] AND_AB = SrcA & SrcB;
	wire [31:0] OR_AB = SrcA | SrcB;
	wire [31:0] XOR_AB = SrcA ^ SrcB;
	wire [31:0] NOR_AB = ~OR_AB;
	wire [31:0] ADD_AB = SrcA + SrcB;
	wire [31:0] SUB_AB = SrcA - SrcB;
	wire [31:0] SLL_AB = SrcB << SrcA[4:0];
	wire [31:0] SRL_AB = SrcB >> SrcA[4:0];
	wire [31:0] SRA_AB = $signed(SrcB) >>> SrcA[4:0];
	wire [31:0] LUI_B = SrcB << 16;
	wire [31:0] SLT_AB = ($signed(SrcA) < $signed(SrcB));
	wire [31:0] SLTU_AB = (SrcA < SrcB);
	assign ALURst = (ALUControl==`AND) ? AND_AB :
						 (ALUControl==`OR) ? OR_AB  :
						 (ALUControl==`XOR) ? XOR_AB :
						 (ALUControl==`NOR) ? NOR_AB :
						 (ALUControl==`ADD) ? ADD_AB :
						 (ALUControl==`SUB) ? SUB_AB  :
						 (ALUControl==`SLL) ? SLL_AB :
						 (ALUControl==`SRL) ? SRL_AB :
						 (ALUControl==`SRA) ? SRA_AB :
						 (ALUControl==`LUI) ? LUI_B :
						 (ALUControl==`SLT) ? SLT_AB :
						 (ALUControl==`SLTU) ? SLTU_AB :
						 32'dz;
endmodule
