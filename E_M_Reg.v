`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:18:12 11/24/2016 
// Design Name: 
// Module Name:    E_M_Reg 
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
module E_M_Reg(
    input [31:0] ALURstE,
    input [31:0] WDE,
    input [4:0] A3E,
	 input [31:0] InstrE,
    input [31:0] PCplus8E,
	 input clk,
	 input reset,
    output reg [31:0] ALURstM,
    output reg [31:0] WDM,
    output reg [4:0] A3M,	 
    output reg [31:0] InstrM,
    output reg [31:0] PCplus8M
    );
	 
	/*initial begin
		ALURstM <= 0;
		WDM <= 0;
		MDURstM <= 0;
		A3M <= 0;
		InstrM <= 0;
		PCplus8M <= 0;
	end*/
	
	always@(posedge clk) begin
		if (reset) begin
			ALURstM <= 0;
			WDM <= 0;
			InstrM <= 0;
			A3M <= 0;
			PCplus8M <= 0;
		end
		else begin
			ALURstM <= ALURstE;
			WDM <= WDE;
			InstrM <= InstrE;
			A3M <= A3E;
			PCplus8M <= PCplus8E;
		end
	end

endmodule
