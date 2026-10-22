`timescale 1ns/1ps

module core(
    input  logic clk, rst_n,
    output logic halted
);
    logic [7:0]  pc;
    logic [15:0] instr_f;
    logic [15:0] instr_de;
    logic [7:0]  pc_de;
    logic        valid_de;
    logic        taken;
    logic [7:0]  target;

    logic [2:0]  rs1_addr, rs2_addr, rd_addr;
    logic [15:0] imm_sext, boffset_sext, joffset_sext;

    logic [2:0]  alu_funct;
    logic        alu_src_imm, reg_write, mem_read, mem_write;
    logic        is_beq, is_bne, is_jal, is_jalr, is_lui, is_halt;

    // Regfile
    logic [15:0] rs1_data, rs2_data, rd_data;
    logic        regfile_we;

    // DE/WB registers
    logic        reg_write_wb;
    logic [2:0]  rd_addr_wb;
    logic [15:0] wb_data_wb;
    logic        mem_write_wb;
    logic [7:0]  mem_addr_wb;
    logic [15:0] mem_wdata_wb;
    logic [15:0] wb_data;

    // ALU
    logic [15:0] alu_b, alu_result;
    logic        alu_zero;

    // Data memory
    logic [15:0] dmem_rdata, dmem_wdata;
    logic [7:0]  dmem_waddr;
    logic        dmem_we;

    assign alu_b = alu_src_imm ? imm_sext : rs2_data;

    assign taken = (is_beq && (rs1_data == rs2_data)) ||
                   (is_bne && (rs1_data != rs2_data));

    // Slices kept outside always_comb (Icarus limitation)
    logic [7:0]  jalr_target, jal_target, branch_target;
    logic [15:0] lui_value;
    assign jalr_target   = rs1_data[7:0] + imm_sext[7:0];
    assign jal_target    = pc_de + joffset_sext[7:0];
    assign branch_target = pc_de + boffset_sext[7:0];
    assign lui_value     = {imm_sext[5:0], 10'b0};

    always_comb begin
        if (is_jalr)     target = jalr_target;
        else if (is_jal) target = jal_target;
        else             target = branch_target;
    end

    // Store-to-load forward
    logic [15:0] dmem_rdata_fwd;
    assign dmem_rdata_fwd = (mem_write_wb && mem_addr_wb == alu_result[7:0])
                            ? mem_wdata_wb : dmem_rdata;

    // Writeback data for this instruction
    always_comb begin
        if (is_jal || is_jalr) wb_data = {8'b0, pc_de} + 16'd1;
        else if (is_lui)       wb_data = lui_value;
        else if (mem_read)     wb_data = dmem_rdata_fwd;
        else                   wb_data = alu_result;
    end

    // Write-side connections (from DE/WB registers)
    assign regfile_we = reg_write_wb;
    assign rd_data    = wb_data_wb;
    assign dmem_we    = mem_write_wb;
    assign dmem_waddr = mem_addr_wb;
    assign dmem_wdata = mem_wdata_wb;

    imem_1 imem_inst (
        .addr  (pc),
        .instr (instr_f)
    );

    decoder decoder_inst (
        .instr        (instr_de),
        .rs1_addr     (rs1_addr),
        .rs2_addr     (rs2_addr),
        .rd_addr      (rd_addr),
        .alu_funct    (alu_funct),
        .imm_sext     (imm_sext),
        .reg_write    (reg_write),
        .alu_src_imm  (alu_src_imm),
        .mem_read     (mem_read),
        .mem_write    (mem_write),
        .is_beq       (is_beq),
        .is_bne       (is_bne),
        .is_halt      (is_halt),
        .is_jal       (is_jal),
        .is_jalr      (is_jalr),
        .is_lui       (is_lui),
        .boffset_sext (boffset_sext),
        .joffset_sext (joffset_sext)
    );

    regfile regfile_inst (
        .clk      (clk),
        .rst_n    (rst_n),
        .rs1_addr ({1'b0, rs1_addr}),
        .rs1_data (rs1_data),
        .rs2_addr ({1'b0, rs2_addr}),
        .rs2_data (rs2_data),
        .we       (regfile_we),
        .rd_addr  ({1'b0, rd_addr_wb}),
        .rd_data  (rd_data)
    );

    alu alu_inst (
        .a      (rs1_data),
        .b      (alu_b),
        .func3  (alu_funct),
        .result (alu_result),
        .zero   (alu_zero)
    );

    dmem dmem_inst (
        .clk   (clk),
        .we    (dmem_we),
        .raddr (alu_result[7:0]),
        .waddr (dmem_waddr),
        .wdata (dmem_wdata),
        .rdata (dmem_rdata)
    );

    // PC + IF/DE registers, with branch/jump redirect and halt
    logic redirect;
    assign redirect = valid_de && (taken || is_jal || is_jalr);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= 8'b0; instr_de <= 16'hE000; pc_de <= 8'b0;
            valid_de <= 1'b0; halted <= 1'b0;
        end
        else if (halted) begin
            // frozen
        end
        else if (valid_de && is_halt) begin
            halted <= 1'b1; valid_de <= 1'b0;
        end
        else if (redirect) begin
            pc <= target; instr_de <= 16'hE000; pc_de <= 8'b0; valid_de <= 1'b0;
        end
        else begin
            pc <= pc + 8'd1; instr_de <= instr_f; pc_de <= pc; valid_de <= 1'b1;
        end
    end

    // DE/WB registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_write_wb <= 1'b0;
            rd_addr_wb   <= 3'b0;
            wb_data_wb   <= 16'b0;
            mem_write_wb <= 1'b0;
            mem_addr_wb  <= 8'b0;
            mem_wdata_wb <= 16'b0;
        end
        else begin
            reg_write_wb <= valid_de && reg_write;
            rd_addr_wb   <= rd_addr;
            wb_data_wb   <= wb_data;
            mem_write_wb <= valid_de && mem_write;
            mem_addr_wb  <= alu_result[7:0];
            mem_wdata_wb <= rs2_data;
        end
    end

endmodule