`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:24:34
// Design Name: 
// Module Name: branching_unit
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


// branching_unit.v - branch decision logic in execute stage

module branching_unit
(
    input  [2:0] funct3,
    input        Zero,
    input        Alub31,
    input        Overflow,
    output reg   Branch
);

// initialize branch signal
initial begin
    Branch = 1'b0;
end

// combinational branch logic
always @(*) begin
    case (funct3)
        3'b000: Branch =  Zero;      // beq
        3'b001: Branch = !Zero;      // bne
        3'b100: Branch =  Alub31;    // blt
        3'b101: Branch = !Alub31;    // bge
        3'b110: Branch =  Overflow;  // bltu
        3'b111: Branch = !Overflow;  // bgeu
        default: Branch = 1'b0;      // no branch
    endcase
end

endmodule
