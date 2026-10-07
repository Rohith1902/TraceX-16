`timescale 1ns/1ps

module tb_dmem;

	logic clk;
	logic [7:0] raddr;
	logic we;
	logic [7:0] waddr;
	logic [15:0] wdata;
	logic [15:0] rdata;
		
	dmem dut(

	.clk(clk),
	.raddr(raddr),
	.waddr(waddr),
	.we(we),
	.wdata(wdata),
	.rdata(rdata)
);

always #5 clk = ~clk;

initial begin 
	clk = 0;


	we = 0;
	waddr = 8'd0;
	wdata = 16'd0;
	raddr = 8'd10;

	@(posedge clk);


	//Write 0xBEEF into address 11
	we = 1;
	waddr = 8'd11;
	wdata = 16'hBEEF;
	@(posedge clk);

	we =0;

	raddr = 8'd11;
	#1;
	$display("Raddr = 11 -> rdata = %h (expected BEEF)",rdata);

	$finish;
end


endmodule

