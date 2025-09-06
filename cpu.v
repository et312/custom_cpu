// RISC CPU
`default_nettype none
module cpu(clk, rst);
	`include "define.vh"
	
	input wire clk;
	input wire rst;

	// Program Counter
	wire [INSTR_ADDRW-1:0] pc;	
	pc PC_inst(.clk(clk), .rst(rst), .sel(Branch), .pc_in(pc), .pc_branch(branch_addr), .pc_out(pc));
	
	// Instruction Fetch
	wire [INSTR_SIZE-1:0] instr;
	InstructionMemory InstructionMemory(.clk(clk), .pc(pc), .instr(instr));
	
	// Instruction Decode
	wire [2:0] opcode;
	wire [3:0] funct;
	wire [REG_ADDRW-1:0] Rm, Rn, Rd, Rt;
	wire [15:0] branch_addr;
	always @() begin  
		opcode = instr[31:29];
		funct = instr[28:25];
		Rm = instr[24:22];
		Rn = instr[21:19];
		Rd = instr[18:16]; // R-type
		Rt = instr[18:16]; // LDR/STR
		Imm = instr[15:0];
		branch_addr = instr[15:0];
	end
	
	// Control Signals
	wire Reg2Loc, RegWrite, ALUSrc, Branch, MemRead, MemWrite, MemtoReg;
	control Control(.opcode(opcode), .ALUOp(ALUOp), .Reg2Loc(Reg2Loc), .RegWrite(RegWrite), .ALUSrc(ALUSrc), .Branch(Branch), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg));
	
	// Register File
	wire [WORD_SIZE-1:0] Rm_out, Rn_out, Rt_out;
	// Read port 0, 1 for R-type, read port 2 for LDR
	RegisterFile (.clk(clk), .wen0(RegWrite), .wen1(MemRead), .waddr0(Rd), .waddr1(Rt), .wdata0(ALU_out), .wdata1(DataMem_out), .raddr0(Rm), .raddr1(Rn), .raddr2(Rt), .rdata0(Rm_out), .rdata1(Rn_out), .rdata(Rt_out));
	
	// ALU
	wire [WORD_SIZE-1:0] ALU_in1, ALU_reg_in2, ALU_imm_in2;
	assign ALU_in1 = Reg2Loc ? Rt_out : Rm_out;
	assign ALU_reg_in2 = Rn_out;
	assign ALU_imm_in2 = Imm;
	reg ALU_en = 1'b1;
	wire [WORD_SIZE-1:0] ALU_out;
	wire zero, overflow;
	ALU ALU_inst(.clk(clk), .rst(rst), .en(ALU_en), .in1(ALU_in1), .reg_in2(ALU_reg_in2), .imm_in2(ALU_imm_in2), .ALUSrc(ALUSrc), .result(ALU_out), .zero(zero), .overflow(overflow));
	
	// Data Memory
	wire [WORD_SIZE-1:0] DataMem_out;
	DataMemory DataMemory_inst(.clk(clk), .wen(MemWrite), .waddr(Rt_out), .wdata(Rn_out), .raddr(Rn_out), .rdata(DataMem_out));
	
endmodule