`timescale 1ns/1ps

module tb_core();

    logic clk;
    logic rst_n;

    core dut(
        .clk(clk),
        .rst_n(rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        $readmemh("program.hex", dut.imem_inst.memory_array);
        repeat(2) @(posedge clk);
        @(negedge clk);
        rst_n = 1;


        repeat(11) @(posedge clk);
        #1;


        //Checking  
        $display("PC       = %0d", dut.pc);
        $display("PC_DE    = %0d", dut.pc_de);
        $display("instr_f  = %h", dut.instr_f);
        $display("instr_de = %h", dut.instr_de);
        

        $finish;

    end

endmodule
