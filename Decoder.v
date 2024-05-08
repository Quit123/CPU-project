`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/01 20:07:46
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    input reset,
    input[31:0] Instruction,
    input RegWrite,
    input[31:0] data_to_reg,
    //output shift_mount,//实现sll指令
    //output [11:0] immediate_12,//I|S|SB//实现一些特殊指令
    output reg [31:0] imm32,
    output[2:0] funct3,
    output[6:0] funct7,
    output[31:0] read_data1,
    output[31:0] read_data2
    );
    reg [4:0]i;
    wire [6:0] opcode;
    wire [4:0] rs2;
    wire [4:0] rs1;
    wire [4:0] rd;

    reg [31:0] register[0:31];
    
    //Task 1: get information about the data from the 
    //instruction (Decoder in Data Path)
    assign opcode = Instruction[6:0];
    assign rs2 = Instruction[24:20];
    assign rs1 = Instruction[19:15];
    assign rd = Instruction[11:7];
    assign funct3 = Instruction[14:12];
    assign funct7 = Instruction[31:25];
    //assign shift_mount = Instruction[24:20];//R|I
    Build_imm imm(.instruction(Instruction), .imm32(imm32));
    //Task 2: generated control signals according to the 
    //instruction (Controller in Control Path)
    always@(posedge reset)begin
        i <= 0; // 重置计数器
        for (i = 0; i < 32; i = i + 1) begin
            register[i] <= 32'h0000_0000; // 清零操作
        end
    end
endmodule

