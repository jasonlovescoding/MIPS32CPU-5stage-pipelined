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
    input CLK_I, // ʱ��
    input RST_I, // ��λ�ź�
    input [4:2] ADD_I, // ��ַ����
    input WE_I, // дʹ��
    input [31:0] DAT_I, // 32 λ��������
    output [31:0] DAT_O, // 32 λ�������
    output IRQ // �ж�����
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
			if (WE_I) begin // д��
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
			// ----ģʽ0
			else if (CTRL[2:1]==2'b00) begin 
				case (state)
					IDLE: 
						if (CTRL[0]==1) // ��ʼ����
							state <= LOAD;
					LOAD: begin
						if (CTRL[0]==1) begin // ������
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
						if (CTRL[0]==1) begin // ������
							COUNT <= COUNT - 1;
							if (COUNT==1) begin
								state <= INT;
								CTRL[0] <= 0; // ֹͣ����
							end
						end
						else
							state <= IDLE;
					end
					INT:
						if (CTRL[0]==1) begin // ������
							COUNT <= PRESET;
							if (PRESET != 0)
								state <= CNTING;
						end
				endcase
			end
			// ----
			// ---ģʽ1
			else if (CTRL[2:1]==2'b01) begin 
				case (state)
					IDLE: 
						if (CTRL[0]==1) // ��ʼ����
							state <= LOAD;
					LOAD: begin
						if (CTRL[0]==1) begin // ������
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
						if (CTRL[0]==1) begin // ������
							COUNT <= COUNT - 1;
							if (COUNT==1) begin
								state <= INT;
								//CTRL[3] <= 1; // �����ж�
							end
						end
						else
							state <= IDLE;
					end
					INT:						
						if (CTRL[0]==1) begin // ������
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
