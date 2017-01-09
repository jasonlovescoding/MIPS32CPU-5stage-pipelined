`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:42 12/13/2016 
// Design Name: 
// Module Name:    CoProcessor0 
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
module CoProcessor0(
    input [4:0] A1, // 读寄存器号
    input [4:0] A2, // 写寄存器号
    input [31:0] WD2,
    input [31:0] PC, 
    input [6:2] ExcCode,
    input [7:2] HWInt,
    input WE,
    input EXLSet,
    input EXLClr,
    input clk,
    input reset,
    output IntReq,
    output reg [31:0] EPC,
    output [31:0] RD
    );
	assign IntReq = (|(SR[15:10] & HWInt[7:2])) & SR[0] & !SR[1];
	assign RD = (A1==12) ? SR :
					(A1==13) ? Cause :
					(A1==14) ? EPC :
					(A1==15) ? PRId :	
					0;
	reg [31:0] SR;
	reg [31:0] Cause;
	reg [31:0] PRId;
	
	/*initial begin
		SR <= 32'h0000ff11;
		//SR <= 0;
		Cause <= 0;
		EPC <= 0;
		PRId <= 32'h66666666;
	end*/
	
	always@(posedge clk) begin
		if (reset) begin
			SR <= 32'h0000ff11;
			//SR <= 0;
			Cause <= 0;
			EPC <= 0;
			PRId <= 0;
		end
		else begin
			Cause[15:10] <= HWInt[7:2]; 
			//$display("Cause[15:10] <= %h",HWInt[7:2]);
			if (WE) begin
				if (A2==12) begin
					//SR <= DIn; 
					{ SR[15:10], SR[1:0]} <= {WD2[15:10], WD2[1:0]};
					//$display("SR <= %h", {16'b0, WD2[15:10], 8'b0, WD2[1:0]});
				end
				else if (A2==13) begin
					Cause[15:10] <= WD2[15:10];
				end
				else if (A2==14)
					EPC <= WD2;
			end
			else if (EXLClr)
				SR[1] <= 0;
			else if (IntReq) begin // 遇到需要中断的情况了
				Cause[6:2] <= ExcCode[6:2]; // ExcCode存入
				SR[1] <= 1; // EXL置位
				EPC <= PC; // 保存恰当的PC
			end
		end
	end

endmodule
