`timescale 1ns/1ps

module core(
    input logic clk,rst_n
);
    logic [7:0] pc;
    logic [15:0] instr_f;
    logic [15:0] instr_de;
    logic [7:0] pc_de;

    imem_1 imem_inst(
        .addr(pc),
        .instr(instr_f)
    );

    //Program counter on IF/DE registers

    always_ff @(posedge clk or negedge rst_n) begin

        if(!rst_n) begin
            pc <= 8'b0;
            instr_de <= 16'b0;
            pc_de <= 8'b0;
        end
        else begin
            pc <= pc + 8'd1;
            instr_de <=instr_f;
            pc_de <= pc;
        end
    end

endmodule