`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:14 11/14/2016 
// Design Name: 
// Module Name:    DM 
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
module Data_Memory(
    input [31:0] A,	// 读取/写入地址
    input [31:0] WD,	// 要被写入的数据
	 input [3:0] BE, // 按字节的通道信号
	 input WE,	// 写使能端口决定本次操作是读取(0)还是写入(1)
    input clk,	// 时钟信号
    input reset,	// 当reset信号为1时，在下一个时钟上升沿将数据归0
    output [31:0] RD // 被读取的数据
    );
	 wire [3:0] ByteE = (WE) ? BE :
								4'b0;
	 IP_DM DM(.clka(clk), .rsta(reset), .wea(ByteE), .addra(A[12:2]), .dina(WD), .douta(RD));
	 
	/*reg [31:0] DM[2047:0];
	assign RD = (BE == 4'b1111) ? DM[A[12:2]] :
					(BE == 4'b0001) ? {24'b0, DM[A[12:2]][7:0]} :
					(BE == 4'b0010) ? {24'b0, DM[A[12:2]][15:8]} :
					(BE == 4'b0100) ? {24'b0, DM[A[12:2]][23:16]} :
					(BE == 4'b1000) ? {24'b0, DM[A[12:2]][31:24]} :
					(BE == 4'b0011) ? {16'b0, DM[A[12:2]][15:0]} :
					(BE == 4'b1100) ? {16'b0, DM[A[12:2]][31:16]} :
					DM[A[12:2]];
					
	initial begin: init
		integer i;
		for (i = 0; i < 2048; i = i + 1) // 数据全部初始化为零
			DM[i] <= 0;
	end
	
	wire [31:0] RDWord = DM[A[12:2]]; 
	always@(posedge clk) begin: clk_posedge
		if (reset) begin: clk_posedge_reset // reset的优先级最高
			integer i;
			for (i = 0; i < 2048; i = i + 1) // 数据全部清零
				DM[i] <= 0;
		end
		else begin: clk_posedge_write
			if (WE) begin // 写入
				if (BE[3])
					DM[A[12:2]][31:24] <= WD[31:24];
				if (BE[2])
					DM[A[12:2]][23:16] <= WD[23:16];
				if (BE[1])
					DM[A[12:2]][15:8] <= WD[15:8];	
				if (BE[0])
					DM[A[12:2]][7:0] <= WD[7:0];	
				if (BE == 4'b1111) begin
					DM[A[12:2]] <= WD;
					$display("*%h <= %h", A, WD);
				end
				else if (BE == 4'b0001) begin
					DM[A[12:2]][7:0] <= WD[7:0];
					$display("*%h <= %h", A, WD[7:0]);
					//$display("*%h <= %h", A, {24'b0, WD[7:0]});
				end
				else if (BE == 4'b0010) begin
					DM[A[12:2]][15:8] <= WD[7:0];
					$display("*%h <= %h", A, WD[7:0]);
					//$display("*%h <= %h", A, {24'b0, WD[7:0]});
				end
				else if (BE == 4'b0100) begin
					DM[A[12:2]][23:16] <= WD[7:0];
					$display("*%h <= %h", A, WD[7:0]);
					//$display("*%h <= %h", A, {24'b0, WD[7:0]});
				end	
				else if (BE == 4'b1000) begin
					DM[A[12:2]][31:24] <= WD[7:0];
					$display("*%h <= %h", A, WD[7:0]);
					//$display("*%h <= %h", A, {24'b0, WD[7:0]});
				end	
				else if (BE == 4'b0011) begin
					DM[A[12:2]][15:0] <= WD[15:0];
					$display("*%h <= %h", A, WD[15:0]);
					//$display("*%h <= %h", A, {16'b0, WD[15:0]});
				end	
				else if (BE == 4'b1100) begin
					DM[A[12:2]][31:16] <= WD[15:0];
					$display("*%h <= %h", A, WD[15:0]);
					//$display("*%h <= %h", A, {16'b0, WD[15:0]});
				end		
			end
		end
	end*/
	
endmodule
