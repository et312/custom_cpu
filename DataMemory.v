module DataMemory(clk, wen, waddr, wdata, raddr, rdata);
	`include "define.vh"
	
	input wire clk;
	input wire wen;
	input wire [DMEM_ADDRW-1:0] waddr;
	input wire [WORD_SIZE-1:0] wdata;
	input wire [DMEM_ADDRW-1:0] raddr;
	output [WORD_SIZE-1:0] rdata;
	
	reg [WORD_SIZE-1:0] mem [0:DMEM_DEPTH-1];
	reg [WORD_SIZE-1:0] r_rdata;
	
	always @(posedge clk) begin
		if (wen) begin
			mem[waddr] <= wdata;
		end
		
		r_rdata <= mem[raddr];
	end
	
	assign rdata = r_rdata;
endmodule