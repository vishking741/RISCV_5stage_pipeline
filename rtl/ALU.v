`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 14:40:42
// Design Name: 
// Module Name: ALU
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


// alu.v - parameterized arithmetic logic unit

module ALU
#(parameter Width = 32)
(
    input  [Width-1:0] alu_a,
    input  [Width-1:0] alu_b,
    input  [3:0]       alu_ctrl,

    output reg [Width-1:0] alu_out,
    output                 zero,
    output                 overflow
);

// unsigned magnitudes
wire [Width-1:0] a_mag = $unsigned(alu_a);
wire [Width-1:0] b_mag = $unsigned(alu_b);

// comparison flag
assign overflow = (a_mag >= b_mag) ? 1'b0 : 1'b1;


// ALU operation logic
always @(*) begin
    case (alu_ctrl)

        4'd0 : alu_out = alu_a + alu_b;              // add
        4'd1 : alu_out = alu_a + ~alu_b + 1;         // sub
        4'd2 : alu_out = alu_a & alu_b;              // and
        4'd3 : alu_out = alu_a | alu_b;              // or
        4'd4 : alu_out = alu_a ^ alu_b;              // xor

        4'd5 : begin                                 // slt
                    if (alu_a[31] != alu_b[31])
                        alu_out = alu_a[31] ? 1 : 0;
                    else
                        alu_out = overflow;
               end

        4'd6 : alu_out = (a_mag < b_mag) ? 1 : 0;    // sltu
        4'd7 : alu_out = alu_a <<  alu_b[4:0];       // sll
        4'd8 : alu_out = alu_a >>  alu_b[4:0];       // srl
        4'd9 : alu_out = $signed(alu_a) >>> alu_b[4:0]; // sra

        default : alu_out = 0;

    endcase
end


// zero flag
assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule