`timescale 1ns / 1ps
`define rs 25:21
`define rt 20:16
`define rd 15:11
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:51:17 11/15/2016 
// Design Name: 
// Module Name:    Control_Unit 
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
module Control_Unit_E(
    input [31:0] InstrE,	// 当前指令
	 output [3:0] ALUControlE, // 控制ALU的计算逻辑
	 output ALUSrcE,	// ALU的第二个操作数来自RF(0)或imm16(1)
	 output SnvE, // ALU的第一个操作数来自RF(0)或shamt(1)
	 output [1:0] RegDstE	// 写入寄存器编号A3是rt(00)或rd(01)或$ra(10)
    );
	
	// AND逻辑生成指令信号
	wire [5:0] opcode = InstrE[31:26];
	wire [5:0] funct = InstrE[5:0];
	wire R = (opcode==6'b000000);
	
	wire ADD = (R && (funct==6'b100000));
	wire ADDU = (R && (funct==6'b100001));
	wire SUB = (R && (funct==6'b100010));
	wire SUBU = (R && (funct==6'b100011));
	wire MULT = (R && (funct==6'b011000));
	wire MULTU = (R && (funct==6'b011001));
	wire DIV = (R && (funct==6'b011010));
	wire DIVU = (R && (funct==6'b011011));
	wire SLL = (R && (funct==6'b000000));
	wire SRL = (R && (funct==6'b000010));
	wire SRA = (R && (funct==6'b000011));
	wire SLLV = (R && (funct==6'b000100));
	wire SRLV = (R && (funct==6'b000110));
	wire SRAV = (R && (funct==6'b000111));
	wire AND = (R && (funct==6'b100100));
	wire OR = (R && (funct==6'b100101));
	wire XOR = (R && (funct==6'b100110));
	wire NOR = (R && (funct==6'b100111));
	wire ADDI = (opcode==6'b001000);
	wire ADDIU = (opcode==6'b001001);
	wire ANDI = (opcode==6'b001100);
	wire ORI = (opcode==6'b001101);
	wire XORI = (opcode==6'b001110);
	wire LUI = (opcode==6'b001111);
	wire SLT = (R && (funct==6'b101010));
	wire SLTI = (opcode==6'b001010);
	wire SLTIU = (opcode==6'b001011);
	wire SLTU = (R && (funct==6'b101011));
	
	Instruction_Decoder ID(.Instr(InstrE), .cal_r(cal_r), .cal_s(cal_s), .cal_il(cal_il), .cal_ia(cal_ia), 
									 .load(load), .store(store), .b_cmp(b_cmp), .b_cmpz(b_cmpz), .j(j), 
									 .jal(jal), .jr(jr), .jalr(jalr));	
	/* 指令分类
	wire cal_r;
	wire cal_s;
	wire cal_il;
	wire cal_ia;
	wire load;
	wire store;
	wire b_cmp; 
	wire b_cmpz;
	wire j;
	wire jal; 
	wire jr;
	wire jalr;
	*/
	 
	// OR逻辑生成控制信号		
	assign ALUControlE = (AND || ANDI) ? 4'b0000 :	// AND
							   (OR || ORI) ? 4'b0001 :	// OR
							   (XOR || XORI) ? 4'b0010 :	// XOR
							   (NOR) ? 4'b0011 : // NOR
							   (ADD || ADDU || ADDI || ADDIU || load || store) ? 4'b0100 : // ADD
							   (SUB || SUBU) ? 4'b0101 : // SUB
							   (SLL || SLLV) ? 4'b0110 : // SLL
							   (SRL || SRLV) ? 4'b0111 : // SRL
							   (SRA || SRAV) ? 4'b1000 : // SRA
							   (LUI) ? 4'b1001 : // LUI
							   (SLT || SLTI) ? 4'b1010: // SLT
							   (SLTU || SLTIU) ? 4'b1011 : // SLTU
							   4'b0000;
							  
	assign ALUSrcE = cal_il || cal_ia || load || store;
						 
	assign SnvE = cal_s; 
	
	assign RegDstE = (cal_r || cal_s || jalr) ? 2'b01 :	// rd
						  (jal) ? 2'b10 :	// $ra
						  2'b00;	// rt or don't care		
endmodule
