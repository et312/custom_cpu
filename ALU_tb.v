`timescale 1ns/100ps
module ALU_tb;
	reg clk = 0;
	reg [15:0] in1;
	reg [15:0] in2;
	reg [2:0] ALUControl;
	reg enable = 1;

	wire [15:0] result;
	wire zero;
	wire overflow;
	
	ALU inst0(.clk(clk), .in1(in1), .in2(in2), .ALUControl(ALUControl), .enable(enable), .result(result), .zero(zero), .overflow(overflow));
	
	always #1 clk = ~clk;
	
	initial begin 
		in1 = 16'h8000;
		in2 = 16'h8000;
		ALUControl = 3'b110;
		#1;
		$display("result = %b", result);	
	end
	
endmodule