`timescale 1ns / 1ps
`define rs 25:21
`define rt 20:16
`define rd 15:11
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:48:08 12/08/2016 
// Design Name: 
// Module Name:    Instruction_Decoder 
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
module Instruction_Decoder(
    input [31:0] Instr,
    output cal_r,
    output cal_s,
    output cal_il,
    output cal_ia,
    output load,
    output store,
    output b_cmp,
    output b_cmpz,
    output j,
    output jal,
    output jr,
    output jalr,
	 output mfc0,
	 output mtc0,
	 output eret
    );
	
	// AND逻辑生成指令信号
	wire [5:0] opcode = Instr[31:26];
	wire [5:0] funct = Instr[5:0];
	wire R = (opcode==6'b000000);
	
	wire LB = (opcode==6'b100000);
	wire LBU = (opcode==6'b100100);
	wire LH = (opcode==6'b100001);
	wire LHU = (opcode==6'b100101);
	wire LW = (opcode==6'b100011);
	wire SB = (opcode==6'b101000);
	wire SH = (opcode==6'b101001);
	wire SW = (opcode==6'b101011);
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
	wire BEQ = (opcode==6'b000100);
	wire BNE = (opcode==6'b000101);
	wire BLEZ = (opcode==6'b000110);
	wire BGTZ = (opcode==6'b000111);
	wire BLTZ = ((opcode==6'b000001) && (Instr[`rt]==5'b00000));
	wire BGEZ = ((opcode==6'b000001) && (Instr[`rt]==5'b00001));
	wire J = (opcode==6'b000010);
	wire JAL = (opcode==6'b000011);
	wire JALR = (R && (funct==6'b001001));
	wire JR = (R && (funct==6'b001000));
	wire MFC0 = (opcode==6'b010000 && Instr[25:21]==5'b00000);
	wire MTC0 = (opcode==6'b010000 && Instr[25:21]==5'b00100);
	wire ERET = (opcode==6'b010000 && Instr[25] &&funct==6'b011000);
	
	// 指令分类
	assign cal_r = ADD || ADDU || SUB || SUBU || SLLV || SRLV || SRAV || AND || OR || XOR || NOR || SLT || SLTU;
	assign cal_s = SLL || SRL || SRA;
	assign cal_il = ANDI || ORI || XORI || LUI;
	assign cal_ia = ADDI || ADDIU || SLTI || SLTIU;
	assign load = LB || LBU || LH || LHU || LW;// || LWR;
	assign store = SB || SH || SW;// || SWR;
	assign b_cmp = BEQ || BNE;
	assign b_cmpz = BLEZ || BGTZ || BLTZ || BGEZ;
	assign j = J;
	assign jal = JAL;
	assign jr = JR;
	assign jalr = JALR;
	assign mfc0 = MFC0;
	assign mtc0 = MTC0;
	assign eret = ERET;
	
endmodule
