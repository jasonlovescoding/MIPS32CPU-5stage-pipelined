`timescale 1ns / 1ps
`define DEBUG_DEV_DATA 32'h80000000
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:48:20 12/13/2016 
// Design Name: 
// Module Name:    bridge 
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
module bridge(
    input [31:0] PrAddr, // CPU�ĵ�ַ����
    input [31:0] PrWD, // CPU���豸������
    input PrWE, // CPU��дʹ��
    output [31:0] PrRD, // �豸��CPU��д������
	 output [5:0] HWInt, // �豸�ж�����
    output DEV0WE, // �豸0�ŵ�дʹ��
    output DEV1WE, // �豸1�ŵ�дʹ��
	 output DEV2WE, // �豸2�ŵ�дʹ��
	 output DEV3WE, // �豸3�ŵ�дʹ��
	 output DEV4WE, // �豸4�ŵ�дʹ��
	 output DEV5WE, // �豸5�ŵ�дʹ��
	 input [31:0] DEV0RD, // �豸0�ŵ����ݶ���
	 input [31:0] DEV1RD, // �豸1�ŵ����ݶ���
	 input [31:0] DEV2RD, // �豸2�ŵ����ݶ���
	 input [31:0] DEV3RD, // �豸3�ŵ����ݶ���
    input [31:0] DEV4RD, // �豸4�ŵ����ݶ���
    input [31:0] DEV5RD, // �豸5�ŵ����ݶ���
	 input DEV0Int, // �豸0�ŵ��ж�����
	 input DEV1Int, // �豸1�ŵ��ж�����
	 input DEV2Int, // �豸2�ŵ��ж�����
	 input DEV3Int, // �豸3�ŵ��ж�����
	 input DEV4Int, // �豸4�ŵ��ж�����
	 input DEV5Int, // �豸5�ŵ��ж�����
	 output [31:0] DEVWD, // CPU���豸��д������
    output [4:2] DEVAddr, // CPU���豸д�����ƫ��
	 output DEV1STB, // UART��STB
	 output [4:2] DEV1Addr // UART��Addr
    );	
	assign DEV0Hit = (PrAddr[15:0]>=16'h7f00 && PrAddr[15:0]<=16'h7f0b);
	assign DEV1Hit = (PrAddr[15:0]>=16'h7f10 && PrAddr[15:0]<=16'h7f2b);
	assign DEV2Hit = (PrAddr[15:0]>=16'h7f2c && PrAddr[15:0]<=16'h7f33);
	assign DEV3Hit = (PrAddr[15:0]>=16'h7f34 && PrAddr[15:0]<=16'h7f37);
	assign DEV4Hit = (PrAddr[15:0]>=16'h7f38 && PrAddr[15:0]<=16'h7f3f);
	assign DEV5Hit = (PrAddr[15:0]>=16'h7f40 && PrAddr[15:0]<=16'h7f43);
	
	assign DEV1STB = DEV1Hit;
	assign DEV1Addr = PrAddr[4:2] - 4'b0100;
	
	assign HWInt = {DEV5Int, DEV4Int, DEV3Int, DEV2Int, DEV1Int, DEV0Int};
	
	assign DEV0WE = (PrWE && DEV0Hit);
	assign DEV1WE = (PrWE && DEV1Hit);
	assign DEV2WE = (PrWE && DEV2Hit);
	assign DEV3WE = (PrWE && DEV3Hit);
	assign DEV4WE = (PrWE && DEV4Hit);
	assign DEV5WE = (PrWE && DEV5Hit);
	
	assign PrRD = (DEV0Hit) ? DEV0RD :
					  (DEV1Hit) ? DEV1RD :
					  (DEV2Hit) ? DEV2RD :
					  (DEV3Hit) ? DEV3RD :
					  (DEV4Hit) ? DEV4RD :
					  (DEV5Hit) ? DEV5RD :
					  `DEBUG_DEV_DATA;
					  
	assign DEVWD = PrWD;
	
	assign DEVAddr = PrAddr[4:2];
	
endmodule

