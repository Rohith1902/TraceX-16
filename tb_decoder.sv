`timescale 1ns/1ps


module tb_decoder();


    logic [15:0] instr;
    logic [2:0] rs1_addr;
    logic [2:0] rs2_addr;
    logic [2:0] rd_addr;
    logic [2:0] alu_funct;
    logic [15:0] imm_sext;
    logic mem_write,mem_read,alu_src_imm,reg_write;
    logic is_beq,is_bne,is_jal,is_jalr,is_lui,is_halt;
    logic [15:0] boffset_sext;
    logic [15:0] joffset_sext;

    decoder dut(
        .instr(instr),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .alu_funct(alu_funct),
        .imm_sext(imm_sext),
        .alu_src_imm(alu_src_imm),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .is_beq(is_beq),
        .is_bne(is_bne),
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .is_lui(is_lui),
        .is_halt(is_halt),
        .boffset_sext(boffset_sext),
        .joffset_sext(joffset_sext)
    );
    logic [3:0] opcode;
    assign opcode = instr[15:12];

    task d_output();
        begin
            $display("Instruction   =  %b",instr);
            $display("opcode        =  %b",opcode);
            $display("RS1           =  %b",rs1_addr);
            $display("RS2           =  %b",rs2_addr);
            $display("RD            =  %b",rd_addr);
            $display("ALU Function  =  %b",alu_funct);
            $display("Reg Write     =  %b",reg_write);
            $display("BEQ           = %b", is_beq);
            $display("BNE           = %b", is_bne);
            $display("JAL           = %b", is_jal);
            $display("JALR          = %b", is_jalr);
            $display("LUI           = %b", is_lui);
            $display("HALT          = %b", is_halt);
            $display("Branch Offset = %0d", $signed(boffset_sext));
            $display("Jump Offset   = %0d", $signed(joffset_sext));


            $display("==================================");



        end
    endtask

    initial begin
        //R Type 
        $display("R--Type Add test");
        instr = 16'b0000_010_011_001_000;
        #10;
        d_output();

        $display("ADDI test");
        instr = 16'b0001_010_011_000101;
        #10;
        d_output();

        $display("LOAD test");
        instr = 16'b0010_010_011_000101;
        #10;
        d_output();

        $display("STORE test");
        instr = 16'b0011_010_011_000101;
        #10;
        d_output();

        $display("BEQ test");
        instr = 16'h4702;
        #10;
        d_output();
        
        $display("BNE test");
        instr = 16'h5702;
        #10;
        d_output();

        $display("JAL test");
        instr = 16'h6002;
        #10;
        d_output();

        $display("JALR test");
        instr = 16'h7002;
        #10;
        d_output();

        $display("LUI test");
        instr = 16'h8000;
        #10;
        d_output();

        $display("HALT test");
        instr = 16'hF000;
        #10;
        d_output();





            

        $finish;

    end


endmodule