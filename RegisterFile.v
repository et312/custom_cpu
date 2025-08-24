module RegisterFile (clk, wen0, wen1, waddr0, waddr1, wdata0, wdata1, raddr0, raddr1, rdata0, rdata1);
	`include "define.vh"
	
	input wire clk;
	input wire wen0, wen1;
	input wire [REG_ADDRW-1:0] waddr0, waddr1;
	input wire [WORD_SIZE-1:0] wdata0, wdata1;
	input wire [REG_ADDRW-1:0] raddr0, raddr1;
	output [WORD_SIZE-1:0] rdata0, rdata1;
	
	reg [WORD_SIZE-1:0] mem [0:REG_DEPTH-1];
	reg [WORD_SIZE-1:0] r_rdata0, r_rdata1;
	
	always @(posedge clk) begin
		if (wen0) begin
			mem[waddr0] <= wdata0;
		end
		if (wen1) begin
			mem[waddr1] <= wdata1;
		end
		
		r_rdata0 <= mem[raddr0];
		r_rdata1 <= mem[raddr1];
	end
	
	assign rdata0 = r_rdata0;
	assign rdata1 = r_rdata1;
endmodule