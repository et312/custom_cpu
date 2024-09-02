module ALU(clk, in1, in2, ALUControl, enable, result, zero, overflow);
	`include "define.vh"
	
	// ALUControl Table:
	// 000: AND
	// 001: OR
	// 010: XOR
	// 011: LSL
	// 100: ADD
	// 101: MUL
	// 110: SUB
	// 111: Pass-through in2
	
	input wire clk;
	input wire [WORD_SIZE-1:0] in1;
	input wire [WORD_SIZE-1:0] in2;
	input wire [2:0] ALUControl;
	input wire enable;
	output reg [WORD_SIZE-1:0] result;
	output reg zero, overflow;
	
	reg [31:0] mult_res;
	
	initial zero = 1'b0;
	initial overflow = 1'b0;
	
	always @(posedge clk) begin
		if (enable) begin
		case (ALUControl) 
			3'b000: result = in1 & in2;
			3'b001: result = in1 | in2;
			3'b010: result = in1 ^ in2; 
			3'b011: result = in1 << in2;
			3'b100: begin
				result = in1 + in2;
				overflow = (in1[WORD_SIZE-1] ^ in2[WORD_SIZE-1]) ? 1'b0 : (result[WORD_SIZE-1] ^ in1[WORD_SIZE-1]);
				end
			3'b101: begin 
				mult_res = in1 * in2;
				result = mult_res;
				overflow = (16'hFFFF & (mult_res >> WORD_SIZE)) | (in1[WORD_SIZE-1] ^ in2[WORD_SIZE-1]) ? 1'b0 : (result[WORD_SIZE-1] ^ in1[WORD_SIZE-1]);
				end
			3'b110: begin 
				result = in1 - in2;
				overflow = (in1[WORD_SIZE-1] ^ in2[WORD_SIZE-1]) ? (result[WORD_SIZE-1] ^ in1[WORD_SIZE-1]) : 1'b0;
				end
			3'b111: result = in2;
			default: result = in2;
		endcase
		zero = !result;
		end
	end
	
endmodule