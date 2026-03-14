`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 14:02:12
// Design Name: 
// Module Name: mux_3
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


// mux_3.v - 3-to-1 parameterized multiplexer

module mux_3
#(parameter Width = 32)
(
    input  [Width-1:0] i0,
    input  [Width-1:0] i1,
    input  [Width-1:0] i2,
    input  [1:0]       sel,
    output [Width-1:0] out
);

// mux logic
assign out = sel[1] ? i2 : (sel[0] ? i1 : i0);

endmodule
