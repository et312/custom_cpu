module control(opcode, ALUOp, Reg2Loc, RegWrite, ALUSrc, Branch, MemRead, MemWrite, MemtoReg);
	`include "define.vh"
	
	input wire [3:0] opcode;
	output reg [1:0] ALUOp;
	output reg Reg2Loc, RegWrite, ALUSrc, Branch, MemRead, MemWrite, MemtoReg;

	always @(opcode) begin
		ALUOp <= opcode[3:2];
		Reg2Loc <= opcode[2] | opcode[1];
		RegWrite <= opcode[3] | opcode[0];
		ALUSrc <= opcode[1] | opcode[0];
		Branch <= opcode[2];
		MemRead <= opcode[0];
		MemWrite <= opcode[1];
		MemtoReg <= opcode[0];
	end	
	
endmodule