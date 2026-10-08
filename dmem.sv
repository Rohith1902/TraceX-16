module dmem #(
	parameter int ADDR_WIDTH = 8,
	parameter int DEPTH = (1<<ADDR_WIDTH)
)(
	input logic clk,
	input logic [ADDR_WIDTH-1:0] raddr,
	input logic we,
	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [15:0] wdata,
	output logic [15:0] rdata
);

	logic [15:0] memory_array [0:DEPTH -1 ];	
	assign rdata = memory_array[raddr];

	always_ff @(posedge clk) begin
		if(we) begin
			memory_array[waddr] <= wdata;
		end
	end
endmodule
