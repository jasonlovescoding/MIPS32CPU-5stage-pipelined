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
module Control_Unit_M(
    input [31:0] InstrM,	// ��ǰָ��
    output MemWriteM,	// Data Memory��дʹ��WE
	 output [1:0] BEControlM,
	 output CP0WriteM // CP0��дʹ��
    );
	
	// AND�߼�����ָ���ź�
	wire [5:0] opcode = InstrM[31:26];
	wire [5:0] funct = InstrM[5:0];
	wire R = (opcode==6'b000000);
	
	wire LB = (opcode==6'b100000);
	wire LBU = (opcode==6'b100100);
	wire LH = (opcode==6'b100001);
	wire LHU = (opcode==6'b100101);
	wire LW = (opcode==6'b100011);
	wire SB = (opcode==6'b101000);
	wire SH = (opcode==6'b101001);
	wire SW = (opcode==6'b101011);
	
	Instruction_Decoder ID(.Instr(InstrM), .cal_r(cal_r), .cal_s(cal_s), .cal_il(cal_il), .cal_ia(cal_ia), 
									 .load(load), .store(store), .b_cmp(b_cmp), .b_cmpz(b_cmpz), .j(j), 
									 .jal(jal), .jr(jr), .jalr(jalr),.mtc0(mtc0), .eret(eret));	
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
	wire mtc0;
	wire eret;
	*/
	 
	// OR�߼����ɿ����ź�
	assign MemWriteM = (store);
	
	assign BEControlM = (SB || LB || LBU) ? 2'b01 : // �ֽ�
							  (SH || LH || LHU) ? 2'b10 : // ����
							  2'b00; // �ֻ�don't care
	
	assign CP0WriteM = mtc0;				  			  
endmodule
