module SignExtender(extender_in, extender_out);
	input wire [8:0] extender_in;
	output wire [15:0] extender_out;
	
	assign extender_out[8:0] = extender_in;
	assign extender_out[15:9] = {7{extender_in[8]}};
	
endmodule