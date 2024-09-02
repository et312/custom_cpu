module InstructionMemory(clk, pc, instruction);
	`include "define.vh"
	input wire clk;
	input wire [WORD_SIZE-1:0] pc;
	output reg [INSTRUCTION_SIZE-1:0] instruction;
	
	reg [INSTRUCTION_SIZE-1:0] rom [0:2**15-1];
	
	always @(posedge clk) begin
		instruction = rom[pc];
	end
	
	// SIMULATION ONLY
	initial begin 
		rom[0] = 16'h8800000F; // ADDI R0, R0, #15
	end
	
endmodule