`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 14:32:31
// Design Name: 
// Module Name: imm_extend
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


// imm_extend.v - immediate value extender for RISC-V instruction types

module imm_extend
(
    input  [31:7]  instr_val,
    input  [1:0]   imm_src,
    output reg [31:0] imm_ext_val
);


// immediate extension logic
always @(*) begin
    case (imm_src)

        2'b00 : imm_ext_val = {{20{instr_val[31]}}, instr_val[31:20]};                         // I-type
        2'b01 : imm_ext_val = {{20{instr_val[31]}}, instr_val[31:25], instr_val[11:7]};        // S-type
        2'b10 : imm_ext_val = {{20{instr_val[31]}}, instr_val[7], instr_val[30:25],
                                instr_val[11:8], 1'b0};                                        // B-type
        2'b11 : imm_ext_val = {{12{instr_val[31]}}, instr_val[19:12], instr_val[20],
                                instr_val[30:21], 1'b0};                                        // J-type

        default : imm_ext_val = 32'bx;

    endcase
end

endmodule
