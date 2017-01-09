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
    input [31:0] PrAddr, // CPU的地址总线
    input [31:0] PrWD, // CPU给设备的数据
    input PrWE, // CPU的写使能
    output [31:0] PrRD, // 设备给CPU的写入数据
	 output [5:0] HWInt, // 设备中断请求
    output DEV0WE, // 设备0号的写使能
    output DEV1WE, // 设备1号的写使能
	 output DEV2WE, // 设备2号的写使能
	 output DEV3WE, // 设备3号的写使能
	 output DEV4WE, // 设备4号的写使能
	 output DEV5WE, // 设备5号的写使能
	 input [31:0] DEV0RD, // 设备0号的数据读出
	 input [31:0] DEV1RD, // 设备1号的数据读出
	 input [31:0] DEV2RD, // 设备2号的数据读出
	 input [31:0] DEV3RD, // 设备3号的数据读出
    input [31:0] DEV4RD, // 设备4号的数据读出
    input [31:0] DEV5RD, // 设备5号的数据读出
	 input DEV0Int, // 设备0号的中断请求
	 input DEV1Int, // 设备1号的中断请求
	 input DEV2Int, // 设备2号的中断请求
	 input DEV3Int, // 设备3号的中断请求
	 input DEV4Int, // 设备4号的中断请求
	 input DEV5Int, // 设备5号的中断请求
	 output [31:0] DEVWD, // CPU给设备的写入数据
    output [4:2] DEVAddr, // CPU给设备写入的字偏移
	 output DEV1STB, // UART的STB
	 output [4:2] DEV1Addr // UART的Addr
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

