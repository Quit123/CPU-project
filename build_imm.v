`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 14:59:39
// Design Name: 
// Module Name: build_imm
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


module Build_imm(
input[31:0] instruction,
output reg[31:0] imm32
    );
reg[11:0] imm12 = 12'b0000_0000_0000;
reg[19:0] imm20 = 20'b0000_0000_0000_0000_0000;
always @(*) begin
    case (instruction[6:0])
        7'b0010011, 7'b0000011:begin//I-format
        imm12 = instruction[31:20];
            if(instruction[6:0] == 7'b0000011 && (instruction[14:12] == 3'b100 || instruction[14:12] == 3'b101))begin
            imm32 = {20'b0, imm12[11:0]};
            end else begin
            imm32 = {{20{imm12[11]}}, imm12[11:0]};
            end
        end
        7'b1100011:begin//S-format
        imm12 = {instruction[31:25],instruction[11:7]};
        imm32 = {{20{imm12[11]}}, imm12[11:5]};
        end
        7'b0100011:begin//SB-format
        imm12 = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
        imm32 = {{19{imm12[11]}}, imm12[11:0], 1'b0};
        end
        7'b0010111:begin//U-format
        imm20 = instruction[31:12];
        imm32 = {imm20[19:0], 12'b0};
        end
        7'b1101111:begin//UJ-format
        imm20 = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
        imm32 = {{11{imm20[19]}}, imm20[19:0], 1'b0};
        end
        default:begin
        imm32 = 32'b0;
        end
    endcase
end
endmodule
