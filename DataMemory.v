module DataMemory(clk, write_en, read_en, addr, write_data, read_data);
	`include "define.vh"
	
	input wire clk;
	input wire write_en, read_en;
	input wire [MEM_ADDR_BITS-1:0] addr;
	input wire [WORD_SIZE-1:0] write_data;
	output reg [WORD_SIZE-1:0] read_data;
	
	reg [WORD_SIZE-1:0] memory [0:2**MEM_ADDR_BITS-1];
	
	// memory[0:15] reserved for register data
	
	always @(posedge clk) begin
		if (write_en) begin
			memory[addr] <= write_data;
		end
		if (read_en) begin
			read_data <= memory[addr];
		end
	end

endmodule