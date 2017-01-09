`timescale 1ns / 1ps
`define CUTOFF 32'h00030D40
`define ZERO   8'b10000001
`define ONE    8'b11001111
`define TWO    8'b10010010
`define THREE  8'b10000110
`define FOUR   8'b11001100
`define FIVE   8'b10100100
`define SIX    8'b10100000
`define SEVEN  8'b10001111
`define EIGHT  8'b10000000
`define NINE   8'b10000100
`define AH     8'b10001000
`define BH     8'b11100000
`define CH     8'b10110001
`define DH     8'b11000010
`define EH     8'b10110000
`define FH     8'b10111000
`define NEGATIVE 8'b11111110
/*`define ZERO   8'b11000000
`define ONE    8'b11111001
`define TWO    8'b10100100
`define THREE  8'b10110000
`define FOUR   8'b10011001
`define FIVE   8'b10010010
`define SIX    8'b10000010
`define SEVEN  8'b11111000
`define EIGHT  8'b10000000
`define NINE   8'b10010000
`define AH     8'b10001000
`define BH     8'b10000011
`define CH     8'b11000110
`define DH     8'b10100001
`define EH     8'b10000110
`define FH     8'b10001110*/
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:24:37 12/22/2016 
// Design Name: 
// Module Name:    driver_LED 
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
module driver_LED(
    input [31:0] DIn,
    input WE,
    output [31:0] RD,
    input [4:2] Addr,
    input clk,
    input reset,
    output [7:0] digital_tube0,
    output reg [3:0] digital_tube_sel0,
    output [7:0] digital_tube1,
    output reg [3:0] digital_tube_sel1,
    output [7:0] digital_tube2,
    output digital_tube_sel2
    );
	reg [31:0] group1_0;

	reg [31:0] Tcount; // count the cycles passed
	
	wire [31:0] group1_0_cmpl; // 2's complement
	assign group1_0_cmpl = (group1_0[31]) ? (~group1_0 + 1) : 
									group1_0;
	
	wire [3:0] tube0_raw;
	assign tube0_raw = (digital_tube_sel0==4'b1000) ? group1_0_cmpl[15:12] :
							 (digital_tube_sel0==4'b0100) ? group1_0_cmpl[11:8] :
							 (digital_tube_sel0==4'b0010) ? group1_0_cmpl[7:4] :
							 (digital_tube_sel0==4'b0001) ? group1_0_cmpl[3:0] :
							 4'b0;
	wire [3:0] tube1_raw;
	assign tube1_raw = (digital_tube_sel1==4'b1000) ? group1_0_cmpl[31:28] :
							 (digital_tube_sel1==4'b0100) ? group1_0_cmpl[27:24] :
							 (digital_tube_sel1==4'b0010) ? group1_0_cmpl[23:20] :
							 (digital_tube_sel1==4'b0001) ? group1_0_cmpl[19:16] :
							 4'b0;
	
	assign digital_tube0 = (reset) ? `ZERO :
								  (tube0_raw==4'h0) ? `ZERO :
								  (tube0_raw==4'h1) ? `ONE :
								  (tube0_raw==4'h2) ? `TWO :
								  (tube0_raw==4'h3) ? `THREE :
								  (tube0_raw==4'h4) ? `FOUR :
								  (tube0_raw==4'h5) ? `FIVE :
								  (tube0_raw==4'h6) ? `SIX :
								  (tube0_raw==4'h7) ? `SEVEN :
								  (tube0_raw==4'h8) ? `EIGHT :
								  (tube0_raw==4'h9) ? `NINE :
								  (tube0_raw==4'ha) ? `AH :
								  (tube0_raw==4'hb) ? `BH :
								  (tube0_raw==4'hc) ? `CH :
								  (tube0_raw==4'hd) ? `DH :
								  (tube0_raw==4'he) ? `EH :
								  (tube0_raw==4'hf) ? `FH :
								  `ZERO;
	
	assign digital_tube1 = (reset) ? `ZERO :
								  (tube1_raw==4'h0) ? `ZERO :
								  (tube1_raw==4'h1) ? `ONE :
								  (tube1_raw==4'h2) ? `TWO :
								  (tube1_raw==4'h3) ? `THREE :
								  (tube1_raw==4'h4) ? `FOUR :
								  (tube1_raw==4'h5) ? `FIVE :
								  (tube1_raw==4'h6) ? `SIX :
								  (tube1_raw==4'h7) ? `SEVEN :
								  (tube1_raw==4'h8) ? `EIGHT :
								  (tube1_raw==4'h9) ? `NINE :
								  (tube1_raw==4'ha) ? `AH :
								  (tube1_raw==4'hb) ? `BH :
								  (tube1_raw==4'hc) ? `CH :
								  (tube1_raw==4'hd) ? `DH :
								  (tube1_raw==4'he) ? `EH :
								  (tube1_raw==4'hf) ? `FH :
								  `ZERO;
	
	assign digital_tube2 = (reset) ? `ZERO :
								  (group1_0[31]) ? `NEGATIVE :
								  `ZERO;
	
	assign digital_tube_sel2 = 1'b1;
	
	assign RD = (reset) ? 0 :
					(!Addr[2]) ? group1_0:
					0;
	
	always@(posedge clk) begin
		if (reset) begin
			group1_0 <= 0;
			digital_tube_sel0 <= 4'b1111;
			digital_tube_sel1 <= 4'b1111;
			Tcount <= 0;
		end
		else begin
			if (Tcount == `CUTOFF) begin // 10msµ½ÁË
				Tcount <= 0;
				if (digital_tube_sel0 == 4'b1000)
					digital_tube_sel0 <= 4'b0100;
				else if (digital_tube_sel0 == 4'b0100)
					digital_tube_sel0 <= 4'b0010;
				else if (digital_tube_sel0 == 4'b0010)
					digital_tube_sel0 <= 4'b0001;
				else 
					digital_tube_sel0 <= 4'b1000;
					
				if (digital_tube_sel1 == 4'b1000)
					digital_tube_sel1 <= 4'b0100;
				else if (digital_tube_sel1 == 4'b0100)
					digital_tube_sel1 <= 4'b0010;
				else if (digital_tube_sel1 == 4'b0010)
					digital_tube_sel1 <= 4'b0001;
				else 
					digital_tube_sel1 <= 4'b1000;
			end
			else begin
				Tcount <= Tcount + 1;
			end
			if (WE) begin
				if (!Addr[2]) begin
					group1_0 <= DIn;
					//$display("group1_0 <= %h", DIn);
				end
			end
		end
	end
	
	
endmodule
