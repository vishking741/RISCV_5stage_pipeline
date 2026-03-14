`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 14:12:42
// Design Name: 
// Module Name: instr_mem
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


// instr_mem.v - instruction memory

module instr_mem
#(
    parameter D_Width = 32,
    parameter A_Width = 32,
    parameter instr_mem_file = "rv32i_test.txt",
    parameter Mem_Width = 512
)
(
    input  [A_Width-1:0] instr_addr,
    output [D_Width-1:0] instr
);

// instruction memory array
reg [D_Width-1:0] instr_mem [0:Mem_Width-1];

// load instructions from file
initial begin
    $readmemh(instr_mem_file, instr_mem);
end

// word-aligned access (4 bytes per instruction)
assign instr = instr_mem[instr_addr[31:2]];

endmodule
