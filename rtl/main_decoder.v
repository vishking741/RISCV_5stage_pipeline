`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:25:31
// Design Name: 
// Module Name: main_decoder
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


// main_decoder.v - main control logic for RISC-V instructions

module main_decoder
(
    input  [6:0] op,
    output [1:0] Result_Src,
    output       Mem_Write,
    output       Branch,
    output       ALU_Src,
    output       Reg_Write,
    output       Jump,
    output       Jalr,
    output [1:0] Imm_Src,
    output [1:0] ALU_Op
);

reg [11:0] controls;

// combinational control logic
always @(*) begin
    casez (op)
        // Reg_Write_Imm_Src_ALU_Src_Mem_Write_Result_Src_ALU_Op_Jump_Jalr_Branch
        7'b0000011: controls = 12'b1_00_1_0_01_00_0_0_0; // lw
        7'b0100011: controls = 12'b0_01_1_1_00_00_0_0_0; // sw
        7'b0110011: controls = 12'b1_xx_0_0_00_10_0_0_0; // R-type
        7'b1100011: controls = 12'b0_10_0_0_00_01_0_0_1; // branch
        7'b0010011: controls = 12'b1_00_1_0_00_10_0_0_0; // I-type ALU
        7'b1101111: controls = 12'b1_11_0_0_10_00_1_0_0; // jal
        7'b1100111: controls = 12'b1_00_1_0_10_00_0_1_0; // jalr
        7'b0?10111: controls = 12'b1_xx_x_0_11_xx_0_0_0; // lui or auipc
        default:    controls = 12'h000;                   // undefined
    endcase
end

// assign control signals from control vector
assign {Reg_Write, Imm_Src, ALU_Src, Mem_Write, Result_Src, ALU_Op, Jump, Jalr, Branch} = controls;

endmodule
