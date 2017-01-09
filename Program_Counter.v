`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:03 11/15/2016 
// Design Name: 
// Module Name:    program_counter 
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
module Program_Counter(
    input [31:0] nPC,	// ����ָ��ĵ�ַ
    input clk,	// ʱ���ź�
    input reset,	// ��ʱ�������ص���ʱ�����resetΪ1����PC��λΪ0x00003000
	 input enable, // ʹ���ź�
    output reg [31:0] PC // ����ָ��ĵ�ַ
    );
	 
	 /*initial begin
		PC = 32'h00003000; // ����ַ0x00003000
	 end*/
	 
	 always@(posedge clk) begin
		//$display("PC :%h", PC);
		 if (reset) // reset�����ȼ����
			PC <= 32'h00003000;
		 else if (enable) // ����reset,��ʹ��Ϊ1,��PC���µ�����ָ���ַ
			PC <= nPC;
	 end
	
endmodule
