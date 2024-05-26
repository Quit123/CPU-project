`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/01 22:03:02
// Design Name: 
// Module Name: ALU
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


module ALU(
input[31:0] read_data1,
input[31:0] read_data2,
input[31:0] imm32,
input[1:0] ALUOp,
input[2:0] funct3,
input[6:0] funct7,
input ALUSrc,
input[6:0] opcode,
output[31:0] ALU_result,
output zero,
output check
    );
    //ALU_control
    wire[3:0] ALUControl;
    wire[31:0] operand2;
    wire blt;
    wire bge;
    wire bltu;
    wire bgeu;
    wire signed [31:0] signed_data1;
    wire signed [31:0] signed_data2;
    wire [31:0]ALU_mux;
    
    assign operand2 = (ALUSrc == 1'b1)? imm32 : read_data2;
    
    //assign zero = (ALU_mux == 32'h0000_0000)? 1'b1: 1'b0;
    //R和实用性I处理区
    assign ALUControl = (ALUOp == 2'b01 || (ALUOp == 2'b10 && funct3 == 3'b000 && funct7 == 7'b010_0000)) ? 4'b0110 ://01 -> beq 10 -> sub（加funct7是因为需要识别sub，同时没有subi）
                        (ALUOp == 2'b00 || (ALUOp == 2'b10 && funct3 == 3'b000)) ? 4'b0010 ://00 -> load|store 10 -> add(删除掉funct7是因为有addi的I类型，add指令可以不判断7),sw,lw,jalr(因为需要用到read_data1,所以不能像j直接用imm32，还是需要运算一下)
                        (ALUOp == 2'b10 && funct3 == 3'b111) ? 4'b0000 ://and
                        (ALUOp == 2'b10 && funct3 == 3'b110) ? 4'b0001 ://or
                        4'b1111;
     assign ALU_mux = (ALUControl == 4'b0010) ? read_data1 + operand2 ://下面处理R、一部分I，S，一部分B(beq)
                    (ALUControl == 4'b0110) ? read_data1 - operand2 :
                    (ALUControl == 4'b0000) ? read_data1 & operand2 :
                    (ALUControl == 4'b0001) ? read_data1 | operand2 :
                    (opcode == 7'b0010011 && funct3 == 3'b001) ? read_data1 << operand2 ://下面处理slli和srli
                    (opcode == 7'b0010011 && funct3 == 3'b101) ? read_data1 >> operand2 :
                    32'h00000000;
     
     //B类型处理区
     assign signed_data1 = $signed(read_data1);
     assign signed_data2 = $signed(read_data2);
     
     assign blt  = signed_data1 < signed_data2;
     assign bge  = signed_data1 >= signed_data2;
     assign bltu = read_data1 < read_data2;
     assign bgeu = read_data1 >= read_data2;
     
     assign check = blt || bge || bltu || bgeu;
     
     assign zero = ((ALUOp == 2'b01 && ((funct3 == 3'b000 && ALU_mux == 32'h0000_0000) || //beq
                (funct3 == 3'b001 && ALU_mux != 32'h0000_0000) || //bne
                (funct3 == 3'b100 && blt == 1'b1) || //blt
                (funct3 == 3'b101 && bge == 1'b1) || //bge
                (funct3 == 3'b110 && bltu == 1'b1) || //bltu
                (funct3 == 3'b111 && bgeu == 1'b1)))) ||//bgeu
                opcode == 7'b110_1111 || opcode == 7'b110_0111 ? 1'b1 : 1'b0;//jal(j),jalr
     assign ALU_result = ((ALUOp == 2'b01 && ((funct3 == 3'b000 && ALU_mux == 32'h0000_0000) ||//beq
                        (funct3 == 3'b001 && ALU_mux != 32'h0000_0000) || //bne
                        (funct3 == 3'b100 && blt == 1'b1) || //blt
                        (funct3 == 3'b101 && bge == 1'b1) || //bge
                        (funct3 == 3'b110 && bltu == 1'b1) || //bltu
                        (funct3 == 3'b111 && bgeu == 1'b1)))) || //bgeu
                        opcode == 7'b110_1111 ? imm32 : ALU_mux;//lw这里没有问题（就是ALU_mux）//jal(j) imm32,jalr ALU_mux
endmodule
    //blt funct3 : 4
//bge funct3 : 5
//bltu funct3 : 6
//bltu funct3 : 7
//lw,sw,beq, add, sub, and, or
//add->0010
//sub->0110
//and->0000
//or->0001
     /*
     always@(read_data1, operand2, ALUControl) begin
        case(ALUControl)
            4'b0010: ALU_mux <= read_data1 + operand2;
            4'b0110: ALU_mux <= read_data1 - operand2;
            4'b0000: ALU_mux <= read_data1 & operand2;
            4'b0001: ALU_mux <= read_data1 | operand2;
        default: ALU_mux <= 32'h00000000;
        endcase
     end
     //slli处理and srli
     always @(read_data1, operand2) begin
        if(opcode == 7'b0010011 && funct3 == 3'b001)begin
            ALU_mux = read_data1 << operand2;
        end
        if(opcode == 7'b0010011 && funct3 == 3'b101)begin
            ALU_mux = read_data1 >> operand2;
        end
     end*/