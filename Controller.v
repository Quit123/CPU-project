`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 15:06:04
// Design Name: 
// Module Name: Controller
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


module Controller(
    input[21:0] Alu_resultHigh, // From the execution unit Alu_Result[31..10]
    
    input [6:0] opcode,
    output Branch,
    output MemRead,
    output MemtoReg,
    output[1:0] ALUOp,
    output MemWrite,
    output ALUSrc,
    output RegWrite,
    
    output reg MemOrIOtoReg, // 1 indicates that data needs to be read from memory or I/O to the register
    output reg IORead, // 1 indicates I/O read
    output reg IOWrite // 1 indicates I/O write
    );
    assign Branch = (opcode == 7'b110_0011) ? 1'b1 : 1'b0;
    assign MemWrite = (opcode == 7'b010_0011) ? 1'b1 : 1'b0;
    assign MemRead = (opcode == 7'b000_0011) ? 1'b1 : 1'b0;
    assign MemtoReg = (opcode == 7'b000_0011) ? 1'b1 : 1'b0;
    assign RegWrite = (opcode == 7'b011_0011 || opcode == 7'b000_0011 || opcode == 7'b001_0011) ? 1'b1 : 1'b0;
    assign ALUOp = (opcode == 7'b011_0011 || opcode == 7'b001_0011) ? 2'b10 :
                   (opcode == 7'b000_0011 || opcode == 7'b010_0011) ? 2'b00 :
                   (opcode == 7'b110_0011) ? 2'b01 : 2'b11;//11无意义
    assign ALUSrc = (opcode == 7'b000_0011 || opcode == 7'b001_0011 || opcode == 7'b00_0011) ? 1'b1 : 1'b0;
endmodule
            /*7'b001_0111, 7'b011_0111:begin//U aupic、lui
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 1'b0;
            MemWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            end
            7'b110_1111:begin//UJ jal
            Branch = 1'b1;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 1'b0;
            MemWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b1;
            end*/
