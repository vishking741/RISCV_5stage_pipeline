`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 14:00:26
// Design Name: 
// Module Name: adder
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


// adder.v - parameterized adder

module adder 
#(parameter Width = 32)
(
    input  [Width-1:0] A,
    input  [Width-1:0] B,
    output [Width-1:0] Out
);

// combinational addition
assign Out = A + B;

endmodule
