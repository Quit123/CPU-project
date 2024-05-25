`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 14:28:51
// Design Name: 
// Module Name: Ana_Instruction
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


module Ana_Instruction(
input clk,
input clk_j,
input reset,
input Branch,
input zero,
input[6:0] opcode,
input[31:0] ALU_result,
output[31:0] Instruction,
output[31:0] next_PC_plus_4
    );
    reg[31:0] PC; // 程序计数器
    reg[31:0] next_PC_4;
    
    assign next_PC_plus_4 = next_PC_4;
    
    always@(negedge clk, negedge reset)begin
        if(reset == 1'b0)begin
            PC <= 32'h0000_0000;
        end else begin
            if(opcode == 7'b110_0111)begin//jalr
                PC <= (Branch && zero) ? ALU_result : 32'h0000_0000;
            end else begin
                PC <= (Branch && zero) ? PC + ALU_result : PC + 32'h0000_0004;
            end
        end
    end
    always@(posedge clk ,negedge reset)begin
        if(reset == 1'b0)begin
            next_PC_4 <= 32'h0000_0000;
        end else begin
            next_PC_4 <= PC + 32'h0000_0004;
        end
    end
    prgrom urom(.clka(clk), .addra(PC[15:2]), .douta(Instruction));
endmodule
    //reg next_PC_plus_4;
//reg re_isBranch;

// 分支条件判断
//assign isBranch = (Branch && zero) ? 1'b1 : 1'b0;

/*always@(negedge clk_j, negedge clk)begin
    if(clk_j == 1'b0)begin
        isBranch <= 1'b0;
    end else begin
        isBranch <= (Branch == 1'b1 && zero == 1'b1) ? 1'b1 : 1'b0;
    end
end
// 下一个PC值的组合逻辑
always@(posedge clk, negedge reset, posedge isBranch)begin
    if(reset == 1'b0)begin
        PC <= 32'h0000_0000;
    end else if(clk == 1'b1 || isBranch == 1'b1) begin
        if((isBranch == 1'b1 && ALU_result == 32'h0000_0000))begin//连续beq和j
            PC <= PC - 32'h0000_0004;
        end else if(isBranch == 1'b1 && opcode == 7'b110_1111) begin
            PC <= {PC[31:0] + ALU_result[31:0]} - 32'h0000_0004;
        end else begin
            PC <= (isBranch) ? {{PC[31:0] + ALU_result[31:0]} - 32'h0000_0004}:(PC + 32'h0000_0004);//需要检验，lw，sw和beq，bne这种
        end
    end
end*/

                //PC <= (isBranch) ? {PC[31:2] + ALU_result[29:0], PC[1:0]}:(PC + 32'h0000_0004);

    /*always@(posedge clk, negedge reset)begin
        if(reset == 1'b0)begin
            PC <= 32'h0000_0000;
        end
    end
    always@(negedge clk)begin
        PC <= (Branch && zero) ? PC + ALU_result : PC + 32'h0000_0004;
    end*/