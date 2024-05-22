`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/05 11:22:54
// Design Name: 
// Module Name: MemOrIO
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


module MemOrIO(
//MemOrIO determine:
//1). The source of r_wdata
//2). The destination of r_rdata
    input MemRead, //key-sign -> read memory, from Controller，读出mem
    input MemWrite, //key-sign -> write memory, from Controller，写入mem
    input IORead_singal, //key-sign -> read IO, from Controller，将数据显示在设备上(lw)
    input IOWrite_singal, //key-sign -> write IO, from Controller,将数据传入设备(sw)
    
    input[31:0] addr_in, // from alu_result in ALU
    output[31:0] addr_out, // address to Data-Memory
    
    input[31:0] mem_read_data, // data read from Data-Memory
    input[15:0] io_read_data, // data read from IO,16 bits//(From input device)
    output[31:0] rdata, // data from mem or io and write into register
    
    input[31:0] register_read_data, // data read from Decoder(register file)
    
    output [31:0] write_data, // data to memory or I/O（m_wdata, io_wdata）
    output LEDCtrl, //控制LED信号
    output SwitchCtrl, //控制开关输入信息
    output DigitalCtrl, //控制数码管
    output[15:0] led_data
    );
    //所有输入信号先传入register（memory或I/O设备）
    //再从register中读信号，传出（这个信号可能是memory或是I/O设备）
    reg data;
    wire[31:0] WD;
    assign WD = (MemWrite == 1'b1 || IOWrite_singal == 1'b1) ? register_read_data : 32'hffffffff;
    assign addr_out = addr_in;//传入地址等于传出地址
    assign rdata = (IORead_singal == 1'b1) ? {16'h0000 ,io_read_data} : mem_read_data;//(lw)mem向register,这里需要对lb的类型进
    assign write_data = WD;//好像没有必要前16bit是0，iooutput为什么一定要是0呢(sw)向mem或io输入信息
    assign LEDCtrl = (IORead_singal == 1'b1 || IOWrite_singal == 1'b1) ? 1'b1 : 1'b0;//(lw)led的显示输出
    assign SwitchCtrl = (IORead_singal == 1'b1) ? 1'b1 : 1'b0;//(lw)拨动开关输入
    assign DigitalCtrl = (IORead_singal == 1'b1 || IOWrite_singal == 1'b1) ? 1'b1 : 1'b0;
    assign led_data = (IORead_singal == 1'b1) ? io_read_data ://当lw
                    (IOWrite_singal == 1'b1) ? WD[15:0] : 16'h0000;//和sw时，只要地址正确，就会像led中输入数据
endmodule
/*
    reg data;
assign addr_out = addr_in;//传入地址等于传出地址
assign rdata = (MemRead == 1'b1) ? mem_read_data ://(lw)mem向register,这里需要对lb的类型进行修改
               (IORead_singal == 1'b1) ? {16'h0000 ,io_read_data} : 32'h0000_0000;//(lw)io向寄存器
assign write_data = (MemWrite == 1'b1) ? register_read_data ://(sw)
                    (IOWrite_singal == 1'b1) ? {16'h0000, register_read_data[15:0]} : 32'hffffffff;//好像没有必要前16bit是0，iooutput为什么一定要是0呢(sw)向mem或io输入信息
assign LEDCtrl = (IORead_singal == 1'b1) ? 1'b1 : 1'b0;//(lw)led的显示输出
assign SwitchCtrl = (IORead_singal == 1'b1) ? 1'b1 : 1'b0;//(lw)拨动开关输入
assign DigitalCtrl = IORead_singal || IOWrite_singal;
endmodule

*/

