`timescale 1ns/1ps

module tb_buffer();

    logic clk;
    logic rst_n;
    logic we;
    logic trace_enable;
    logic [7:0] pc;
    logic [15:0] instr;
    logic [2:0] rd_addr;
    logic [15:0] rd_data;
    logic branch_taken;
    logic [1:0] read_addr;
    logic [7:0] out_pc;
    logic [15:0] out_instr;
    logic [2:0] out_rd_addr;
    logic [15:0] out_rd_data;
    logic out_taken;
    logic [1:0] head;

    buffer #(.DEPTH(4)) dut(.*);

    always #5 clk = ~clk;

    task put(input [7:0] p,input [15:0] i,input [2:0] r, input [15:0] d,input b);
        pc = p;
        instr = i;
        rd_addr = r;
        rd_data = d;
        branch_taken  = b;

        we = 1;
        @(posedge clk);
        #1 we = 0;
    endtask

    initial begin


        //Reset
        rst_n = 0;
        clk = 0;
        we = 0;
        trace_enable = 0;
        pc = 0;
        instr = 0;
        rd_addr = 0;
        rd_data = 0;
        branch_taken = 0;
        
        $display("=======RESET CHECKING========");
        repeat(2) @(posedge clk);
        #1;
        if (head !== 2'b0) 
            $display("Reset test failed");
        else 
            $display("Reset test passed");
        #10;



        //Single capture 


        rst_n = 1;
        #1;
        

        trace_enable = 1;
        pc = 8'd2;
        instr = 16'h0650;
        rd_addr = 3'd3;
        rd_data = 16'd8;
        branch_taken = 1'b0;

        we = 1;
        @(posedge clk);
        #1;
        we = 0;
        read_addr = 2'd0;
        #1;

        $display("head=%0d we=%b en=%b | pc=%0d instr=%h rd=%0d data=%0d t=%b",
        head, we, trace_enable, out_pc, out_instr, out_rd_addr, out_rd_data, out_taken);

        if (out_pc !== 8'd2 || out_instr !== 16'h0650 || out_rd_addr !== 3'd3 ||
            out_rd_data !== 16'd8 || out_taken !== 1'b0)
            $display("Single capture failed");
        else
            $display("Single capture passed");

        if (head !== 2'd1)
            $display("Head check failed");
        else
            $display("Head check passed");

        //Multiple capturs

        rst_n = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;

        put(8'd2,16'h0650,3'd3,16'd8,1'b0);
        put(8'd5, 16'h4702, 3'd0, 16'd0,  1'b1);
        put(8'd7, 16'h1A14, 3'd5, 16'd20, 1'b0);

        read_addr = 2'd0; #1;

        if (out_pc !== 8'd2 || out_instr !== 16'h0650 || out_rd_addr !== 3'd3 ||
            out_rd_data !== 16'd8 || out_taken !== 1'b0)
            $display("Slot 0 failed");
        else
            $display("Slot 0 passed");
        
        


        read_addr = 2'd1; #1;

        if (out_pc !== 8'd5 || out_instr !== 16'h4702 || out_rd_addr !== 3'd0 ||
            out_rd_data !== 16'd0 || out_taken !== 1'b1)
            $display("Slot 1 failed");
        else
            $display("Slot 1 passed");
        
        




        read_addr = 2'd2; #1;

        if (out_pc !== 8'd7 || out_instr !== 16'h1A14 || out_rd_addr !== 3'd5 ||
            out_rd_data !== 16'd20 || out_taken !== 1'b0)
            $display("Slot 2 failed");
        else
            $display("Slot 2 passed");
        
        if(head !== 2'd3)
            $display("Mult head check failed");
        else
            $display("Multi head check passed");




        $finish;
    end

endmodule

    