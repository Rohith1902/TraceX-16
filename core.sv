`timescale 1ns/1ps

module core(
    input logic clk,rst_n
);
    logic [7:0] pc;
    logic [15:0] instr_f;
    logic [15:0] instr_de
    logic [7:0] pc_de;

    imem imem_inst(
        .addr(pc)
    )