module ALUControl(ALUControl_in, ALUControl_out);
	input wire [6:0] ALUControl_in;
	output reg [2:0] ALUControl_out;
	
	always @(ALUControl_in) begin
		case (ALUControl_in[6:5]) 
			2'b00: ALUControl_out = 3'b100;
			2'b01: ALUControl_out = 3'b111;
			2'b10: ALUControl_out = ALUControl_in[2:0];
			default: ALUControl_out = 3'b111;

		endcase
	end
endmodule