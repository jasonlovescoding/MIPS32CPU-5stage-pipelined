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
module Control_Unit_W(
    input [31:0] InstrW,	// 当前指令
    output RegWriteW,	// Register File的写使能WE3
	 output [1:0] RegSrcW,	// 写入寄存器的数据来自ALU(00)或DM(01)或PC+8(10)或CP0(11)
	 output [2:0] BHExtOpW,
	 output EXLClrW, 
	 output BranchW // 用于EPC判断存入的PC
    );
	
	// AND逻辑生成指令信号
	wire [5:0] opcode = InstrW[31:26];
	wire [5:0] funct = InstrW[5:0];
	wire R = (opcode==6'b000000);
	
	wire LB = (opcode==6'b100000);
	wire LBU = (opcode==6'b100100);
	wire LH = (opcode==6'b100001);
	wire LHU = (opcode==6'b100101);
	
	Instruction_Decoder ID(.Instr(InstrW), .cal_r(cal_r), .cal_s(cal_s), .cal_il(cal_il), .cal_ia(cal_ia), 
									 .load(load), .store(store), .b_cmp(b_cmp), .b_cmpz(b_cmpz), .j(j), 
									 .jal(jal), .jr(jr), .jalr(jalr), .mfc0(mfc0), .mtc0(mtc0), .eret(eret));
	
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
	wire mult_div;
	wire mf;
	wire mt;
	wire mfc0;
	wire eret;
	*/
	
	// OR逻辑生成控制信号
	assign RegSrcW = (load) ? 2'b01 : // 来自DM_RD拓展后的数
						  (jal || jalr) ? 2'b10 : // 来自PCplus8
						  (mfc0) ? 2'b11 :
						  2'b00; // 来自ALURst或Don't care
	
	assign RegWriteW = cal_r || cal_s || cal_il || cal_ia || load || jal || jalr || mfc0;
	
	assign BHExtOpW = LB ? 3'b001 : // 有符号字节拓展
							LBU ? 3'b010 : // 无符号字节拓展
							LH ? 3'b011 : // 有符号半字拓展
							LHU ? 3'b100 : // 无符号半字拓展
							//LWR ? 3'b101 : // LWR拓展
							3'b000; // 字
	
	assign BranchW = b_cmp || b_cmpz || j || jal || jr || jalr;
	
	assign EXLClrW = eret;
endmodule
