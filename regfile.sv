module regfile(
	input logic clk,
	input logic rst_n,
	input logic [3:0] rs1_addr,
	output logic [15:0] rs1_data, 
	input logic [3:0] rs2_addr,
	output logic [15:0] rs2_data,
	input we,
	input [3:0] rd_addr,
	input [15:0] rd_data
);

logic [15:0] regs [0:7]; //Main array

assign rs1_data = regs[rs1_addr];  //Data from the main array
assign rs2_data = regs[rs2_addr];

integer i;

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for(i = 0;i<8;i+=1)
			regs[i] <= 16'b0;
	end
	else if(we) begin
		regs[rd_addr] = rd_data;
	end

end 

endmodule
