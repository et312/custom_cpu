module RegisterFile (clk, write_en, write_reg, write_data, read_reg1, read_reg2, read_data1, read_data2);
	`include "define.vh"
	
	input wire clk;
	input wire write_en;
	input wire [REG_BITS-1:0] write_reg;
	input wire [WORD_SIZE-1:0] write_data;
	input wire [REG_BITS-1:0] read_reg1;
	input wire [REG_BITS-1:0] read_reg2;
	output wire [WORD_SIZE-1:0] read_data1;
	output wire [WORD_SIZE-1:0] read_data2;
	
	reg [WORD_SIZE-1:0] regs[0:2**REG_BITS-1];
	
	integer i;
	initial begin
		for (i = 0; i < 2**REG_BITS-1; i=i+1) regs[i] = 16'b0;
	end 
	
	always @(posedge clk) begin
		if (write_en) begin
			regs[write_reg] <= write_data;
		end
	end
	
	assign read_data1 = regs[read_reg1];
	assign read_data2 = regs[read_reg2];
	
endmodule