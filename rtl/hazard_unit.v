`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:27:52
// Design Name: 
// Module Name: hazard_unit
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

// hazard_unit.v - hazard detection and forwarding unit for pipelined RISC-V CPU

module hazard_unit(
    input  [4:0] Rs1E,
    input  [4:0] Rs2E,
    input  [4:0] RdM,
    input  [4:0] RdW,
    input  [4:0] Rs1D,
    input  [4:0] Rs2D,
    input  [4:0] RdE,
    input        RegWriteM,
    input        RegWriteW,
    input        ResultSrcE,
    input        PCSrcE,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output reg       StallF,
    output reg       StallD,
    output reg       FlushE,
    output reg       FlushD
);

reg lwStall;

// initialize outputs
initial begin
    ForwardAE = 2'b00;
    ForwardBE = 2'b00;
    StallF    = 1'b0;
    StallD    = 1'b0;
    FlushE    = 1'b0;
    FlushD    = 1'b0;
end

// hazard detection and forwarding logic
always @(*) begin
    // forwarding for execution stage operands (RAW hazards)
    if (((Rs1E == RdM) & RegWriteM) & (Rs1E != 0))
        ForwardAE = 2'b10;
    else if (((Rs1E == RdW) & RegWriteW) & (Rs1E != 0))
        ForwardAE = 2'b01;
    else
        ForwardAE = 2'b00;

    if (((Rs2E == RdM) & RegWriteM) & (Rs2E != 0))
        ForwardBE = 2'b10;
    else if (((Rs2E == RdW) & RegWriteW) & (Rs2E != 0))
        ForwardBE = 2'b01;
    else
        ForwardBE = 2'b00;

    // load-use data hazard detection (stall)
    lwStall = (ResultSrcE & ((Rs1D == RdE) | (Rs2D == RdE)));
    StallF = lwStall;
    StallD = lwStall;

    // control hazard handling (flush pipeline)
    FlushD = PCSrcE;
    FlushE = lwStall | PCSrcE;
end

endmodule
