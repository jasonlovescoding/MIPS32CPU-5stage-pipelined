`timescale 1ns / 1ps
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define shamt 10:6
`define imm16 15:0
`define imm26 25:0
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:49:17 11/23/2016 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk_in,
	 input sys_rstn,
	 input uart_rxd,
	 output uart_txd,
	 input [7:0] dip_switch0,
	 input [7:0] dip_switch1,
	 input [7:0] dip_switch2,
	 input [7:0] dip_switch3,
	 input [7:0] dip_switch4,
	 input [7:0] dip_switch5,
	 input [7:0] dip_switch6,
	 input [7:0] dip_switch7,
	 input [7:0] user_key,
	 output [31:0] led_light,
	 output [7:0] digital_tube2,
	 output digital_tube_sel2,
	 output [7:0] digital_tube1,
	 output [3:0] digital_tube_sel1,
	 output [7:0] digital_tube0,
	 output [3:0] digital_tube_sel0
    );
	 
	 // ----内部时钟核的输出
	 wire clk;
	 wire clk2;
	 // ----
	 
	 // ---- CPU的输出
	 wire [31:0] PrAddr;
	 wire [31:0] PrWD;
	 wire PrWE;
	 // ----
	 
	 // ---- Bridge的输出
	 wire [31:0] PrRD;
	 wire [5:0] HWInt;
	 wire DEV0WE;
	 wire DEV1WE;
	 wire DEV2WE;
	 wire DEV3WE;
	 wire DEV4WE;
	 wire DEV5WE;
	 wire [31:0] DEVWD;
	 wire [4:2] DEVAddr;
	 wire DEV1STB;
	 wire [4:2] DEV1Addr;
	 // ----
	 
	 // ---- 设备0 timer的输出
	 wire [31:0] DEV0RD;
	 wire DEV0Int;
	 // ----
	 
	 // ---- 设备1 UART的输出
	 wire [31:0] DEV1RD;
	 wire DEV1Int;
	 // ----
	 
	 // ---- 设备2 64位开关的输出
	 wire [31:0] DEV2RD;
	 wire DEV2Int = 1'b0;
	 // ----
	 
	 // ---- 设备3 32位LED的输出
	 wire [31:0] DEV3RD;
	 wire DEV3Int = 1'b0;
	 /* led_light */
	 // ----
	 
	 // ---- 设备4 LED显示屏的输出
	 wire [31:0] DEV4RD;
	 wire DEV4Int = 1'b0;
	 /*digital_tube digital_tube_sel*/
	 // ----
	 
	 // ---- 设备5 用户按键的输出
	 wire [31:0] DEV5RD;
	 wire DEV5Int = 1'b0;
	 wire reset; // 由用户产生reset信号
	 // ----
	 
	// ---- CLOCK
	//assign clk = clk_in;
	//assign clk2 = clk_in;
	CLOCK1 CLOCK(.CLK_IN1(clk_in), .CLK_OUT1(clk), .CLK_OUT2(clk2));
	// ----
	 
	// ----bridge 
	bridge Bridge(.PrAddr(PrAddr), .PrWD(PrWD), .PrWE(PrWE), .PrRD(PrRD), .HWInt(HWInt), 
					  .DEV0WE(DEV0WE), .DEV1WE(DEV1WE), .DEV2WE(DEV2WE), .DEV3WE(DEV3WE), .DEV4WE(DEV4WE), .DEV5WE(DEV5WE),
					  .DEV0RD(DEV0RD), .DEV1RD(DEV1RD), .DEV2RD(DEV2RD), .DEV3RD(DEV3RD), .DEV4RD(DEV4RD), .DEV5RD(DEV5RD),
					  .DEV0Int(DEV0Int),.DEV1Int(DEV1Int),.DEV2Int(DEV2Int),.DEV3Int(DEV3Int),.DEV4Int(DEV4Int),.DEV5Int(DEV5Int),
					  .DEVWD(DEVWD), .DEVAddr(DEVAddr), .DEV1STB(DEV1STB), .DEV1Addr(DEV1Addr));
	// ----
	
	// ----cpu
	cpu CPU(.clk(clk), .clk2(clk2), .reset(reset), .PrRD(PrRD), .HWInt(HWInt), .PrAddr(PrAddr), .PrWD(PrWD), .PrWE(PrWE));
	// ----
	
	// ----设备0 timer
	timer Timer(.CLK_I(clk), .RST_I(reset), .ADD_I(DEVAddr), .WE_I(DEV0WE), .DAT_I(DEVWD), .DAT_O(DEV0RD), .IRQ(DEV0Int));
	// ----

	// ----设备1 UART
	MiniUART MUART(.ADD_I(DEV1Addr), .DAT_I(DEVWD), .DAT_O(DEV1RD), .STB_I(DEV1STB), .WE_I(DEV1WE), 
	.CLK_I(clk), .RST_I(reset), .RxD(uart_rxd), .TxD(uart_txd), .IRQ(DEV1Int));
	// ----
	
	// ----设备2 64位开关 dipswitch
	driver_dipswitch Driver_DipSwitch(.RD(DEV2RD), .Addr(DEVAddr), .reset(reset), 
	.dip_switch0(dip_switch0), .dip_switch1(dip_switch1), 
	.dip_switch2(dip_switch2), .dip_switch3(dip_switch3), 
	.dip_switch4(dip_switch4), .dip_switch5(dip_switch5), 
	.dip_switch6(dip_switch6), .dip_switch7(dip_switch7));
	// ----
	
	// ----设备3 32位LED lights
	driver_lights Driver_Lights(.DIn(DEVWD), .WE(DEV3WE), .RD(DEV3RD), .clk(clk), .reset(reset), .led_light(led_light));
	// ----
	
	// ----设备4 LED数码管 LED
	driver_LED Driver_LED(.DIn(DEVWD), .WE(DEV4WE), .RD(DEV4RD), .Addr(DEVAddr), .clk(clk), .reset(reset), 
	.digital_tube0(digital_tube0), .digital_tube_sel0(digital_tube_sel0), 
	.digital_tube1(digital_tube1), .digital_tube_sel1(digital_tube_sel1),
	.digital_tube2(digital_tube2), .digital_tube_sel2(digital_tube_sel2));
	// ----
	
	// ----设备5 用户按键 userkey
	driver_userkey Driver_Userkey(.RD(DEV5RD), .reset(reset), .user_key(user_key), .sys_rstn(sys_rstn));
	// ----
endmodule
