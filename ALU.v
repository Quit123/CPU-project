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
output[31:0] ALU_result,
output zero,
output check
    );
    //blt funct3 : 4
    //bge funct3 : 5
    //bltu funct3 : 6
    //bltu funct3 : 7
    //lw,sw,beq, add, sub, and, or
    //add->0010
    //sub->0110
    //and->0000
    //or->0001
    
    //ALU_control
    wire func7;
    wire[3:0] ALUControl;
    wire[31:0] operand2;
    wire blt;
    wire bge;
    wire bltu;
    wire bgeu;
    wire signed [31:0]data1;
    wire signed [31:0]data2;
    reg [31:0]ALU_mux;
    
    assign func7 = funct7[5];
    assign operand2 = (ALUSrc == 1'b1)? imm32 : read_data2;
    
    //assign zero = (ALU_mux == 32'h0000_0000)? 1'b1: 1'b0;
    assign ALUControl = (ALUOp == 2'b01 || (ALUOp == 2'b10 && funct3 == 3'b000 && func7 == 1'b1)) ? 4'b0110 ://01 -> beq 10 -> sub
                        (ALUOp == 2'b00 || (ALUOp == 2'b10 && funct3 == 3'b000 && func7 == 1'b0)) ? 4'b0010 ://00 -> load|store 10 -> add
                        (ALUOp == 2'b10 && funct3 == 3'b111) ? 4'b0000 ://and
                        (ALUOp == 2'b10 && funct3 == 3'b110) ? 4'b0001 ://or
                        4'b0000;
     
     always@(read_data1, operand2, ALUControl) begin
        case(ALUControl)
            4'b0010: ALU_mux <= read_data1 + operand2;
            4'b0110: ALU_mux <= read_data1 - operand2;
            4'b0000: ALU_mux <= read_data1 & operand2;
            4'b0001: ALU_mux <= read_data1 | operand2;
        default: ALU_mux <= 32'h00000000;
        endcase
     end
     
     assign data1 = $signed(read_data1);
     assign data2 = $signed(read_data2);
     
     assign blt = (data1 < data2) ? 1'b1 : 1'b0;
     assign bge = (data1 >= data2) ? 1'b1 : 1'b0;
     assign bltu = (read_data1 < operand2) ? 1'b1 : 1'b0;
     assign bgeu = (read_data1 >= operand2) ? 1'b1 : 1'b0;
     
     assign check = (blt == 1'b1 || bge == 1'b1 || bltu == 1'b1 || bgeu == 1'b1) ? 1'b1 : 1'b0;
     
     assign zero = (ALUOp == 2'b01 && ((funct3 == 3'b000 && ALU_mux == 32'h0000_0000) || //beq
                (funct3 == 3'b001 && ALU_mux != 32'h0000_0000) || //bne
                (funct3 == 3'b100 && blt == 1'b1) || //blt
                (funct3 == 3'b101 && bge == 1'b1) || //bge
                (funct3 == 3'b110 && bltu == 1'b1) || //bltu
                (funct3 == 3'b111 && bgeu == 1'b1))) ? 1'b1 : 1'b0;//bgeu
     assign ALU_result = (ALUOp == 2'b01 && ((funct3 == 3'b000 && ALU_mux == 32'h0000_0000) ||
                        (funct3 == 3'b001 && ALU_mux != 32'h0000_0000) || //bne
                        (funct3 == 3'b100 && blt == 1'b1) || //blt
                        (funct3 == 3'b101 && bge == 1'b1) || //bge
                        (funct3 == 3'b110 && bltu == 1'b1) || //bltu
                        (funct3 == 3'b111 && bgeu == 1'b1))) ? imm32 : ALU_mux;//bgeu
endmodule
