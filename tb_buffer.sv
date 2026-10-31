`timescale 1ns/1ps

module tb_buffer();

    logic clk;
    logic rst_n;
    logic we;
    logic trace_enable;
    logic [7:0] pc;
    logic pc;
    logic [15:0] instr;
    logic [3:0] rd_addr;
    logic [15:0] rd_data;
    logic branch_taken;
    logic read_addr;
    logic out_pc;
    logic out_instr;
    logic out_rd_addr;
    logic out_rd_data;
    logic out_token;
    logic [ PTR_W-1:0]head;


    buffer #(.DEPTH(DEPTH)) dut(.*);

    always clk #5 = ~clk;

    