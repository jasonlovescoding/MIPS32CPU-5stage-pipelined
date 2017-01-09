`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:07 12/11/2016 
// Design Name: 
// Module Name:    timer 
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
module timer(
    input CLK_I, // 时钟
    input RST_I, // 复位信号
    input [4:2] ADD_I, // 地址输入
    input WE_I, // 写使能
    input [31:0] DAT_I, // 32 位数据输入
    output [31:0] DAT_O, // 32 位数据输出
    output IRQ // 中断请求
    );
	 assign IRQ = (state == INT) && CTRL[3];
	 assign DAT_O = (ADD_I[3:2]==2'b00) ? CTRL :
						 (ADD_I[3:2]==2'b01) ? PRESET :
						 (ADD_I[3:2]==2'b10) ? COUNT :
						 ILLEGAL;
						 
	reg [31:0] CTRL;
	reg [31:0] PRESET;
	reg [31:0] COUNT;
	
	parameter IDLE = 4'b0001, LOAD = 4'b0010, CNTING = 4'b0100, INT = 4'b1000;
	parameter ILLEGAL = 32'h80000000;
	reg [3:0] state;
	
	/*initial begin
		state <= IDLE;
		CTRL <= 0;
		PRESET <= 0;
		COUNT <= 0;
	end*/
	
	always@(posedge CLK_I) begin
		if (RST_I) begin
			state <= IDLE;
			CTRL <= 0;
			PRESET <= 0;
			COUNT <= 0;
		end
		else begin
			if (WE_I) begin // 写入
				if (ADD_I[3:2]==2'b00) begin
					CTRL[3:0] <= DAT_I[3:0];
					//$display("CTRL <= %h", DAT_I);
					state <= IDLE;
				end
				else if (ADD_I[3:2]==2'b01) begin
					PRESET <= DAT_I;
					//$display("PRESET <= %h", DAT_I);
					state <= IDLE;
				end
			end
			// ----模式0
			else if (CTRL[2:1]==2'b00) begin 
				case (state)
					IDLE: 
						if (CTRL[0]==1) // 开始工作
							state <= LOAD;
					LOAD: begin
						if (CTRL[0]==1) begin // 允许工作
							COUNT <= PRESET;
							if (PRESET == 0)
								state <= INT;
							else
								state <= CNTING;
						end
						else 
							state <= IDLE;
					end
					CNTING: begin
						if (CTRL[0]==1) begin // 允许工作
							COUNT <= COUNT - 1;
							if (COUNT==1) begin
								state <= INT;
								CTRL[0] <= 0; // 停止计数
							end
						end
						else
							state <= IDLE;
					end
					INT:
						if (CTRL[0]==1) begin // 允许工作
							COUNT <= PRESET;
							if (PRESET != 0)
								state <= CNTING;
						end
				endcase
			end
			// ----
			// ---模式1
			else if (CTRL[2:1]==2'b01) begin 
				case (state)
					IDLE: 
						if (CTRL[0]==1) // 开始工作
							state <= LOAD;
					LOAD: begin
						if (CTRL[0]==1) begin // 允许工作
							COUNT <= PRESET;
							if (PRESET == 0)
								state <= INT;
							else
								state <= CNTING;
						end
						else 
							state <= IDLE;
					end
					CNTING: begin
						if (CTRL[0]==1) begin // 允许工作
							COUNT <= COUNT - 1;
							if (COUNT==1) begin
								state <= INT;
								//CTRL[3] <= 1; // 允许中断
							end
						end
						else
							state <= IDLE;
					end
					INT:						
						if (CTRL[0]==1) begin // 允许工作
							COUNT <= PRESET;
							if (PRESET != 0)
								state <= CNTING;
						end
						else
							state <= IDLE;
				endcase
			end
		end
	end
endmodule
