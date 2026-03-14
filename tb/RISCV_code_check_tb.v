`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2026 10:32:53
// Design Name: 
// Module Name: RISCV_code_check_tb
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

module RISCV_code_check_tb;

// registers
reg clk;
reg reset;
reg Ext_MemWrite;
reg [31:0] Ext_WriteData, Ext_DataAdr;

// wires
wire [31:0] WriteData, DataAdr, ReadData;
wire MemWrite;
wire [31:0] PCW, Result, DataAdrW, WriteDataW,PCF;

// instantiate CPU
riscv_pipeline riscv_cpu_inst (
    clk,
    reset,
    Ext_MemWrite,
    Ext_WriteData,
    Ext_DataAdr,
    MemWrite,
    WriteData,
    DataAdr,
    ReadData,
    PCW,
    Result,
    DataAdrW,
    WriteDataW,
    PCF
);

// clock
always begin
    clk = 1; #5;
    clk = 0; #5;
end

// reset
initial begin
    reset = 1;
    Ext_MemWrite = 0;
    Ext_DataAdr = 0;
    Ext_WriteData = 0;
    #20;
    reset = 0;
end

// monitor CPU activity
initial begin
    $monitor("Time=%0t PC=%h PCF=%h Result=%d MemWrite=%b Addr=%h WriteData=%h",
              $time, PCW, PCF , Result, MemWrite, DataAdrW, WriteDataW);
end

// print full register bank
    integer i;
initial begin
    #400;

    $display("\n=========== FINAL REGISTER FILE ===========");
    for (i = 0; i < 32; i = i + 1) begin
        $display("x%0d = %d", i, riscv_cpu_inst.rvcpu.data.rf.reg_file[i]);
    end
    $display("===========================================\n");

    $display("Simulation finished");
    $stop;
end

// stop simulation
initial begin
    #400;
    $display("Simulation finished");
    $stop;
end

endmodule
