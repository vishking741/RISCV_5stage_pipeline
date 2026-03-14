`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 14:02:12
// Design Name: 
// Module Name: mux_2
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


// mux_2.v - 2-to-1 parameterized multiplexer

module mux_2
#(parameter Width = 32)
(
    input  [Width-1:0] i0,
    input  [Width-1:0] i1,
    input              sel,
    output [Width-1:0] out
);

// mux logic
assign out = sel ? i1 : i0;

endmodule
