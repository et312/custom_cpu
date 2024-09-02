`timescale 1ns/100ps
module cpu_tb;
	reg clk;
	reg reset;
	
	initial begin
		clk = 0;
		reset = 0;
	end
	
	always #1 clk = ~clk;
	
	cpu cpu(.clk(clk), .reset(reset));
	
endmodule