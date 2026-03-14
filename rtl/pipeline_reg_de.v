`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:33:34
// Design Name: 
// Module Name: pipeline_reg_de
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

// Pipeline register: Decode -> Execute stage

module pipeline_reg_de (
    input             clk,
    input             clr,
    
    // Inputs from Decode stage
    input             RegWriteD,
    input      [1:0]  ResultSrcD,
    input             MemWriteD,
    input             JumpD,
    input             BranchD,
    input             JalrD,
    input      [3:0]  ALUControlD,
    input             ALUSrcD,
    input     [31:0]  RD1D,
    input     [31:0]  RD2D,
    input     [31:0]  PCD,
    input      [4:0]  Rs1D,
    input      [4:0]  Rs2D,
    input      [4:0]  RdD,
    input     [31:0]  ImmExtD,
    input     [31:0]  PCPlus4D,
    input     [31:0]  InstrD,
    
    // Outputs to Execute stage
    output reg        RegWriteE,
    output reg [1:0]  ResultSrcE,
    output reg        MemWriteE,
    output reg        JumpE,
    output reg        BranchE,
    output reg        JalrE,
    output reg [3:0]  ALUControlE,
    output reg        ALUSrcE,
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] PCE,
    output reg  [4:0] Rs1E,
    output reg  [4:0] Rs2E,
    output reg  [4:0] RdE,
    output reg [31:0] ImmExtE,
    output reg [31:0] PCPlus4E,
    output reg [31:0] InstrE
);

    // Initialize pipeline registers to 0
    initial begin
        RegWriteE   = 0; ResultSrcE = 0; MemWriteE = 0;
        JumpE       = 0; BranchE   = 0; ALUControlE = 0;
        ALUSrcE     = 0; RD1E      = 0; RD2E = 0; PCE = 0;
        Rs1E        = 0; Rs2E      = 0; RdE = 0;
        ImmExtE     = 0; PCPlus4E  = 0; InstrE = 0;
        JalrE       = 0;
    end

    // Update pipeline registers on clock edge
    always @(posedge clk) begin
        if (clr) begin
            RegWriteE   <= 0; ResultSrcE <= 0; MemWriteE <= 0;
            JumpE       <= 0; BranchE   <= 0; ALUControlE <= 0;
            ALUSrcE     <= 0; RD1E      <= 0; RD2E <= 0; PCE <= 0;
            Rs1E        <= 0; Rs2E      <= 0; RdE <= 0;
            ImmExtE     <= 0; PCPlus4E  <= 0; InstrE <= 0;
            JalrE       <= 0;
        end else begin
            RegWriteE   <= RegWriteD; ResultSrcE <= ResultSrcD; MemWriteE <= MemWriteD;
            JumpE       <= JumpD; BranchE <= BranchD; ALUControlE <= ALUControlD;
            ALUSrcE     <= ALUSrcD; RD1E <= RD1D; RD2E <= RD2D; PCE <= PCD;
            Rs1E        <= Rs1D; Rs2E <= Rs2D;
            RdE         <= RdD; ImmExtE <= ImmExtD; PCPlus4E <= PCPlus4D;
            InstrE      <= InstrD; JalrE <= JalrD;
        end
    end

endmodule
