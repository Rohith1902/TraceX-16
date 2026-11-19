`timescale 1ns/1ps


module buffer #(
    parameter int DEPTH = 64,
    parameter int PTR_W = $clog2(DEPTH)
)(
    input logic clk,rst_n,we,
    input logic trace_enable,
    input logic [7:0] pc,
    input logic [15:0] instr,
    input logic [2:0] rd_addr,
    input logic [15:0] rd_data,
    input logic branch_taken,
    input logic [PTR_W-1:0] read_addr,
    output logic [7:0] out_pc,
    output logic [15:0] out_instr,
    output logic [2:0] out_rd_addr,
    output logic [15:0] out_rd_data,
    output logic out_taken,
    output logic [PTR_W-1:0] head
);

    logic [43:0] mem [0:DEPTH-1];
    logic [43:0] entry;

    always_ff @(posedge clk or negedge rst_n) begin

        if(!rst_n)
            head <= '0;
        else if (we && trace_enable) begin
            mem[head] <= {pc,instr,rd_addr,rd_data,branch_taken};
            head <= head + 1'b1;
        end 

    end
    assign entry = mem[read_addr];
    assign out_pc = entry[43:36];
    assign out_instr = entry[35:20];
    assign out_rd_addr = entry[19:17];
    assign out_rd_data = entry[16:1];
    assign out_taken = entry[0];

endmodule