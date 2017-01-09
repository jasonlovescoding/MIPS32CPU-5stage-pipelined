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
module Control_Unit_D(
    input [31:0] InstrD,	// 当前D阶段的指令
	 input CmpZero,	// CMP的Zero信号，用于产生PCselF
	 input CmpLZero,  // CMP的LZero信号，用于产生PCselF
	 input IntReq, // 强制产生PCselF
    output ExtOpD,	// 拓展单元采用逻辑拓展(0)或符号拓展(1)
	 output [1:0] NPCControlD,  // 控制下条指令地址的产生逻辑
	 output [1:0] PCselF, // 控制下条PC采用分支跳转结果(1)或否(0)
	 output CmpOpD,	 // CMP模块取两数比较(0)或与0比较(1)
	 output eretD
    );
	 
	// AND逻辑生成指令信号
	wire [5:0] opcode = InstrD[31:26];
	wire [5:0] funct = InstrD[5:0];
	wire R = (opcode==6'b000000);

	wire BEQ = (opcode==6'b000100);
	wire BNE = (opcode==6'b000101);
	wire BLEZ = (opcode==6'b000110);
	wire BGTZ = (opcode==6'b000111);
	wire BLTZ = ((opcode==6'b000001) && (InstrD[`rt]==5'b00000));
	wire BGEZ = ((opcode==6'b000001) && (InstrD[`rt]==5'b00001));
	
	/*wire MOVZ = (R && (funct == 6'b001010));
	wire MOVN = (R && (funct == 6'b001011));*/
	
	Instruction_Decoder ID(.Instr(InstrD), .cal_r(cal_r), .cal_s(cal_s), .cal_il(cal_il), .cal_ia(cal_ia), 
									 .load(load), .store(store), .b_cmp(b_cmp), .b_cmpz(b_cmpz), .j(j), 
									 .jal(jal), .jr(jr), .jalr(jalr), .eret(eret));
	/*指令分类
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
	wire eret;
	*/
	
	// OR逻辑生成控制信号
	assign PCselF = (IntReq) ? 2'b11 : // 中断 进入handler
						 (eret) ? 2'b10 : // 回到EPC
						 ((BEQ && CmpZero) || (BNE && !CmpZero) || 
						 (BLEZ && (CmpLZero || CmpZero)) || (BLTZ && CmpLZero) || 
						 (BGEZ && !CmpLZero) || (BGTZ && (!CmpLZero && !CmpZero)) ||
						 j || jr || jal || jalr) ? 2'b01 : // 正常跳转
						 2'b00; // 其他
						 
	assign ExtOpD = cal_ia || load || store;
	
	assign NPCControlD = (j || jal) ? 2'b01 :	// jump
							   (jr || jalr) ? 2'b10 :	// jump to register
							   2'b00; // branch or don't care
					 
	assign CmpOpD = b_cmp; // 1: 将2数比较; 0: 与0比较或don't care
	
	assign eretD = eret;
	
endmodule
