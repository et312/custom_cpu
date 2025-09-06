module InstructionMemory(clk, pc, instr);
	`include "define.vh"
	input wire clk;
	input wire [INSTR_ADDRW-1:0] pc;
	output reg [INSTR_SIZE-1:0] instr;
	
	reg [INSTR_SIZE-1:0] rom [0:INSTR_DEPTH-1];
	
	always @(posedge clk) begin
		instruction = rom[pc];
	end
	
	// SIMULATION ONLY - use memory initialization file for synthesis
	initial begin 
		rom[0] = 16'h8800000F; // ADDI R0, R0, #15
	end
	
endmodule