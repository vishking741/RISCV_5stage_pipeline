`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 14:20:19
// Design Name: 
// Module Name: ff_reset
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


// ff_reset.v - flip-flop with reset and clear control

module ff_reset
#(parameter Width = 32)
(
    input                 clk,
    input                 rst,
    input                 clr,
    input  [Width-1:0]    data_in,
    output reg [Width-1:0] data_out
);

// initial value
initial data_out = 0;


// sequential logic
always @(posedge clk) begin
    if (rst)
        data_out <= 0;
    else if (!clr)
        data_out <= data_in;
end

endmodule