`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:59:47 12/22/2016 
// Design Name: 
// Module Name:    driver_lights 
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
module driver_lights(
    input [31:0] DIn,
    input WE,
    output [31:0] RD,
    input clk,
    input reset,
    output reg [31:0] led_light
    );
	 
	assign RD = (reset) ? 0:
					led_light;
	
	always@(posedge clk) begin
		if (reset)
			led_light <= 0;
		else if (WE)
			led_light <= DIn;
	end

endmodule
