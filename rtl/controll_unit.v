`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:30:11
// Design Name: 
// Module Name: controll_unit
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


// controller.v - top-level controller for pipelined RISC-V CPU

module controll_unit
(
    input  [6:0]  op,
    input  [2:0]  funct3,
    input         funct7b5,
    output [1:0]  ResultSrc,
    output        MemWrite,
    output        Branch,
    output        ALUSrc,
    output        RegWrite,
    output        Jump,
    output        Jalr,
    output [1:0]  ImmSrc,
    output [3:0]  ALUControl
);

wire [1:0] ALUOp;

// instantiate main decoder
main_decoder main (
    .op(op),
    .Result_Src(ResultSrc),
    .Mem_Write(MemWrite),
    .Branch(Branch),
    .ALU_Src(ALUSrc),
    .Reg_Write(RegWrite),
    .Jump(Jump),
    .Jalr(Jalr),
    .Imm_Src(ImmSrc),
    .ALU_Op(ALUOp)
);

// instantiate ALU decoder
alu_decoder alu (
    .opb5(op[5]),
    .funct3(funct3),
    .funct7b5(funct7b5),
    .Alu_op(ALUOp),
    .Alu_ctrl(ALUControl)
);

endmodule
