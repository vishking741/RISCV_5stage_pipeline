`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:35:23
// Design Name: 
// Module Name: pipeline_reg_mw
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

// Pipeline register: Memory -> Writeback stage

module pipeline_reg_mw (
    input             clk,
    
    // Inputs from Memory stage
    input             RegWriteM,
    input      [1:0]  ResultSrcM,
    input     [31:0]  ALUResultM,
    input     [31:0]  ReadDataM,
    input     [31:0]  PCM,
    input      [4:0]  RdM,
    input     [31:0]  PCPlus4M,
    input     [31:0]  WriteDataM,
    input     [31:0]  lAuiPCM,
    
    // Outputs to Writeback stage
    output reg        RegWriteW,
    output reg [1:0]  ResultSrcW,
    output reg [31:0] ALUResultW,
    output reg [31:0] ReadDataW,
    output reg [31:0] PCW,
    output reg  [4:0] RdW,
    output reg [31:0] PCPlus4W,
    output reg [31:0] WriteDataW,
    output reg [31:0] lAuiPCW
);

    // Initialize pipeline registers to 0
    initial begin
        RegWriteW   = 0; ResultSrcW = 0;
        ALUResultW  = 0; ReadDataW  = 0;
        RdW         = 0; PCPlus4W  = 0; PCW = 0;
        WriteDataW  = 0; lAuiPCW   = 0;
    end

    // Update pipeline registers on clock edge
    always @(posedge clk) begin
        RegWriteW   <= RegWriteM;
        ResultSrcW  <= ResultSrcM;
        ALUResultW  <= ALUResultM;
        ReadDataW   <= ReadDataM;
        PCW         <= PCM;
        RdW         <= RdM;
        PCPlus4W    <= PCPlus4M;
        WriteDataW  <= WriteDataM;
        lAuiPCW     <= lAuiPCM;
    end

endmodule
