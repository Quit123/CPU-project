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
output[31:0] imm32
    );

wire [11:0] imm12_I, imm12_S, imm12_SB;
wire [19:0] imm20_U, imm20_UJ;
wire [31:0] imm_I, imm_S, imm_SB, imm_U, imm_UJ;

assign imm12_I = instruction[31:20];
assign imm_I = {{20{imm12_I[11]}}, imm12_I};

assign imm12_S = {instruction[31:25], instruction[11:7]};
assign imm_S = {{20{imm12_S[11]}}, imm12_S};

assign imm12_SB = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
assign imm_SB = {{19{imm12_SB[11]}}, imm12_SB, 1'b0};

assign imm20_U = instruction[31:12];
assign imm_U = {imm20_U, 12'b0};

assign imm20_UJ = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
assign imm_UJ = {{11{imm20_UJ[19]}}, imm20_UJ, 1'b0};

assign imm32 = (instruction[6:0] == 7'b0000011 || // lw
                instruction[6:0] == 7'b0010011) ? imm_I :
               (instruction[6:0] == 7'b0100011) ? imm_S :
               (instruction[6:0] == 7'b1100011) ? imm_SB :
               (instruction[6:0] == 7'b0010111) ? imm_U :
               (instruction[6:0] == 7'b1101111) ? imm_UJ :
               32'h0000_0000;
endmodule
/*wire[11:0] imm12;
wire[19:0] imm20;*/
/*assign imm12 = (instruction[6:0] == 7'b0010011 || instruction[6:0] == 7'b0000011) ? instruction[31:20] ://0010011I-format,0000011,(lw)I-format
               (instruction[6:0] == 7'b0100011) ? {instruction[31:25],instruction[11:7]} ://S-format
               (instruction[6:0] == 7'b1100011) ? {instruction[31], instruction[7], instruction[30:25], instruction[11:8]} ://SB-format
               12'h000;
assign imm20 = (instruction[6:0] == 7'b0010111) ? instruction[31:12] ://U-format
               (instruction[6:0] == 7'b1101111) ? {instruction[31], instruction[19:12], instruction[20], instruction[30:21]} ://(jal)UJ-format
               20'h00000;
assign imm32 = (instruction[6:0] == 7'b0000011) ? {{20{imm12[11]}}, imm12[11:0]} ://(lw)
               (instruction[6:0] == 7'b0010011) ? {{20{imm12[11]}}, imm12[11:0]} ://(addi)
               (instruction[6:0] == 7'b1100011) ? {{19{imm12[11]}}, imm12[11:0],1'b0} ://(beq.bne...)计算的两行之间的差值
               (instruction[6:0] == 7'b0100011) ? {{20{imm12[11]}}, imm12[11:0]} ://(sw)
               (instruction[6:0] == 7'b0010111) ? {imm20[19:0], 12'b0} ://no
               (instruction[6:0] == 7'b1101111) ? {{11{imm20[19]}}, imm20[19:0], 1'b0} ://(jal)
               32'h0000_0000;*/
//slli在这里也能正常转换成32bit