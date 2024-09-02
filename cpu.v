// RISC CPU
module cpu(clk, reset);
	`include "define.vh"
	
	input wire clk;
	input wire reset;

	// Program Counter
	reg [WORD_SIZE-1:0] pc = 16'b0;
	reg [WORD_SIZE-1:0] one = 16'b1;
	reg [WORD_SIZE-1:0] pc_plus_1;
	
	adder PC_Adder(.in1(pc), .in2(one), .result(pc_plus_1));
	
	reg [WORD_SIZE-1:0] pc_branch;
	adder Branch_Adder(.in1(pc), .in2(offset_extend), .result(pc_branch)); 
	
	wire PCSrc; 
	assign PCSrc = Branch & zero;
	
	always @(posedge clk or posedge reset) begin
		pc <= reset ? 16'b0 : (PCSrc ? pc_branch : pc_plus_1);
	end
	
	// Instruction Fetch
	reg [INSTRUCTION_SIZE-1:0] instruction;
	InstructionMemory InstructionMemory(.clk(clk), .pc(pc), .instruction(instruction));
	
	// Instruction Decode
	// R-type: opcode[4], function[3], Rm[3], Rn[3], Rd[3], Imm[1], imm_data[15] (Data in Rn replaced by imm_data if Imm == 1)
	// LDR/STR: opcode[4], offset[6], Rn[3], Rt[3], Imm[1], imm_data[15] (Imm should be 0, no immediate data)
	// Branch: opcode[4], addr[9], Rt[3], Imm[1], imm_data[15] (Branch directly to addr specified in imm_data if Imm[1] == 1)
	reg [3:0] opcode;
	reg [REG_BITS-1:0] dest_reg, reg1, reg2;
	reg [6:0] ALUControl_in;
	reg [5:0] reg_offset;
	reg [8:0] branch_offset;
	reg Immediate;
	reg [WORD_SIZE-2:0] immediate_data; 
	always @(posedge clk) begin  
		opcode = instruction[31:28];
		reg1 = instruction[24:22];
		reg2 = instruction[21:19];
		dest_reg = instruction[18:16];
		ALUControl_in = instruction[31:25];
		reg_offset = instruction[27:22];
		branch_offset = instruction[27:19];
		Immediate = instruction[15];
		immediate_data = instruction[14:0];
	end
	
	// Control Signals
	reg [1:0] ALUOp;
	reg Reg2Loc, RegWrite, ALUSrc, Branch, MemRead, MemWrite, MemtoReg;
	control Control(.opcode(opcode), .ALUOp(ALUOp), .Reg2Loc(Reg2Loc), .RegWrite(RegWrite), .ALUSrc(ALUSrc), .Branch(Branch), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg));
	
	// Register File
	reg [REG_BITS-1:0] read_reg_2;
	always @(*) begin
		read_reg_2 = (Reg2Loc ? dest_reg : reg2);
	end
	reg [WORD_SIZE-1:0] reg_out1, reg_out2;
	RegisterFile RegisterFile(.clk(clk), .write_en(RegWrite), .write_reg(dest_reg), .write_data(writeback_data), .read_reg_1(reg1), .read_reg_2(read_reg_2), .read_data_1(reg_out1), .read_data_2(reg_out2));
	
	// Sign Extender (LDR/STR)
	reg [8:0] addr_extend_in;
	reg [WORD_SIZE-1:0] addr_extend_out;
	always @(reg2) begin
		addr_extend_in[7:3] = 5'b00000;
		addr_extend_in[2:0] = reg2;
	end
	SignExtender SignExtender_addr(.extender_in(addr_extend_in), .extender_out(addr_extend_out));
	
	// Sign Extender (Branch)
	reg [WORD_SIZE-1:0] offset_extend;
	SignExtender SignExtender_offset(.extender_in(branch_offset), .extender_out(offset_extend));
	
	// ALU Control
	reg [2:0] ALUControl_out;
	ALUControl ALUControl(.ALUControl_in(ALUControl_in), .ALUControl_out(ALUControl_out));
	
	// ALU
	wire [15:0] immediate_data_extend;
	
	assign immediate_data_extend[15] = immediate_data[14];
	assign immediate_data_extend[14:0] = immediate_data[14:0];
	
	wire [WORD_SIZE-1:0] ALU_in2;
	assign ALU_in2 = Immediate ? immediate_data_extend : (ALUSrc ? (Branch ? offset_extend : addr_extend_out) : reg_out2);
	
	reg ALU_en = 1'b1;
	reg [WORD_SIZE-1:0] ALU_result;
	reg zero, overflow;
	ALU ALU(.clk(clk), .in1(reg_out1), .in2(ALU_in2), .ALUControl(ALUControl_out), .enable(ALU_en), .result(ALU_result), .zero(zero), .overflow(overflow));
	
	// Data Memory
	reg [WORD_SIZE-1:0] mem_out;
	DataMemory DataMemory(.clk(clk), .write_en(MemWrite), .read_en(MemRead), .addr(ALU_result), .write_data(reg_out2), .read_data(mem_out));
	
	// Writeback
	reg [WORD_SIZE-1:0] writeback_data;
	always @(posedge clk) begin
		writeback_data = (MemtoReg ? mem_out : ALU_result); 
	end
	
endmodule