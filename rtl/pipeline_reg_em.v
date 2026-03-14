`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:36:47
// Design Name: 
// Module Name: pipeline_reg_em
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

// Pipeline register: Execute -> Memory stage

module pipeline_reg_em (
    input             clk,
    
    // Inputs from Execute stage
    input             RegWriteE,
    input      [1:0]  ResultSrcE,
    input             MemWriteE,
    input     [31:0]  ALUResultE,
    input     [31:0]  WriteDataE,
    input     [31:0]  PCE,
    input      [4:0]  RdE,
    input     [31:0]  PCPlus4E,
    input     [31:0]  lAuiPCE,
    input     [31:0]  InstrE,
    
    // Outputs to Memory stage
    output reg        RegWriteM,
    output reg [1:0]  ResultSrcM,
    output reg        MemWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [31:0] PCM,
    output reg  [4:0] RdM,
    output reg [31:0] PCPlus4M,
    output reg [31:0] lAuiPCM,
    output reg [31:0] InstrM
);

    // Initialize pipeline registers to 0
    initial begin
        RegWriteM   = 0; ResultSrcM = 0; MemWriteM = 0;
        ALUResultM  = 0; WriteDataM = 0; RdM = 0;
        PCPlus4M    = 0; PCM        = 0; lAuiPCM = 0; InstrM = 0;
    end

    // Update pipeline registers on clock edge
    always @(posedge clk) begin
        RegWriteM   <= RegWriteE;
        ResultSrcM  <= ResultSrcE;
        MemWriteM   <= MemWriteE;
        ALUResultM  <= ALUResultE;
        WriteDataM  <= WriteDataE;
        RdM         <= RdE;
        PCPlus4M    <= PCPlus4E;
        PCM         <= PCE;
        lAuiPCM     <= lAuiPCE;
        InstrM      <= InstrE;
    end

endmodule