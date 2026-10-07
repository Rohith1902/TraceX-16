`timescale 1ns/1ps

module imem_1 #(
	parameter int ADDR_WIDTH = 8,
	parameter int DEPTH = (1 << ADDR_WIDTH)
)(
	input logic [ADDR_WIDTH-1:0]  addr,
	output logic [15:0] instr
);
	logic [15:0] memory_array [0:DEPTH-1];
	assign instr = memory_array[addr];
endmodule
