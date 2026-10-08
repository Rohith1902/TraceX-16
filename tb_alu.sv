`timescale 1ns/1ps

module tb_alu();

    logic [15:0] a;
    logic [15:0] b;
    logic [2:0] func3;
    logic [15:0] result;
    logic zero;
    logic [15:0] expected;

    alu dut(
        .a(a),
        .b(b),
        .func3(func3),
        .result(result),
        .zero(zero)
    );


    /*function logic check(
        input logic [15:0] expected,
        input logic [15:0] result
    );
        if(expected == result) begin
            $display("Pass");
        end
        else begin
            $display("fail");
        end
    */

    //addition
    task addition;
        a = 16'd7;
        b = 16'd7;
        expected = 16'd14;
        func3 = 3'b000;
        #1;
        $display("===========ADDITION===========");
        $display("    A     |      B    |    Result(got)   |    Expected   |  Status   ");
        $display(" %d    |      %d   |     %d           |    %d         |   %s      ",a,b,result,expected,(expected == result)?"Pass":"Fail");
    endtask

    //Subtraction
    task subtraction;
        a = 16'd7;
        b = 16'd7;
        expected = 16'd0;
        func3 = 3'b001;
        #1;
        $display("===========SUBTRACTION===========");
        $display("    A     |      B    |    Result(got)   |    Expected   |  Status   ");
        $display(" %d    |      %d   |     %d           |    %d         |   %s      ",a,b,result,expected,(expected == result)?"Pass":"Fail");
    endtask

    //Multiplication
    task multiplication;
        a = 16'd7;
        b = 16'd7;
        expected = 16'd49;
        func3 = 3'b010;
        #1;
        $display("===========MULTIPLICATION===========");
        $display("    A     |      B    |    Result(got)   |    Expected   |  Status   ");
        $display(" %d    |      %d   |     %d           |    %d         |   %s      ",a,b,result,expected,(expected == result)?"Pass":"Fail");
    endtask

    //XOR
    task xor_test;
        a = 16'd1;
        b = 16'd1;
        expected = 16'd0;
        func3 = 3'b011;
        #1;
        $display("===========XOR===========");
        $display("    A     |      B    |    Result(got)   |    Expected   |  Status   ");
        $display(" %d    |      %d   |     %d           |    %d         |   %s      ",a,b,result,expected,(expected == result)?"Pass":"Fail");
    endtask

    //Greater than
    task a_greater;
        a = 16'd10;
        b = 16'd7;
        expected = 16'd1;
        func3 = 3'b100;
        #1;
        $display("===========GREATER THAN===========");
        $display("    A     |      B    |    Result(got)   |    Expected   |  Status   ");
        $display(" %d    |      %d   |     %d           |    %d         |   %s      ",a,b,result,expected,(expected == result)?"Pass":"Fail");
    endtask

    //Lesser than
    task a_lesser;
        a = 16'd5;
        b = 16'd7;
        expected = 16'd1;
        func3 = 3'b101;
        #1;
        $display("===========LESSER THAN===========");
        $display("    A     |      B    |    Result(got)   |    Expected   |  Status   ");
        $display(" %d    |      %d   |     %d           |    %d         |   %s      ",a,b,result,expected,(expected == result)?"Pass":"Fail");
    endtask


    //left shift
    task left_shift;
        a = 16'd7;
        b = 16'd2;
        expected = 16'd28;
        func3 = 3'b110;
        #1;
        $display("===========LEFT SHIFT===========");
        $display("    A     |      B    |    Result(got)   |    Expected   |  Status   ");
        $display(" %d    |      %d   |     %d           |    %d         |   %s      ",a,b,result,expected,(expected == result)?"Pass":"Fail");
    endtask

    task right_shift;
        a = 16'd10;
        b = 16'd2;
        expected = 16'd2;
        func3 = 3'b111;
        #1;
        $display("===========RIGHT SHIFT===========");
        $display("    A     |      B    |    Result(got)   |    Expected   |  Status   ");
        $display(" %d    |      %d   |     %d           |    %d         |   %s      ",a,b,result,expected,(expected == result)?"Pass":"Fail");
    endtask

    initial begin

    addition();
    subtraction();
    multiplication();
    xor_test();
    a_greater();
    a_lesser();
    left_shift();
    right_shift();

    $finish;



    end
endmodule
    
