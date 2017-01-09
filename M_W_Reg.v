`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:23:37 11/24/2016 
// Design Name: 
// Module Name:    M_W_Reg 
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
module M_W_Reg(
    input [31:0] ALURstM,
    input [31:0] RDM,
	 input [31:0] CP0RDM,
	 input [4:0] A3M,
    input [31:0] PCplus8M,
    input [31:0] InstrM,
	 input clk,
	 input reset,
    output reg [31:0] ALURstW,
    output reg [31:0] RDW,
    output reg [31:0] PCplus8W,
    output reg [4:0] A3W,
	 output reg [31:0] InstrW,
	 output reg [31:0] CP0RDW
    );
	
	/*initial begin
		ALURstW <= 0;
		RDW <= 0;
		PCplus8W <= 0;
		MDURstW <= 0;
		A3W <= 0;
		//WDW <= 0;
		InstrW <= 0;
		CP0RDW <= 0;
		//A1_0W <= 0;
		//RtW <= 0;
	end*/
	
	always@(posedge clk) begin
		if (reset) begin
			ALURstW <= 0;
			RDW <= 0;
			PCplus8W <= 0;
			InstrW <= 0;
			A3W <= 0;
			CP0RDW <= 0;
		end
		else begin
			ALURstW <= ALURstM;
			RDW <= RDM;
			PCplus8W <= PCplus8M;
			InstrW <= InstrM;
			A3W <= A3M;
			CP0RDW <= CP0RDM;
		end
	end

endmodule
