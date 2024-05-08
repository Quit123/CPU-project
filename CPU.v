`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/07 15:20:24
// Design Name: 
// Module Name: CPU
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


module CPU(
input clk,
input rst,
input[2:0] test_index,
input reset,
input[15:0] io_read_data,//开关输入数据
output[31:0] write_data,//MemOrIO中的，之后可能用来显示字母
output check//测试场景1的011-111结果显示
//input[23:0] switch2N4,
//output wire [23:0]led2N4
    );
    reg cpu_clk;
    reg[31:0] PC;//instruction_address
    reg[31:0] mem_addr;//mem_address
    reg[31:0] data_to_reg;//mem或io设备向register中写数据（lw）
    //reg[]
    //reg[31:0] ALU_PC;//通过beq跳转计算获得的address
    wire[31:0] Instruction;
    wire[2:0] funct3;
    wire[6:0] funct7;
    wire[31:0] read_data1;
    wire[31:0] read_data2;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire[1:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire MemOrIOtoReg;
    wire IORead;
    wire IOWrite;
    wire[31:0] ALU_result;
    wire[31:0] imm32;
    wire zero;
    wire mem_data_in;//向data mem写入的数据
    wire mem_data_out;//data mem输出的数据
    wire LEDCtrl;//用于控制LED灯是否会亮 == 1'b1拨动开关led灯才会亮
    wire SwitchCtrl;//用于控制开关输入信息是否有效 == 1'b1才能有效拨动开关
    
    cpuclk Clk(.clk_in1(clk),.clk_out1(cpu_clk));
    //这里进行修改，进行选择然后放入strand_PC
    //wire strand_PC;
    //assign strand_PC = 
    m_inst instruction(.clk(cpu_clk),.PC(PC),
                        .Instruction(Instruction));
                        
    Controller con(.opcode(Instruction[6:0]),
                    .Branch(Branch),.MemRead(MemRead),
                    .MemtoReg(MemtoReg),.ALUOp(ALUOp),
                    .MemWrite(MemWrite),.ALUSrc(ALUSrc),
                    .RegWrite(RegWrite));
                    
    Decoder decoder(.reset(reset),.Instruction(Instruction),
                    .RegWrite(RegWrite),.data_to_reg(data_to_reg),
                    .imm32(imm32),.funct3(funct3),.funct7(funct7),
                    .read_data1(read_data1),.read_data2(read_data2),
                    .MemOrIOtoReg(MemOrIOtoReg),.IORead(IORead),.IOWrite(IOWrite));
    
    ALU alu(.clk(cpu_clk),.ALUOp(ALUOp),.funct3(funct3),
            .funct7(funct7[5]),.read_data1(read_data1),
            .read_data2(read_data2),.imm32(imm32),
            .ALUSrc(ALUSrc),.zero(zero),.ALU_result(ALU_result));
    
    MemOrIO mem_or_io(.MemRead(MemRead),.MemWrite(MemWrite),
                    .IORead(IORead),.IOWrite(IOWrite),
                    .addr_in(ALU_result),.addr_out(mem_addr),
                    .mem_read_data(mem_data_out),.io_read_data(io_read_data),
                    .rdata(data_to_reg),.register_read_data(read_data1),
                    .write_data(write_data),.LEDCtrl(LEDCtrl),.SwitchCtrl(SwitchCtrl));
    
    DMem data_mem(.clk(cpu_clk),.MemRead(MemRead),.MemWrite(MemWrite),
                .addr(mem_addr),.data_in(mem_data_in),.data_out(mem_data_out));
    
    always@(posedge reset)begin
    PC <= 32'h0000_0000;
    end
endmodule
