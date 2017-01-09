`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:24:54 12/22/2016 
// Design Name: 
// Module Name:    driver_dipswitch 
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
module driver_dipswitch(
    output [31:0] RD,
    input [4:2] Addr,
	 input reset,
    input [7:0] dip_switch0,
	 input [7:0] dip_switch1,
	 input [7:0] dip_switch2,
	 input [7:0] dip_switch3,
	 input [7:0] dip_switch4,
	 input [7:0] dip_switch5,
	 input [7:0] dip_switch6,
	 input [7:0] dip_switch7
    );
	wire [31:0] group3_0 = {dip_switch3, dip_switch2, dip_switch1, dip_switch0}; 
	wire [31:0] group7_4 = {dip_switch7, dip_switch6, dip_switch5, dip_switch4}; 
	
	assign RD = (reset) ? 0 :
					(Addr[4]) ? group7_4 :
					group3_0;

endmodule
