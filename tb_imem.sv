`timescale 1ns/1ps

module tb_imem;

	logic [7:0] addr;
	logic [15:0]instr;

	imem_1 dut(
		.addr(addr),
		.instr(instr)
);


	initial begin 

		dut.memory_array[3] = 16'hABCD;
		dut.memory_array[5] = 16'h1234;

		addr = 8'd3;
		#1;
		$display("addr = 3 -> instr = %h (expected ABCD)",instr);

		addr = 8'd5;
		#1;
		$display("addr = 5 -> instr = %h (expected 1234)",instr);
	
		$finish;

	end
	
endmodule
