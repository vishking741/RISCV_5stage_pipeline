`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:23:19
// Design Name: 
// Module Name: alu_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// alu_decoder.v - ALU decoder logic for pipelined RISC-V processor

module alu_decoder
(
    input            opb5,
    input  [2:0]     funct3,
    input            funct7b5,
    input  [1:0]     Alu_op,
    output reg [3:0] Alu_ctrl
);


// combinational ALU control logic
always @(*) begin
    case (Alu_op)
        2'b00: Alu_ctrl = 4'b0000;             // addition
        2'b01: Alu_ctrl = 4'b0001;             // subtraction
        default:                                // R-type or I-type
            case (funct3)
                3'b000: begin
                    if (funct7b5 & opb5)
                        Alu_ctrl = 4'b0001;   // sub
                    else
                        Alu_ctrl = 4'b0000;   // add, addi
                end
                3'b001: Alu_ctrl = 4'b0111;     // sll, slli
                3'b010: Alu_ctrl = 4'b0101;     // slt, slti
                3'b011: Alu_ctrl = 4'b0110;     // sltu, sltiu
                3'b100: Alu_ctrl = 4'b0100;     // xor, xori
                3'b101: begin
                    if (funct7b5)
                        Alu_ctrl = 4'b1001;   // sra, srai
                    else
                        Alu_ctrl = 4'b1000;   // srl, srli
                end
                3'b110: Alu_ctrl = 4'b0011;     // or, ori
                3'b111: Alu_ctrl = 4'b0010;     // and, andi
                default: Alu_ctrl = 4'bxxxx;    // undefined
            endcase
    endcase
end

endmodule