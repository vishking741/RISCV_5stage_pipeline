`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:41:56
// Design Name: 
// Module Name: datapath
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

module datapath (
    input         clk, reset,
    input  [1:0]  ResultSrcD,
    input         MemWriteD,
    input         ALUSrcD, RegWriteD,
    input  [1:0]  ImmSrcD,
    input  [3:0]  ALUControlD,
    input         BranchD, JumpD, JalrD,
    output        MemWriteM,
    output [31:0] PCF,
    input  [31:0] InstrF,
    output [31:0] InstrD, InstrM,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadDataM,
    output [31:0] ResultW,
    output [31:0] PCW, ALUResultW, WriteDataW
);

    // -------------------------------
    // Internal wires
    // -------------------------------
    wire [31:0] PCNext, PCJalr, PCPlus4F, PCTargetE, AuiPC;
    wire [31:0] SrcAE, SrcBE, WriteDataE, ALUResultE;
    wire TakeBranch, ZeroE, OverflowE;

    // Pipeline wires
    wire [4:0] Rs1E, Rs2E, RdM, RdW, RdE;
    wire RegWriteM, RegWriteW, RegWriteE;
    wire [1:0] ResultSrcE;
    wire [31:0] ImmExtE;
    wire [31:0] RD1D, RD2D;
    wire [31:0] ReadDataW;

    wire [31:0] PCD, PCPlus4D, ImmExtD;
    wire [4:0] Rs1D = InstrD[19:15];
    wire [4:0] Rs2D = InstrD[24:20];
    wire [4:0] RdD  = InstrD[11:7];
    wire [1:0] ForwardAE, ForwardBE;
    wire StallF, StallD, FlushE, FlushD;
    wire MemWriteE, JumpE, BranchE, ALUSrcE, JalrE;
    wire [3:0] ALUControlE;
    wire [31:0] RD1E, RD2E, PCPlus4E, PCE;
    wire [31:0] InstrE, lAuiPCE;
    wire [1:0] ResultSrcM;
    wire [31:0] ALUResultM, PCPlus4M, WriteDataM, PCM, lAuiPCM;
    wire [1:0] ResultSrcW;
    wire [31:0] PCPlus4W, lAuiPCW;
    wire [2:0] funct3E = InstrE[14:12];

    wire PCSrcE = ((BranchE & TakeBranch) | JumpE | JalrE) ? 1'b1 : 1'b0;

    // -------------------------------
    // Next PC logic
    // -------------------------------
    mux_2 #(32) pcmux(PCPlus4F, PCTargetE, PCSrcE, PCNext);
    mux_2 #(32) jalrmux(PCNext, ALUResultE, JalrE, PCJalr);

    ff_reset #(32) pcreg(clk, reset, StallF, PCJalr, PCF);
    adder pcadd4(PCF, 32'd4, PCPlus4F);

    // -------------------------------
    // Pipeline Register 1 -> Fetch | Decode
    // -------------------------------
    pipeline_reg_fd plfd(
        clk, StallD, FlushD,
        InstrF, PCF, PCPlus4F,
        InstrD, PCD, PCPlus4D
    );

    // -------------------------------
    // Register file and immediate extension
    // -------------------------------
    reg_file rf(clk, RegWriteW, InstrD[19:15], InstrD[24:20], RdW, ResultW, RD1D, RD2D);
    imm_extend ext(InstrD[31:7], ImmSrcD, ImmExtD);

    // -------------------------------
    // Pipeline Register 2 -> Decode | Execute
    // -------------------------------
    pipeline_reg_de plde(
        clk, FlushE, RegWriteD, ResultSrcD, MemWriteD,
        JumpD, BranchD, JalrD, ALUControlD, ALUSrcD, RD1D, RD2D, PCD,
        Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D, InstrD,
        RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, JalrE, ALUControlE,
        ALUSrcE, RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE,
        PCPlus4E, InstrE
    );

    adder pcaddbranch(PCE, ImmExtE, PCTargetE);

    // -------------------------------
    // ALU logic
    // -------------------------------
    mux_3 #(32) forwardaemux(RD1E, ResultW, ALUResultM, ForwardAE, SrcAE);
    mux_3 #(32) forwardbemux(RD2E, ResultW, ALUResultM, ForwardBE, WriteDataE);
    mux_2 #(32) srcbmux(WriteDataE, ImmExtE, ALUSrcE, SrcBE);
    ALU alu(SrcAE, SrcBE, ALUControlE, ALUResultE, ZeroE, OverflowE);
    adder #(32) auipcadder({InstrE[31:12], 12'b0}, PCE, AuiPC);
    mux_2 #(32) lauipcmux(AuiPC, {InstrE[31:12], 12'b0}, InstrE[5], lAuiPCE);
    branching_unit bu(funct3E, ZeroE, ALUResultE[31], OverflowE, TakeBranch);

    // -------------------------------
    // Pipeline Register 3 -> Execute | Memory
    // -------------------------------
    pipeline_reg_em plem(
        clk, RegWriteE, ResultSrcE, MemWriteE, ALUResultE,
        WriteDataE, PCE, RdE, PCPlus4E, lAuiPCE, InstrE,
        RegWriteM, ResultSrcM, MemWriteM, ALUResultM, WriteDataM, PCM,
        RdM, PCPlus4M, lAuiPCM, InstrM
    );

    // -------------------------------
    // Pipeline Register 4 -> Memory | Writeback
    // -------------------------------
    pipeline_reg_mw plmw(
        clk, RegWriteM, ResultSrcM, ALUResultM, ReadDataM, PCM,
        RdM, PCPlus4M, WriteDataM, lAuiPCM,
        RegWriteW, ResultSrcW, ALUResultW, ReadDataW,
        PCW, RdW, PCPlus4W, WriteDataW, lAuiPCW
    );

    // -------------------------------
    // Result source mux for Writeback
    // -------------------------------
    mux_4 #(32) resultmux(ALUResultW, ReadDataW, PCPlus4W, lAuiPCW, ResultSrcW, ResultW);

    // -------------------------------
    // Hazard Unit
    // -------------------------------
    hazard_unit hu(
        Rs1E, Rs2E, RdM, RdW, Rs1D, Rs2D, RdE,
        RegWriteM, RegWriteW, ResultSrcE[0], PCSrcE,
        ForwardAE, ForwardBE, StallF, StallD,
        FlushE, FlushD
    );

    // -------------------------------
    // Memory interface
    // -------------------------------
    assign Mem_WrData = WriteDataM;
    assign Mem_WrAddr = ALUResultM;

endmodule
