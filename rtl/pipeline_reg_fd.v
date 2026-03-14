`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 15:36:47
// Design Name: 
// Module Name: pipeline_reg_fd
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


// Pipeline register: Fetch -> Decode stage

module pipeline_reg_fd (
    input             clk,
    input             en,
    input             clr,
    
    // Inputs from Fetch stage
    input     [31:0]  InstrF,
    input     [31:0]  PCF,
    input     [31:0]  PCPlus4F,
    
    // Outputs to Decode stage
    output reg [31:0] InstrD,
    output reg [31:0] PCD,
    output reg [31:0] PCPlus4D
);

    // Initialize pipeline registers to 0
    initial begin
        InstrD     = 0;
        PCD        = 0;
        PCPlus4D   = 0;
    end

    // Update pipeline registers on clock edge
    always @(posedge clk) begin
        if (clr) begin
            InstrD     <= 0;
            PCD        <= 0;
            PCPlus4D   <= 0;
        end else if (!en) begin
            InstrD     <= InstrF;
            PCD        <= PCF;
            PCPlus4D   <= PCPlus4F;
        end
    end

endmodule
