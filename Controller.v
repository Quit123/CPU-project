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
    
    output MemOrIOtoReg, // 1 indicates that data needs to be read from memory or I/O to the register
    output IORead_singal, // 1 indicates I/O read
    output IOWrite_singal, // 1 indicates I/O write
    //type:判断指令结束地点
    output basic_cal_type,//add,sub,and,or,addi,下面这些可能在判断多周期上用到，目前无用
    output l_type,//lw
    output s_type,//sw
    output b_type//beq
    );
    assign Branch = (opcode == 7'b110_0011) ? 1'b1 : 1'b0;
    assign MemWrite = (opcode == 7'b010_0011) ? 1'b1 : 1'b0;//sw时为1，可以向mem存
    assign MemRead = (opcode == 7'b000_0011) ? 1'b1 : 1'b0;
    assign MemtoReg = (opcode == 7'b000_0011) ? 1'b1 : 1'b0;
    assign RegWrite = (opcode == 7'b011_0011 || opcode == 7'b000_0011 || opcode == 7'b001_0011) ? 1'b1 : 1'b0;
    assign ALUOp = (opcode == 7'b011_0011 || opcode == 7'b001_0011) ? 2'b10 :  //add、sub、and、or
                   (opcode == 7'b000_0011 || opcode == 7'b010_0011) ? 2'b00 :  //ld、sw
                   (opcode == 7'b110_0011) ? 2'b01 : 2'b11;//11无意义  01beq
    assign ALUSrc = (opcode == 7'b000_0011 || opcode == 7'b001_0011 || opcode == 7'b010_0011) ? 1'b1 : 1'b0;
    
    assign IORead_singal = (opcode == 7'b0000011 && Alu_resultHigh == 22'b1111_1111_1111_1111_1111_11) ? 1'b1 : 1'b0;
    assign IOWrite_singal = (opcode == 7'b0100011 && Alu_resultHigh == 22'b1111_1111_1111_1111_1111_11) ? 1'b1 : 1'b0;//sw时判断输入地址，向设备输入，显示数码管
    assign MemOrIOtoReg = IORead_singal || IOWrite_singal;
    assign basic_cal_type = (opcode == 7'b011_0011 || opcode == 7'b001_0011) ? 1'b1 : 1'b0;
    assign l_type = (opcode == 7'b000_0011) ? 1'b1 : 1'b0;
    assign s_type = (opcode == 7'b010_0011) ? 1'b1 : 1'b0;
    assign b_type = (opcode == 7'b110_0011) ? 1'b1 : 1'b0;
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
