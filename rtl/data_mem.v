`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2026 14:56:28
// Design Name: 
// Module Name: data_mem
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


module data_mem #(parameter D_Width = 32, A_Width = 32, Mem_Width = 64) (

    input clk,
    input w_en,
    input [2:0] funct3,
    input [A_Width-1:0] wr_addr,
    input [D_Width-1:0] wr_data,

    output reg [D_Width-1:0] rd_data
);

// memory array
reg [D_Width-1:0] data_mem [0:Mem_Width-1];

// word address
wire [A_Width-1:0] word_addr = wr_addr[D_Width-1:2] % Mem_Width;


// synchronous write
always @(posedge clk) begin
    if (w_en) begin
        case (funct3)

            3'b000: begin // sb
                case (wr_addr[1:0])
                    2'b00: data_mem[word_addr][7:0]   = wr_data[7:0];
                    2'b01: data_mem[word_addr][15:8]  = wr_data[7:0];
                    2'b10: data_mem[word_addr][23:16] = wr_data[7:0];
                    2'b11: data_mem[word_addr][31:24] = wr_data[7:0];
                endcase
            end

            3'b001: begin // sh
                case (wr_addr[0])
                    1'b0: data_mem[word_addr][15:0]  = wr_data[15:0];
                    1'b1: data_mem[word_addr][31:16] = wr_data[15:0];
                endcase
            end

            3'b010: begin // sw
                data_mem[word_addr] <= wr_data;
            end

        endcase
    end
end


// read logic
always @(*) begin
    case (funct3)

        3'b000: begin // lb
            case (wr_addr[1:0])
                2'b00: rd_data = {{24{data_mem[word_addr][7]}},  data_mem[word_addr][7:0]};
                2'b01: rd_data = {{24{data_mem[word_addr][15]}}, data_mem[word_addr][15:8]};
                2'b10: rd_data = {{24{data_mem[word_addr][23]}}, data_mem[word_addr][23:16]};
                2'b11: rd_data = {{24{data_mem[word_addr][31]}}, data_mem[word_addr][31:24]};
            endcase
        end

        3'b001: begin // lh
            case (wr_addr[0])
                1'b0: rd_data = {{16{data_mem[word_addr][15]}}, data_mem[word_addr][15:0]};
                1'b1: rd_data = {{16{data_mem[word_addr][31]}}, data_mem[word_addr][31:16]};
            endcase
        end

        3'b100: begin // lbu
            case (wr_addr[1:0])
                2'b00: rd_data = {24'b0, data_mem[word_addr][7:0]};
                2'b01: rd_data = {24'b0, data_mem[word_addr][15:8]};
                2'b10: rd_data = {24'b0, data_mem[word_addr][23:16]};
                2'b11: rd_data = {24'b0, data_mem[word_addr][31:24]};
            endcase
        end

        3'b101: begin // lhu
            case (wr_addr[0])
                1'b0: rd_data = {16'b0, data_mem[word_addr][15:0]};
                1'b1: rd_data = {16'b0, data_mem[word_addr][31:16]};
            endcase
        end

        3'b010: begin // lw
            rd_data = data_mem[word_addr];
        end

    endcase
end

endmodule