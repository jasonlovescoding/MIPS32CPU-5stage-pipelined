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
    input [31:0] A,	// ��ȡ/д���ַ
    input [31:0] WD,	// Ҫ��д�������
	 input [3:0] BE, // ���ֽڵ�ͨ���ź�
	 input WE,	// дʹ�ܶ˿ھ������β����Ƕ�ȡ(0)����д��(1)
    input clk,	// ʱ���ź�
    input reset,	// ��reset�ź�Ϊ1ʱ������һ��ʱ�������ؽ����ݹ�0
    output [31:0] RD // ����ȡ������
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
		for (i = 0; i < 2048; i = i + 1) // ����ȫ����ʼ��Ϊ��
			DM[i] <= 0;
	end
	
	wire [31:0] RDWord = DM[A[12:2]]; 
	always@(posedge clk) begin: clk_posedge
		if (reset) begin: clk_posedge_reset // reset�����ȼ����
			integer i;
			for (i = 0; i < 2048; i = i + 1) // ����ȫ������
				DM[i] <= 0;
		end
		else begin: clk_posedge_write
			if (WE) begin // д��
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
