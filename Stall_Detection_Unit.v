`timescale 1ns / 1ps
`define rs 25:21
`define rt 20:16
`define rd 15:11
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:40:25 11/23/2016 
// Design Name: 
// Module Name:    Stall_Detection_Unit 
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
module Stall_Detection_Unit(
    input [31:0] InstrD,
    input [31:0] InstrE,
    input [31:0] InstrM,
	 input IntReq,
    output stall
    );
	 
	Instruction_Decoder ID_D(.Instr(InstrD), .cal_r(cal_r_D), .cal_s(cal_s_D), .cal_il(cal_il_D), .cal_ia(cal_ia_D), 
									 .load(load_D), .store(store_D), .b_cmp(b_cmp_D), .b_cmpz(b_cmpz_D), .j(j_D), 
									 .jal(jal_D), .jr(jr_D), .jalr(jalr_D), 
									 .eret(eret_D));
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
	wire eret_D;
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
	
	// 停顿条件判断
	wire rs_use_1_D = cal_r_D || cal_il_D || cal_ia_D || load_D || store_D;
	wire rs_use_0_D = b_cmp_D || b_cmpz_D || jr_D || jalr_D;
   wire rt_use_1_D = cal_r_D || cal_s_D;
	wire rt_use_0_D = b_cmp_D;

	wire rd_new_1_E = cal_r_E || cal_s_E;
	wire rt_new_1_E = cal_il_E || cal_ia_E;
	wire rt_new_2_E = load_E || mfc0_E;
	wire rt_new_1_M = load_M || mfc0_M;

	wire stall_rs = InstrD[`rs]!=0 && (
						(rs_use_1_D && rt_new_2_E && InstrD[`rs]==InstrE[`rt]) ||
						(rs_use_0_D && rd_new_1_E && InstrD[`rs]==InstrE[`rd]) ||
						(rs_use_0_D && rt_new_1_E && InstrD[`rs]==InstrE[`rt]) ||
						(rs_use_0_D && rt_new_2_E && InstrD[`rs]==InstrE[`rt]) ||
						(rs_use_0_D && rt_new_1_M && InstrD[`rs]==InstrM[`rt]));

	wire stall_rt = InstrD[`rt]!=0 && (
						(rt_use_1_D && rt_new_2_E && InstrD[`rt]==InstrE[`rt]) ||
						(rt_use_0_D && rd_new_1_E && InstrD[`rt]==InstrE[`rd]) ||
						(rt_use_0_D && rt_new_1_E && InstrD[`rt]==InstrE[`rt]) ||
						(rt_use_0_D && rt_new_2_E && InstrD[`rt]==InstrE[`rt]) ||
						(rt_use_0_D && rt_new_1_M && InstrD[`rt]==InstrM[`rt]));
	
	wire stall_cp0 = eret_D && (
							(mtc0_E && InstrE[`rd]==14) || 
							(mtc0_M && InstrM[`rd]==14) ); // EPC的修改冲突了

	assign stall = !IntReq && (stall_rs || stall_rt || stall_cp0);
	
endmodule
