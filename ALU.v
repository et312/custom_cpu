module ALU(clk, rst, en, in1, reg_in2, imm_in2, ALUSrc, result, zero, overflow);
	`include "define.vh"
	
	// funct Table:
	// 0000: AND
	// 0001: OR
	// 0010: XOR
	// 0011: LSL
	// 0100: ADD
	// 0101: MUL
	// 0110: SUB
	// 0111: NOP
	// 1000: NAND
	// 1001: NOR
	// 1010: XNOR
	// 1011: LSR
	// 1100: ==
	// 1101: == 0
	
	// Consider changing result bit width
	input wire clk;
	input wire rst;
	input wire en;
	input wire [WORD_SIZE-1:0] in1;
	input wire [WORD_SIZE-1:0] reg_in2;
	input wire [WORD_SIZE-1: 0] imm_in2;
	input wire [3:0] funct;
	input wire ALUSrc;
	output reg [WORD_SIZE-1:0] result;
	output reg zero, overflow;
	
	wire [WORD_SIZE-1:0] in2; 
	assign in2 = ALUSrc ? imm_in2 : reg_in2;
	
	wire [WORD_SIZE-1:0] add_res, sub_res;
	assign add_res = in1 + in2;
	assign sub_res = in1 - in2;
	
	
	always @(posedge clk) begin
		if (rst) begin 
		result <= 'b0;
		zero <= 1'b0;
		overflow <= 1'b0;
		end else begin
			if (enable) begin
			case (funct) 
				4'b0000: result <= in1 & in2;
				4'b0001: result <= in1 | in2;
				4'b0010: result <= in1 ^ in2; 
				4'b0011: result <= in1 << in2;
				4'b0100: begin
					result <= add_res[WORD_SIZE-1:0];
					overflow <= (in1[WORD_SIZE-1] ^ in2[WORD_SIZE-1]) ? 1'b0 : (add_res[WORD_SIZE-1] ^ in1[WORD_SIZE-1]);
					end
				4'b0101: begin 
					result <= in1 * in2;
					overflow <= (16'hFFFF & (mult_res >> WORD_SIZE)) | (in1[WORD_SIZE-1] ^ in2[WORD_SIZE-1]) ? 1'b0 : (result[WORD_SIZE-1] ^ in1[WORD_SIZE-1]);
					end
				4'b0110: begin 
					result <= in1 - in2;
					overflow <= (in1[WORD_SIZE-1] ^ in2[WORD_SIZE-1]) ? (sub_res[WORD_SIZE-1] ^ in1[WORD_SIZE-1]) : 1'b0;
					end
				4'b0111: result <= result;
				4'b1000: result <= ~(in1 & in2);
				4'b1001: result <= ~(in1 | in2);
				4'b1010: result <= ~(in1 ^ in2);
				4'b1011: result <= in1 >> in2;
				4'b1100: result <= (in1 == in2) ? 1'b1 : 1'b0;
				4'b1101: result <= (in1 == 'b0) ? 1'b1 : 1'b0;
				default: result <= result;
			endcase
			end
		end
	end
	
endmodule