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

        repeat(2) @(posedge clk);
        @(negedge clk);
        rst_n = 0;

        $readmemh("program.hex",dut.imem_1.memory_array);

        repeat(30) @(posedge clk);
        #1;


        //Checking Registers 
        $display("R1 = %0d",dut.register.regs[1]);
        $display("R2 = %0d",dut.register.regs[2]);
        $display("R3 = %0d",dut.register.regs[3]);
        $display("R4 = %0d",dut.register.regs[4]);
        $display("R5 = %0d",dut.register.regs[5]);
        $display("R6 = %0d",dut.register.regs[6]);
        $display("R7 = %0d",dut.register.regs[7]);
        

        //Check Memory
        $display("mem[10] = %0d", dut.dmem_inst.memory_array[10]);

        $finish;

    end

endmodule
