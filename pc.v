module pc(clk, rst, sel, pc_branch, pc_out);
	`include "define.vh"
	
	input wire clk;
	input wire rst;
	input wire sel;
	input wire [INSTR_ADDRW-1:0] pc_branch;
	output reg [INSTR_ADDRW-1:0] pc_out;
	
	always @(posedge clk or posedge rst) begin 
		if (rst) pc_out <= 'b0;
		else pc_out <= (sel ? pc_branch : pc_out + 'b1);
	end
	
endmodule