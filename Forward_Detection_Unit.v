`timescale 1ns / 1ps
`define opcode 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:15:34 11/23/2016 
// Design Name: 
// Module Name:    Forward_Detection_Unit 
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
module Forward_Detection_Unit(
    input [31:0] InstrD,
	 input [31:0] InstrE,
    input [31:0] InstrM,
    input [31:0] InstrW,
    output [1:0] F_D1_D,
    output [1:0] F_D2_D,
    output [2:0] F_SrcA_E,
    output [2:0] F_SrcB_E,
    output [2:0] F_WD_M
    );
	Instruction_Decoder ID_D(.Instr(InstrD), .cal_r(cal_r_D), .cal_s(cal_s_D), .cal_il(cal_il_D), .cal_ia(cal_ia_D), 
									 .load(load_D), .store(store_D), .b_cmp(b_cmp_D), .b_cmpz(b_cmpz_D), .j(j_D), 
									 .jal(jal_D), .jr(jr_D), .jalr(jalr_D), 
									 .mtc0(mtc0_D), .mfc0(mfc0_D));
	/* 指令分类
	wire cal_r_D;
	wire cal_s_D;
	wire cal_il_D;
	wire cal_ia_D;
	wire load_D;
	wire store_D;
	wire b_cmp_D; 
	wire b_cmpz_D;
	wire j_D;
	wire jal_D; 
	wire jr_D;
	wire jalr_D;
	wire mult_div_D;
	wire mf_D;
	wire mt_D;
	wire mtc0_D;
	wire mfc0_D;
	*/ 
	
	Instruction_Decoder ID_E(.Instr(InstrE), .cal_r(cal_r_E), .cal_s(cal_s_E), .cal_il(cal_il_E), .cal_ia(cal_ia_E), 
									 .load(load_E), .store(store_E), .b_cmp(b_cmp_E), .b_cmpz(b_cmpz_E), .j(j_E), 
									 .jal(jal_E), .jr(jr_E), .jalr(jalr_E), 
									 .mtc0(mtc0_E), .mfc0(mfc0_E));
	/* 指令分类
	wire cal_r_E;
	wire cal_s_E;
	wire cal_il_E;
	wire cal_ia_E;
	wire load_E;
	wire store_E;
	wire b_cmp_E; 
	wire b_cmpz_E;
	wire j_E;
	wire jal_E; 
	wire jr_E;
	wire jalr_E;
	wire mult_div_E;
	wire mf_E;
	wire mt_E;
	wire mtc0_E;
	wire mfc0_E;
	*/

	Instruction_Decoder ID_M(.Instr(InstrM), .cal_r(cal_r_M), .cal_s(cal_s_M), .cal_il(cal_il_M), .cal_ia(cal_ia_M), 
									 .load(load_M), .store(store_M), .b_cmp(b_cmp_M), .b_cmpz(b_cmpz_M), .j(j_M), 
									 .jal(jal_M), .jr(jr_M), .jalr(jalr_M), 
									 .mtc0(mtc0_M), .mfc0(mfc0_M));
	
	/* 指令分类
	wire cal_r_M;
	wire cal_s_M;
	wire cal_il_M;
	wire cal_ia_M;
	wire load_M;
	wire store_M;
	wire b_cmp_M; 
	wire b_cmpz_M;
	wire j_M;
	wire jal_M; 
	wire jr_M;
	wire jalr_M;
	wire mult_div_M;
	wire mf_M;
	wire mt_M;
	wire mtc0_M;
	wire mfc0_M;
	*/
	
	Instruction_Decoder ID_W(.Instr(InstrW), .cal_r(cal_r_W), .cal_s(cal_s_W), .cal_il(cal_il_W), .cal_ia(cal_ia_W), 
									 .load(load_W), .store(store_W), .b_cmp(b_cmp_W), .b_cmpz(b_cmpz_W), .j(j_W), 
									 .jal(jal_W), .jr(jr_W), .jalr(jalr_W),
									 .mtc0(mtc0_W), .mfc0(mfc0_W));
	/* 指令分类
	wire cal_r_W;
	wire cal_s_W;
	wire cal_il_W;
	wire cal_ia_W;
	wire load_W;
	wire store_W;
	wire b_cmp_W; 
	wire b_cmpz_W;
	wire j_W;
	wire jal_W; 
	wire jr_W;
	wire jalr_W;
	wire mult_div_W;
	wire mf_W;
	wire mt_W;
	wire mtc0_W;
	wire mfc0_W;
	*/
	
	// 转发条件判断
	wire ALURstM_new_rd = cal_r_M || cal_s_M;
	wire ALURstM_new_rt = cal_ia_M || cal_il_M;
	wire PCplus8M_new_rd = jalr_M;
	wire PCplus8M_new_ra = jal_M;
	
	wire ALURstW_new_rd = cal_r_W || cal_s_W;
	wire ALURstW_new_rt = cal_ia_W || cal_il_W;
	wire BHExt32W_new_rt = load_W;
	wire PCplus8W_new_rd = jalr_W;
	wire PCplus8W_new_ra = jal_W;
	wire CP0RDW_new_rt = mfc0_W;
	
	wire D_use_rs = b_cmp_D || b_cmpz_D || jr_D || jalr_D;
	wire D_use_rt = b_cmp_D;
	wire E_use_rs = cal_r_E || cal_il_E || cal_ia_E || load_E || store_E;
	wire E_use_rt = cal_r_E || cal_s_E || store_E || mtc0_E; 
	wire M_use_rt = store_M || mtc0_M; 
	
	assign F_D1_D = ((D_use_rs && InstrD[`rs]!=0 ) && ( // ALURstM
							(ALURstM_new_rd && InstrD[`rs]==InstrM[`rd]) ||
							(ALURstM_new_rt && InstrD[`rs]==InstrM[`rt]) ) ) ? 2'b01 :
						 ((D_use_rs && InstrD[`rs]!=0 ) && ( // PCplus8M
							(PCplus8M_new_rd && InstrD[`rs]==InstrM[`rd]) ||
							(PCplus8M_new_ra && InstrD[`rs]==31) ) ) ? 2'b10 :
						 2'b00; // RF_RD1

	assign F_D2_D = ((D_use_rt && InstrD[`rt]!=0 ) && ( // ALURstM
							(ALURstM_new_rd && InstrD[`rt]==InstrM[`rd]) ||
							(ALURstM_new_rt && InstrD[`rt]==InstrM[`rt]) ) ) ? 2'b01 :
						 ((D_use_rt && InstrD[`rt]!=0 ) && ( // PCplus8M
							(PCplus8M_new_rd && InstrD[`rt]==InstrM[`rd]) ||
							(PCplus8M_new_ra && InstrD[`rt]==31) ) ) ? 2'b10 :
						 2'b00; // RF_RD2

	assign F_SrcA_E = ((E_use_rs && InstrE[`rs]!=0) && ( // ALURstM
							(ALURstM_new_rd && InstrE[`rs]==InstrM[`rd]) ||
							(ALURstM_new_rt && InstrE[`rs]==InstrM[`rt]) ) ) ? 3'b001 :
							((E_use_rs && InstrE[`rs]!=0) && ( // PCplus8M
							(PCplus8M_new_rd && InstrE[`rs]==InstrM[`rd]) ||
							(PCplus8M_new_ra && InstrE[`rs]==31) ) ) ? 3'b010 :
							((E_use_rs && InstrE[`rs]!=0) && ( // ALURstW
							(ALURstW_new_rd && InstrE[`rs]==InstrW[`rd])  ||
							(ALURstW_new_rt && InstrE[`rs]==InstrW[`rt]) ) ) ? 3'b011 :
							((E_use_rs && InstrE[`rs]!=0) && ( // BHExt32W
							(BHExt32W_new_rt && InstrE[`rs]==InstrW[`rt]) ) ) ? 3'b100 :
							((E_use_rs && InstrE[`rs]!=0) && ( // PCplus8W
							(PCplus8W_new_rd && InstrE[`rs]==InstrW[`rd]) ||
							(PCplus8W_new_ra && InstrE[`rs]==31) ) ) ? 3'b101 :
							((E_use_rs && InstrE[`rs]!=0) && ( // CP0RstW
							(CP0RDW_new_rt && InstrE[`rs]==InstrW[`rt])) ) ? 3'b110:
							3'b000; // SrcAE

	assign F_SrcB_E = ((E_use_rt && InstrE[`rt]!=0) && ( // ALURstM
							(ALURstM_new_rd && InstrE[`rt]==InstrM[`rd]) ||
							(ALURstM_new_rt && InstrE[`rt]==InstrM[`rt]) ) ) ? 3'b001 :
							((E_use_rt && InstrE[`rt]!=0) && ( // PCplus8M
							(PCplus8M_new_rd && InstrE[`rt]==InstrM[`rd]) ||
							(PCplus8M_new_ra && InstrE[`rt]==31) ) ) ? 3'b010 :
							((E_use_rt && InstrE[`rt]!=0) && ( // ALURstW
							(ALURstW_new_rd && InstrE[`rt]==InstrW[`rd])  ||
							(ALURstW_new_rt && InstrE[`rt]==InstrW[`rt])	) ) ? 3'b011 :
							((E_use_rt && InstrE[`rt]!=0) && ( // BHExt32W
							(BHExt32W_new_rt && InstrE[`rt]==InstrW[`rt]) ) ) ? 3'b100 :
							((E_use_rt && InstrE[`rt]!=0) && ( // PCplus8W
							(PCplus8W_new_rd && InstrE[`rt]==InstrW[`rd]) ||
							(PCplus8W_new_ra && InstrE[`rt]==31) ) ) ? 3'b101 :
							((E_use_rt && InstrE[`rt]!=0) && ( // CP0RstW
							(CP0RDW_new_rt && InstrE[`rt]==InstrW[`rt])) ) ? 3'b110 :
							3'b000; // SrcBE

	assign F_WD_M = ((M_use_rt && InstrM[`rt]!=0) && ( // ALURstW
							(ALURstW_new_rd && InstrM[`rt]==InstrW[`rd]) ||
							(ALURstW_new_rt && InstrM[`rt]==InstrW[`rt]) ) ) ? 3'b001 :
						 ((M_use_rt && InstrM[`rt]!=0) && ( // BHExt32W
							(BHExt32W_new_rt && InstrM[`rt]==InstrW[`rt]) ) ) ? 3'b010 :
						 ((M_use_rt && InstrM[`rt]!=0) && ( // PCplus8W
							(PCplus8W_new_rd && InstrM[`rt]==InstrW[`rd]) ||
							(PCplus8W_new_ra && InstrM[`rt]==31) ) )? 3'b011 :
						 ((M_use_rt && InstrM[`rt]!=0) && ( // CP0RstW
							(CP0RDW_new_rt && InstrM[`rt]==InstrW[`rt]) ) ) ? 3'b100:
						 3'b000; // WDM

endmodule
