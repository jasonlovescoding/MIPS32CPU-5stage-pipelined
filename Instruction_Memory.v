`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:20:35 11/14/2016 
// Design Name: 
// Module Name:    IFU 
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
module Instruction_Memory(
    input [31:0] PC,	// 本条指令在IM中的地址
	 input clk,
    output [31:0] Instr	// 本次从IM中取出的指令
    );
	 /*wire [31:0] addr = PC - 32'h00003000;
	 wire [31:0] handleraddr = PC - 32'h00004180;
	 wire [31:0] instr;
	 wire [31:0] handler;
	 IM_counter IM(.clka(clk), .wea(1'b0), .addra(addr[12:2]), .dina(0), .douta(instr));
	 IM_counter_handler EH(.clka(clk), .wea(1'b0), .addra(handleraddr[12:2]), .dina(0), .douta(hander));
	 assign Instr = (PC < 32'h4000) ? instr :
						 handler;*/
	 wire [31:0] addr = PC - 32'h00003000;
	 //IM_counter_uart IM(.clka(clk), .wea(1'b0), .addra(addr[12:2]), .dina(0), .douta(Instr));
	 IM_calc_uart IM(.clka(clk), .wea(1'b0), .addra(addr[12:2]), .dina(0), .douta(Instr));
	 //IM_calc IM(.clka(clk), .wea(1'b0), .addra(addr[12:2]), .dina(0), .douta(Instr));
	 //IM_counter IM(.clka(clk), .wea(1'b0), .addra(addr[12:2]), .dina(0), .douta(Instr));
	 //IM_uart IM(.clka(clk), .wea(1'b0), .addra(addr[12:2]), .dina(0), .douta(Instr));
	 //IM_uarts IM(.clka(clk), .wea(1'b0), .addra(addr[12:2]), .dina(0), .douta(Instr));
	 //IM_updateLED IM(.clka(clk), .wea(1'b0), .addra(addr[12:2]), .dina(0), .douta(Instr));
	/*reg [31:0] IM[2047:0];
	reg [31:0] EH[2047:0];
	wire [31:0] addr = PC - 32'h00003000;
	wire [31:0] handleraddr = PC - 32'h00004180;
	initial begin: init
		integer i;
		for(i = 0; i < 2048; i = i+1) begin
			IM[i] = 0; // 初始化为0 
		end
		$readmemh("calc.txt", IM);
		$readmemh("counter_handler.txt", EH);
	end
	
	
	assign Instr = (PC<32'h4000) ? IM[addr[12:2]] :
						EH[handleraddr[12:2]];*/
endmodule
