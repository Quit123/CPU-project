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
    input [31:0] Instruction,
    input RegWrite,
    //output shift_mount,//ʵ��sllָ��
    //output [11:0] immediate_12,//I|S|SB//ʵ��һЩ����ָ��
    output reg [31:0] imm32
    /*output[31:0] read_data1,
    output[31:0] read_data2,
    output Branch,
    output MemRead,
    output MemtoReg,
    output ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite*/
    //no U/UJ
    );
    wire [6:0] opcode;
    wire [4:0] rs2;
    wire [4:0] rs1;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;
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
    
    
endmodule
