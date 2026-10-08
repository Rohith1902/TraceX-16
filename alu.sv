`timescale 1ns/1ps

module alu(
    input logic [15:0] a,
    input logic [15:0] b,
    input logic [2:0] func3,
    output logic [15:0] result,
    output logic zero
);

    always_comb begin
        case(func3)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a * b;
            3'b011: result = a ^ b;
            3'b100: result = (a > b);
            3'b101: result = (a < b);
            3'b110: result = (a << b);  //Left shift
            3'b111: result = (a >> b);  //Right shift

            default : result = 16'b0;
        endcase

        zero = (result == 16'b0);
    end


endmodule
