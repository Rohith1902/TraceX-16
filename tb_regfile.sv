//Still Errors





`timescale 1ns/1ps

module tb_regfile();
    logic clk;
	logic rst_n;
	logic [3:0] rs1_addr;
	logic [15:0] rs1_data; 
	logic [3:0] rs2_addr;
	logic [15:0] rs2_data;
	logic we;
	logic [3:0] rd_addr;
	logic [15:0] rd_data;

    regfile dut(
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(rs1_addr),
        .rs1_data(rs1_data),
        .rs2_addr(rs2_addr),
        .rs2_data(rs2_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .we(we)
    );
    
    always #5 clk = ~clk;

    initial begin
        clk = 0;

        //1.Hold reset 

        rst_n = 0;
        we = 0;
        rd_addr = 4'd0;
        rd_data = 16'd0;
        rs1_addr = 4'd0;
        rs2_addr = 4'd0;

        #10;

        //Check 1 - everything should read zero after reset 

        rs1_addr = 4'd3;
        #2;
        $display("After reset , R3 = %d (expected 0)",rs1_data);
        if (rs1_data == 16'd0) begin
            $display("PASS");
        end
        else begin
            $display("FAIL");
        end
        //2.Release reset then write 0xABCD into R3

        rst_n = 1;
        we = 1;
        rd_addr = 4'd3;
        rs1_addr = 4'd3;
        rd_data = 16'hABCD;

        @(posedge clk);
        #10;
        we = 0;

        rs1_addr = 4'd3;
        #2;
        $display("R3 = %h (expected ABCD)", rs1_data);

        if (rs1_data == 16'hABCD) begin
            $display("PASS");
        end
        else begin 
            $display("FAIL");
        end

        //3.Again writing in R7

        we = 1;
        rd_addr = 4'd7;
        rd_data = 16'h1234;

        @(posedge clk);
        #1;
        we = 0;

        rs1_addr = 4'd7;
        #2;
        $display("R7 = %h (expected 1234)", rs1_data);

        if (rs1_data == 16'h1234) begin
            $display("PASS");
        end
        else begin 
            $display("FAIL");
        end


        @(posedge clk);

        rs1_addr = 4'd3;
        rs2_addr = 4'd7;

        #1;

        $display("R3 = %h (expected ABCD), R7 = %h (1234)",rs1_data,rs2_data);

        $finish;



    end

endmodule



