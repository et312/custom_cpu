`timescale 1ns/100ps

module pc_tb();
	reg clk = 0;
	reg rst = 1;
	reg branch = 0;
	reg [11:0] branch_addr = 11'b10101010101;
	reg [11:0] pc_out;

	always #1 clk=~clk;

	pc pc_inst(.clk(clk), .rst(rst), .sel(branch), .pc_branch(branch_addr), .pc_out(pc_out));
	
	initial begin
	#5; 
	rst = 0;
	
	#10;
	branch = 1;
	#5;
	branch = 0;
	#10;
	
	$stop;
	end

endmodule