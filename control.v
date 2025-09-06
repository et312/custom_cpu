module control(opcode, ALUOp, Reg2Loc, RegWrite, ALUSrc, Branch, MemRead, MemWrite, MemtoReg);
	`include "define.vh"
	
	input wire [2:0] opcode;
	output reg Reg2Loc, RegWrite, ALUSrc, Branch, MemRead, MemWrite, MemtoReg;

	always @(*) begin
		case (opcode)
			3'b000: begin // R-type
				Reg2Loc <= 1'b0;
				RegWrite <= 1'b1;
				ALUSrc <= 1'b0;
				Branch <= 1'b0;
				MemRead <= 1'b0;
				MemWrite <= 1'b0;
				MemtoReg <= 1'b0;
			end
			3'b001: begin // R-type (Imm)
				Reg2Loc <= 1'b0;
				RegWrite <= 1'b1;
				ALUSrc <= 1'b1;
				Branch <= 1'b0;
				MemRead <= 1'b0;
				MemWrite <= 1'b0;
				MemtoReg <= 1'b0;
			end
			3'b010: begin // LDR
				Reg2Loc <= 1'b0;
				RegWrite <= 1'b1;
				ALUSrc <= 1'b1;
				Branch <= 1'b0;
				MemRead <= 1'b1;
				MemWrite <= 1'b0;
				MemtoReg <= 1'b1;
			end
			3'b011: begin // STR
				Reg2Loc <= 1'b1;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b1;
				Branch <= 1'b0;
				MemRead <= 1'b0;
				MemWrite <= 1'b1;
				MemtoReg <= 1'b0;
			end 
			3'b100: begin // B
				Reg2Loc <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				Branch <= 1'b1;
				MemRead <= 1'b0;
				MemWrite <= 1'b0;
				MemtoReg <= 1'b0;
			end
			// TODO: Implement EQ/NEQ logic later
			3'b101: begin // BEQ
				Reg2Loc <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				Branch <= 1'b1;
				MemRead <= 1'b0;
				MemWrite <= 1'b0;
				MemtoReg <= 1'b0;
			end
			3'b110: begin // BNE
				Reg2Loc <= 1'b0;
				RegWrite <= 1'b0;
				ALUSrc <= 1'b0;
				Branch <= 1'b1;
				MemRead <= 1'b0;
				MemWrite <= 1'b0;
				MemtoReg <= 1'b0;
			end
			default: begin
				Reg2Loc <= Reg2Loc;
				RegWrite <= RegWrite;
				ALUSrc <= ALUSrc;
				Branch <= Branch;
				MemRead <= MemRead;
				MemWrite <= MemWrite;
				MemtoReg <= MemtoReg;
			end
			default: 
		endcase
	end
	
endmodule