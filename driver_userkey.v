`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:15:48 12/22/2016 
// Design Name: 
// Module Name:    driver_userkey 
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
module driver_userkey(
    output [31:0] RD,
    output reset,
    input [7:0] user_key,
	 input sys_rstn
    );
	assign reset = !sys_rstn;
	assign RD = (reset) ? 0 :
					{24'b0, user_key};
	

endmodule
