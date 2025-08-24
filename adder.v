module adder(in1, in2, clk, result);
	`include "define.vh"
	input wire [WORD_SIZE-1:0] in1;
	input wire [WORD_SIZE-1:0] in2;
	input wire clk;
	output reg [WORD_SIZE-1:0] result;
	
	always @(posedge clk) begin 
		result <= in1 + in2;
	end
endmodule