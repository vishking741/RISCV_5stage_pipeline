`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:49:58
// Design Name: 
// Module Name: cpu_top
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


module cpu_top (
    input         clk,
    input         reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWriteM,
    output [31:0] Mem_WrAddr,
    output [31:0] Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result,
    output [31:0] PCW,
    output [31:0] ALUResultW,
    output [31:0] WriteDataW,
    output [31:0] InstrM
);

    // Control signals
    wire        ALUSrc, RegWrite, Branch, Jump, Jalr;
    wire [1:0]  ResultSrc, ImmSrc;
    wire [3:0]  ALUControl;
    wire        MemWriteD;
    wire [31:0] InstrD;

    // -------------------------------
    // Controller
    // -------------------------------
    controll_unit control(
        InstrD[6:0],
        InstrD[14:12],
        InstrD[30],
        ResultSrc,
        MemWriteD,
        Branch,
        ALUSrc,
        RegWrite,
        Jump,
        Jalr,
        ImmSrc,
        ALUControl
    );

    // -------------------------------
    // Datapath
    // -------------------------------
    datapath data(
        clk,
        reset,
        ResultSrc,
        MemWriteD,
        ALUSrc,
        RegWrite,
        ImmSrc,
        ALUControl,
        Branch,
        Jump,
        Jalr,
        MemWriteM,
        PC,
        Instr,
        InstrD,
        InstrM,
        Mem_WrAddr,
        Mem_WrData,
        ReadData,
        Result,
        PCW,
        ALUResultW,
        WriteDataW
    );


endmodule
