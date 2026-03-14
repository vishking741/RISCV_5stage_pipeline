`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 14:23:16
// Design Name: 
// Module Name: reg_file
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

// reg_file.v - 32x32-bit register file for RISC-V

module reg_file
#(parameter Width = 32)
(
    input                 clk,
    input                 w_en,
    input  [4:0]          addr_rs1,
    input  [4:0]          addr_rs2,
    input  [4:0]          addr_rd,
    input  [Width-1:0]    wr_data,
    output [Width-1:0]    data_rs1,
    output [Width-1:0]    data_rs2
);

// 32 general-purpose registers
reg [Width-1:0] reg_file [0:31];


// initialize x0 to 0
initial begin
    reg_file[0] = 0; // x0 is hardwired to 0
end


// write logic (negative edge)
always @(negedge clk) begin
    if (w_en && (addr_rd != 0))
        reg_file[addr_rd] <= wr_data;
end


// read logic
assign data_rs1 = (addr_rs1 != 0 )? reg_file[addr_rs1] : 0;
assign data_rs2 = (addr_rs2 != 0) ? reg_file[addr_rs2] : 0;

endmodule