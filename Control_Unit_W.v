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
    input [31:0] InstrW,	// ��ǰָ��
    output RegWriteW,	// Register File��дʹ��WE3
	 output [1:0] RegSrcW,	// д��Ĵ�������������ALU(00)��DM(01)��PC+8(10)��CP0(11)
	 output [2:0] BHExtOpW,
	 output EXLClrW, 
	 output BranchW // ����EPC�жϴ����PC
    );
	
	// AND�߼�����ָ���ź�
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
	
	/* ָ�����
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
	
	// OR�߼����ɿ����ź�
	assign RegSrcW = (load) ? 2'b01 : // ����DM_RD��չ�����
						  (jal || jalr) ? 2'b10 : // ����PCplus8
						  (mfc0) ? 2'b11 :
						  2'b00; // ����ALURst��Don't care
	
	assign RegWriteW = cal_r || cal_s || cal_il || cal_ia || load || jal || jalr || mfc0;
	
	assign BHExtOpW = LB ? 3'b001 : // �з����ֽ���չ
							LBU ? 3'b010 : // �޷����ֽ���չ
							LH ? 3'b011 : // �з��Ű�����չ
							LHU ? 3'b100 : // �޷��Ű�����չ
							//LWR ? 3'b101 : // LWR��չ
							3'b000; // ��
	
	assign BranchW = b_cmp || b_cmpz || j || jal || jr || jalr;
	
	assign EXLClrW = eret;
endmodule
