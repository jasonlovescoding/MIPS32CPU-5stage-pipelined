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
    input [31:0] InstrD,	// ��ǰD�׶ε�ָ��
	 input CmpZero,	// CMP��Zero�źţ����ڲ���PCselF
	 input CmpLZero,  // CMP��LZero�źţ����ڲ���PCselF
	 input IntReq, // ǿ�Ʋ���PCselF
    output ExtOpD,	// ��չ��Ԫ�����߼���չ(0)�������չ(1)
	 output [1:0] NPCControlD,  // ��������ָ���ַ�Ĳ����߼�
	 output [1:0] PCselF, // ��������PC���÷�֧��ת���(1)���(0)
	 output CmpOpD,	 // CMPģ��ȡ�����Ƚ�(0)����0�Ƚ�(1)
	 output eretD
    );
	 
	// AND�߼�����ָ���ź�
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
	/*ָ�����
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
	
	// OR�߼����ɿ����ź�
	assign PCselF = (IntReq) ? 2'b11 : // �ж� ����handler
						 (eret) ? 2'b10 : // �ص�EPC
						 ((BEQ && CmpZero) || (BNE && !CmpZero) || 
						 (BLEZ && (CmpLZero || CmpZero)) || (BLTZ && CmpLZero) || 
						 (BGEZ && !CmpLZero) || (BGTZ && (!CmpLZero && !CmpZero)) ||
						 j || jr || jal || jalr) ? 2'b01 : // ������ת
						 2'b00; // ����
						 
	assign ExtOpD = cal_ia || load || store;
	
	assign NPCControlD = (j || jal) ? 2'b01 :	// jump
							   (jr || jalr) ? 2'b10 :	// jump to register
							   2'b00; // branch or don't care
					 
	assign CmpOpD = b_cmp; // 1: ��2���Ƚ�; 0: ��0�Ƚϻ�don't care
	
	assign eretD = eret;
	
endmodule
