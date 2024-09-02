module adder(in1, in2, result);
	`include "define.vh"
	input wire [WORD_SIZE-1:0] in1;
	input wire [WORD_SIZE-1:0] in2;
	output reg [WORD_SIZE-1:0] result;
	
	always @(in1 or in2) begin 
		result = in1 + in2;
	end
endmodule