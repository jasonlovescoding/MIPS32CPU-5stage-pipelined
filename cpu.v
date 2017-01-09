`timescale 1ns / 1ps
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define shamt 10:6
`define imm16 15:0
`define imm26 25:0
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:49:17 11/23/2016 
// Design Name: 
// Module Name:    mips 
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
module cpu(
    input clk,
	 input clk2, // 2��Ƶclk����DM
    input reset,
	 input [31:0] PrRD,
	 input [7:2] HWInt,
	 output [31:0] PrAddr,
	 output [31:0] PrWD,
	 output PrWE
    );
	assign PrAddr = ALURstM;
	assign PrWD = F_WDM;
	assign PrWE = MemWriteM && !IntReq;
	
	// ----F�׶β��������
	// PCǰ��MUX_PC_PCselF�����
	wire [31:0] nPCF; 
	// PC�����
	wire [31:0] PCF;
	// IM������ָ��
	wire [31:0] InstrF;
	// PC+4
	wire [31:0] PCplus4F;
	// ----
	
	// ----F/D��ˮ�߼Ĵ��������
	// D�׶ε�ָ��
	wire [31:0] InstrD;
	// PC+4
	wire [31:0] PCplus4D;
	// PC
	reg [31:0] PCD;
	// ----
	
	// ----D�׶ο��Ʋ��������
	// ����MUX_PC_PCselF
	wire [1:0] PCselF;
	// ����EXT
	wire ExtOpD;
	// ����NPC
	wire [1:0] NPCControlD;	
	// ����CMP
	wire CmpOpD;
	// D�׶��Ƿ�Ϊeret
	wire eretD;
	// ----
	
	// ----D�׶β��������
	// RF.RD1
	wire [31:0] RF_RD1;
	// RF.RD2
	wire [31:0] RF_RD2;
	// shift amount
	wire [31:0] shamtD;
	// ext32
	wire [31:0] ext32D;
	// PC+8
	wire [31:0] PCplus8D;
	// MUX_F_D1_Dת����ѡ�������
	wire [31:0] F_SrcAD;
	// MUX_F_D2_Dת����ѡ�������
	wire [31:0] F_SrcBD;
	// CMP��Zero
	wire CMPZeroD;
	// CMP��LZero
	wire CMPLZeroD;
	// nPC�����
	wire [31:0] nPCD;
	// ----
	
	// ----D/E��ˮ�߼Ĵ��������
	// SrcA
	wire [31:0] SrcAE;
	// SrcB
	wire [31:0] SrcBE;
	// shamt
	wire [31:0] shamtE;
	// ext32
	wire [31:0] ext32E;
	// InstrE
	wire [31:0] InstrE;
	// PC+8
	wire [31:0] PCplus8E;
	// PC
	reg [31:0] PCE;
	// ----
	
	// ----E�׶ο��Ʋ��������
	// ����ALU�����߼�
	wire [3:0] ALUControlE;
	// ����ALU��2����������
	wire ALUSrcE;
	// ����ALU��һ����������
	wire SnvE;
	// ����MUX_A3_RegDst
	wire [1:0] RegDstE;
	// ----
	
	// ----E�׶β��������
	// MUX_F_SrcA_Eת����ѡ�������
	wire [31:0] F_SrcAE;
	// MUX_F_SrcB_Eת����ѡ�������
	wire [31:0] F_SrcBE;
	// MUX_SrcA_SnvE����� ��ALU
	wire [31:0] ALU_SrcA;
	// MUX_SrcB_ALUSrcE����� ��ALU
	wire [31:0] ALU_SrcB;
	// MUX_A3E_RegDstE�����
	wire [4:0] A3E;
	// ALU��������
	wire [31:0] ALURstE;
	// ----
	
	// ----E/M��ˮ�߼Ĵ��������
	// ALURst
	wire [31:0] ALURstM;
	// WD
	wire [31:0] WDM;
	// A3
	wire [4:0] A3M;
	// InstrM
	wire [31:0] InstrM;
	// PC+8
	wire [31:0] PCplus8M;
	// PC
	reg [31:0] PCM;
	// ----
	
	// ----M�׶ο��Ʋ��������
	// ����DMд��/��ȡ
	wire MemWriteM;
	// ����BEU������߼�
	wire [1:0] BEControlM;
	// CP0��дʹ��
	wire CP0WriteM;
	// ----
	
	// ----M�����������
	// BEU�����
	wire [3:0] BEM;
	// MUX_WD_Mת����ѡ�������
	wire [31:0] F_WDM;
	// DM�Ķ�ȡ
	wire [31:0] DM_RD;
	// DMHit
	wire DMHitM;
	// MUX_RDM_DMHit�����
	wire [31:0] RDM;
	// ----
	
	// ----M/W��ˮ�߼Ĵ��������
	// ALURst
	wire [31:0] ALURstW;
	// DM��ȡ
	wire [31:0] RDW;
	// PC+8
	wire [31:0] PCplus8W;
	// CP0RstW
	wire [31:0] CP0RDW;
	// A3
	wire [4:0] A3W;
	// InstrW
	wire [31:0] InstrW;
	// ----
	
	// ----W�׶ο��Ʋ��������
	// RF��дʹ��
	wire RegWriteW;
	// ����MUX_WD3_RegSrc
	wire [1:0] RegSrcW;
	// ����BHExt������߼�
	wire [2:0] BHExtOpW;
	// �Ƿ�Ϊ��֧/��תָ��
	wire BranchW;
	// EXLClr, eret����
	wire EXLClrW;
	// ----
	
	// ----W�����������
	// BHExt�����
	wire [31:0] BHExt32W;
	// MUX_WD3_RegSrc�����
	wire [31:0] WD3W;
	// ----
	
	// ��ͣ���������
	wire stall;
	
	// ת�����������
	wire [1:0] F_D1_D;
	wire [1:0] F_D2_D;
   wire [2:0] F_SrcA_E;
   wire [2:0] F_SrcB_E;
	wire [2:0] F_WD_M;
	
	// ��CP0��PC�����
	wire [31:0] CP0_PC;
	
	// ----CP0�����
	// Interrupt request
	wire IntReq;
	// EPC
	wire [31:0] EPC;
	// Data Out
	wire [31:0] CP0RDM;
	// ----	
	
	// ----�����жϵ�PC�Ĵ�������ˮ
	always@(posedge clk) begin
		if (reset) begin
			PCD <= 0;
			PCE <= 0;
			PCM <= 0;
		end
		else begin
			if (!stall)
				PCD <= PCF;
			PCE <= PCD;
			PCM <= PCE;
		end
	end
	// ----

	// CP0����. ����������M��
	assign CP0_PC = (BranchW) ? PCM - 4 : // �ӳٲ�
										 PCM;
	CoProcessor0 CP0(.A1(InstrM[`rd]), .A2(InstrM[`rd]), .WD2(F_WDM), .PC(CP0_PC), .ExcCode(5'b0), .HWInt(HWInt), 
	.WE(CP0WriteM), .EXLSet(1'b0), .EXLClr(EXLClrW), .clk(clk), .reset(reset), .IntReq(IntReq), .EPC(EPC), .RD(CP0RDM));
	
	// ----F����������
	assign PCplus4F = PCF + 4;
	MUX_32bit_4to1 MUX_PC_PCselF(._00(PCplus4F), ._01(nPCD), 
										  ._10(EPC), ._11(32'h00004180), .sel(PCselF), .out(nPCF));
	Program_Counter PC(.nPC(nPCF), .enable(!stall), .reset(reset), .clk(clk), .PC(PCF));
	Instruction_Memory IM(.PC(PCF), .clk(clk2), .Instr(InstrF));
	// ----
	
	// ----F/D��ˮ�߼Ĵ�������
	F_D_Reg F_D(.InstrF(InstrF), .PCplus4F(PCplus4F),
					.clk(clk), .reset(reset || IntReq), .enable(!stall), .eretD(eretD),
					.InstrD(InstrD), .PCplus4D(PCplus4D));
	// ----
	
	// ----D������������
	Control_Unit_D CUD(.InstrD(InstrD), .CmpZero(CmpZeroD), .CmpLZero(CmpLZeroD), .IntReq(IntReq),
							 .PCselF(PCselF), .ExtOpD(ExtOpD), .NPCControlD(NPCControlD), .CmpOpD(CmpOpD), .eretD(eretD));
	// ----
	
	// ----D����������
	Register_File RF(.A1(InstrD[`rs]), .A2(InstrD[`rt]), .A3(A3W), .WD3(WD3W), .WE3(RegWriteW),
						  .clk(clk), .reset(reset), .RD1(RF_RD1), .RD2(RF_RD2));
	assign shamtD = {27'b0, InstrD[`shamt]};
	Extender EXT(.Imm16(InstrD[`imm16]), .ExtOp(ExtOpD), .Ext32(ext32D));
	assign PCplus8D = PCplus4D + 4;
	Next_Program_Counter NPC(.PCplus4(PCplus4D), .Imm26(InstrD[`imm26]), .RegAddr(F_SrcAD), .NPCControl(NPCControlD), 
									 .nPC(nPCD));
	MUX_32bit_4to1 MUX_F_D1_D(._00(RF_RD1), ._01(ALURstM), ._10(PCplus8M), ._11(), .sel(F_D1_D), 
									  .out(F_SrcAD));
	MUX_32bit_4to1 MUX_F_D2_D(._00(RF_RD2), ._01(ALURstM), ._10(PCplus8M), ._11(), .sel(F_D2_D), 
									  .out(F_SrcBD));
   Comparer CMP(.D1(F_SrcAD), .D2(F_SrcBD), .CmpOp(CmpOpD), .Zero(CmpZeroD), .LZero(CmpLZeroD));
	// ----
	
	// ----D/E��ˮ�߼Ĵ�������
	D_E_Reg D_E(.SrcAD(F_SrcAD), .SrcBD(F_SrcBD), .shamtD(shamtD), .ext32D(ext32D), 
					.InstrD(InstrD),.PCplus8D(PCplus8D), .clk(clk), .reset(reset || stall || IntReq),
					.SrcAE(SrcAE), .SrcBE(SrcBE), .shamtE(shamtE), .ext32E(ext32E), .InstrE(InstrE), 
					.PCplus8E(PCplus8E));
	// ----
	
	// ----E������������
	Control_Unit_E CUE(.InstrE(InstrE), .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE), .SnvE(SnvE),
							 .RegDstE(RegDstE));
	// ----
	
	// ----E����������
	MUX_32bit_8to1 MUX_F_SrcA_E(._000(SrcAE), ._001(ALURstM), ._010(PCplus8M), ._011(ALURstW),
										 ._100(BHExt32W), ._101(PCplus8W), ._110(CP0RDW),
										 .sel(F_SrcA_E), .out(F_SrcAE));
	MUX_32bit_8to1 MUX_F_SrcB_E(._000(SrcBE), ._001(ALURstM), ._010(PCplus8M), ._011(ALURstW),
										 ._100(BHExt32W), ._101(PCplus8W), ._110(CP0RDW),
										 .sel(F_SrcB_E), .out(F_SrcBE));			
	MUX_32bit_2to1	MUX_SrcA_SnvE(._0(F_SrcAE), ._1(shamtE), .sel(SnvE), .out(ALU_SrcA));	
	MUX_32bit_2to1 MUX_SrcB_ALUSrcE(._0(F_SrcBE), ._1(ext32E), .sel(ALUSrcE), .out(ALU_SrcB));
	MUX_5bit_4to1 MUX_A3_RegDstE(._00(InstrE[`rt]), ._01(InstrE[`rd]), ._10(5'b11111), ._11(), 
										  .sel(RegDstE), .out(A3E));	
	Arithmetic_Logic_Unit ALU(.SrcA(ALU_SrcA), .SrcB(ALU_SrcB),	.ALUControl(ALUControlE),.ALURst(ALURstE));
	// ----
	
	// ----E/M����ˮ�߼Ĵ�������
	E_M_Reg E_M(.ALURstE(ALURstE), .WDE(F_SrcBE), .A3E(A3E), .InstrE(InstrE), .PCplus8E(PCplus8E), 
	.clk(clk), .reset(reset || IntReq), 
	.ALURstM(ALURstM), .WDM(WDM), .A3M(A3M), .PCplus8M(PCplus8M), .InstrM(InstrM));
	// ----
	
	// ----M������������
	Control_Unit_M CUM(.InstrM(InstrM), .MemWriteM(MemWriteM), .BEControlM(BEControlM), .CP0WriteM(CP0WriteM));
	// ----
	
	// ----M����������
	assign DMHitM = (ALURstM<=32'h00001fff); // ȷʵд��DM�����ⲿ�豸
	assign RDM = (DMHitM) ? DM_RD: // д��������Ҫ����ѡ��
					 PrRD; 
	MUX_32bit_8to1 MUX_F_WD_M(._000(WDM), ._001(ALURstW), ._010(BHExt32W), ._011(PCplus8W), ._100(CP0RDW),
									  .sel(F_WD_M), .out(F_WDM));
	Byte_Entry_Unit BEU(.A1_0(ALURstM[1:0]), .BEControl(BEControlM), .BE(BEM));
	Data_Memory DM(.A(ALURstM), .WD(F_WDM), .WE(MemWriteM && DMHitM && !IntReq), .BE(BEM), 
								.clk(clk2), .reset(reset), .RD(DM_RD));
	// ----
	
	// ----M/W����ˮ�߼Ĵ�������
	M_W_Reg M_W(.ALURstM(ALURstM), .RDM(RDM), .A3M(A3M), .InstrM(InstrM), .PCplus8M(PCplus8M), .CP0RDM(CP0RDM), 
					.clk(clk), .reset(reset || IntReq), 
					.ALURstW(ALURstW), .RDW(RDW), .PCplus8W(PCplus8W), .A3W(A3W), .InstrW(InstrW), .CP0RDW(CP0RDW));
	// ----
	
	// ----W������������
	Control_Unit_W CUW(.InstrW(InstrW), .RegSrcW(RegSrcW), .RegWriteW(RegWriteW), .BHExtOpW(BHExtOpW),
							 .BranchW(BranchW), .EXLClrW(EXLClrW));
	// ----

	// ----W����������
	Byte_Halfword_Extender BHExt(.RD(RDW), .BHExtOp(BHExtOpW), .BHExt32(BHExt32W)
										  );	
	MUX_32bit_4to1 MUX_WD3_RegSrc(._00(ALURstW), ._01(BHExt32W), ._10(PCplus8W), ._11(CP0RDW),  
											.sel(RegSrcW), .out(WD3W));
	// ----
	
	// ----��ͣ����
	Stall_Detection_Unit SDU(.InstrD(InstrD), .InstrE(InstrE), .InstrM(InstrM), .IntReq(IntReq), 
									 .stall(stall));
	// ----
	
	// ----ת������
	Forward_Detection_Unit FDU(.InstrD(InstrD), .InstrE(InstrE), .InstrM(InstrM), .InstrW(InstrW), 
	.F_D1_D(F_D1_D), .F_D2_D(F_D2_D), .F_SrcA_E(F_SrcA_E), .F_SrcB_E(F_SrcB_E), .F_WD_M(F_WD_M));
	// ----
endmodule
