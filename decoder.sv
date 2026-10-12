`timescale 1ns/1ps

module decoder(
    input logic [15:0] instr,
    output logic [2:0] rs1_addr,
    output logic [2:0] rs2_addr,
    output logic [2:0] rd_addr,
    output logic [2:0] alu_funct,
    output logic [15:0] imm_sext,
    output logic reg_write,alu_src_imm,mem_read,mem_write,
    output logic is_beq, is_bne, is_jal, is_jalr ,is_lui ,is_halt,
    output logic [15:0] boffset_sext, // branch_offset
    output logic [15:0] joffset_sext //jump_offset
);

    logic [3:0] opcode;
    assign opcode = instr[15:12];

    assign imm_sext = {{10{instr[5]}},instr[5:0]};
    assign boffset_sext = {{10{instr[5]}}, instr[5:0]};
    assign joffset_sext = {{4{instr[11]}}, instr[11:0]};

    always @(*) begin

        reg_write = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        alu_src_imm = 1'b0;

        is_beq  = 1'b0;
        is_bne  = 1'b0;
        is_jal  = 1'b0;
        is_jalr = 1'b0;
        is_lui  = 1'b0;
        is_halt = 1'b0; 

        rs1_addr = instr[8:6];
        rs2_addr = instr[5:3];
        rd_addr = instr[11:9];
        alu_funct = 3'b000;

        case(opcode)

            4'b0000: begin         //R Type
                reg_write = 1;  //Enable writing
                alu_funct = instr[2:0];   
            end

            4'b0001: begin   //ADDI
                reg_write = 1'b1;   //Enable writing
                alu_src_imm = 1'b1;    //To add a immediate value or register value
                alu_funct = 3'b000;  
            end  //It has only one operation - to add

            4'b0010: begin    //LOAd
                reg_write = 1'b1;
                mem_read = 1'b1;
                alu_src_imm = 1'b1;
                alu_funct = 3'b000;
            end

            4'b0011: begin //STORE
                mem_write = 1'b1;
                alu_src_imm = 1'b1;
                alu_funct = 3'b000;
                rs2_addr = instr[11:9];
            end

            4'b0100: begin //BEQ
                is_beq = 1;
                rs1_addr = instr[11:9];
                rs2_addr = instr[8:6];
            end

            4'b0101: begin //BNE 
                is_bne = 1'b1;
                rs1_addr = instr[11:9];
                rs2_addr = instr[8:6];
            end

            4'b0110:begin //JAL 
                is_jal = 1;
                reg_write = 1;
               
                rd_addr = 3'd7;
            end 

            4'b0111: begin // JALR  
                is_jalr = 1;
                reg_write = 1;
                rd_addr = 3'd7;
            end

            4'b1000:begin // LUI 
                is_lui = 1;
                reg_write = 1;
            end

            4'b1111: begin //HALT
                is_halt = 1;
            end 

            default : begin

            end

        endcase

    end

endmodule




