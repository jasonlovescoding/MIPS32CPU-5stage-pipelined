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
    input [31:0] nPC,	// 下条指令的地址
    input clk,	// 时钟信号
    input reset,	// 在时钟上升沿到来时，如果reset为1，将PC复位为0x00003000
	 input enable, // 使能信号
    output reg [31:0] PC // 本条指令的地址
    );
	 
	 /*initial begin
		PC = 32'h00003000; // 基地址0x00003000
	 end*/
	 
	 always@(posedge clk) begin
		//$display("PC :%h", PC);
		 if (reset) // reset的优先级最高
			PC <= 32'h00003000;
		 else if (enable) // 不用reset,且使能为1,则将PC更新到下条指令地址
			PC <= nPC;
	 end
	
endmodule
