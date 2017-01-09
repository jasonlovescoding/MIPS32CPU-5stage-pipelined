`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:22:14 11/14/2016 
// Design Name: 
// Module Name:    GRF 
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
module Register_File (
    input [4:0] A1, // 第1个被读取寄存器的标号(+1)
    input [4:0] A2, // 第2个被读取寄存器的标号(+1)
    input [4:0] A3, // 写入寄存器的标号(+1)
    input [31:0] WD3, // 要写入的数据
    input clk, // 时钟数据
    input reset, // 复位信号
    input WE3, // 写使能信号
    output [31:0] RD1, // 第1个被读数据
    output [31:0] RD2  // 第2个被读数据
    );

	reg [31:0] RF[30:0]; // 节约一个0号寄存器
	assign RD1 = A1==0 ? 0 : 
					 (A1==A3 && WE3==1) ?  WD3 : // 内部转发
					 RF[A1-1];
					 
	assign RD2 = A2==0 ? 0 :
				    (A2==A3 && WE3==1) ? WD3 : // 内部转发
					 RF[A2-1];
	
	/*initial begin: init
		integer i;
	   for(i = 0; i < 31; i = i+1) 
			RF[i] = 0; // 各寄存器初始化为0
	end*/
	
	always@(posedge clk) begin: clk_posedge
		if (reset) begin: clk_posedge_reset // 复位
			integer i;
			for (i = 0; i < 31;i = i + 1) 
				RF[i] <= 0;
		end
		else begin // clk的上升沿，且非复位
			if (WE3) begin: clk_posedge_write // 在时钟上升沿，在写使能允许时写入数据
				if (A3!=0) begin // 0号寄存器的写被丢弃
					RF[A3-1] <= WD3;
					$display("$%d <= %h",A3,WD3); // 每个时钟上升沿到来时若写使能信号为1(即要写入数据时)则输出写入的位置及写入的值
				end
			//$display("$%d <= %h",A3,WD3); // 每个时钟上升沿到来时若写使能信号为1(即要写入数据时)则输出写入的位置及写入的值				
			end
		end
	end
	
endmodule
