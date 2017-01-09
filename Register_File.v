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
    input [4:0] A1, // ��1������ȡ�Ĵ����ı��(+1)
    input [4:0] A2, // ��2������ȡ�Ĵ����ı��(+1)
    input [4:0] A3, // д��Ĵ����ı��(+1)
    input [31:0] WD3, // Ҫд�������
    input clk, // ʱ������
    input reset, // ��λ�ź�
    input WE3, // дʹ���ź�
    output [31:0] RD1, // ��1����������
    output [31:0] RD2  // ��2����������
    );

	reg [31:0] RF[30:0]; // ��Լһ��0�żĴ���
	assign RD1 = A1==0 ? 0 : 
					 (A1==A3 && WE3==1) ?  WD3 : // �ڲ�ת��
					 RF[A1-1];
					 
	assign RD2 = A2==0 ? 0 :
				    (A2==A3 && WE3==1) ? WD3 : // �ڲ�ת��
					 RF[A2-1];
	
	/*initial begin: init
		integer i;
	   for(i = 0; i < 31; i = i+1) 
			RF[i] = 0; // ���Ĵ�����ʼ��Ϊ0
	end*/
	
	always@(posedge clk) begin: clk_posedge
		if (reset) begin: clk_posedge_reset // ��λ
			integer i;
			for (i = 0; i < 31;i = i + 1) 
				RF[i] <= 0;
		end
		else begin // clk�������أ��ҷǸ�λ
			if (WE3) begin: clk_posedge_write // ��ʱ�������أ���дʹ������ʱд������
				if (A3!=0) begin // 0�żĴ�����д������
					RF[A3-1] <= WD3;
					$display("$%d <= %h",A3,WD3); // ÿ��ʱ�������ص���ʱ��дʹ���ź�Ϊ1(��Ҫд������ʱ)�����д���λ�ü�д���ֵ
				end
			//$display("$%d <= %h",A3,WD3); // ÿ��ʱ�������ص���ʱ��дʹ���ź�Ϊ1(��Ҫд������ʱ)�����д���λ�ü�д���ֵ				
			end
		end
	end
	
endmodule
