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
    input memRead, //key-sign -> read memory, from Controller，读出mem
    input memWrite, //key-sign -> write memory, from Controller，写入mem
    input ioRead, //key-sign -> read IO, from Controller，读入设备
    input ioWrite, //key-sign -> write IO, from Controller,传入设备
    
    input[31:0] addr_in, // from alu_result in ALU
    output[31:0] addr_out, // address to Data-Memory
    
    input[31:0] mem_read_data, // data read from Data-Memory
    input[15:0] io_read_data, // data read from IO,16 bits//(From input device)
    output[31:0] rdata, // data from mem or io and write into register
    
    input[31:0] register_read_data, // data read from Decoder(register file)
    output [31:0] write_data, // data to memory or I/O（m_wdata, io_wdata）
                                 //可能也是方便显示灯管信号
    output LEDCtrl, // 控制LED信号
    output SwitchCtrl // 控制开关输入信息
    );
    //所有输入信号先传入register（memory或I/O设备）
    //再从register中读信号，传出（这个信号可能是memory或是I/O设备）
    reg data;
    assign addr_out = addr_in;//传入地址等于传出地址
    assign rdata = (memRead == 1'b1) ? mem_read_data : {16'h0000 ,io_read_data};//mem或io信息写入寄存器
    assign write_data = (memWrite == 1'b1 || ioWrite == 1'b1) ? (memWrite == 1'b1 ? register_read_data : {16'h0000, register_read_data[15:0]}) : 32'hffffffff;//向mem或io输入信息
    assign LEDCtrl = (ioWrite == 1'b1) ? 1'b1 : 1'b0;//led的显示输出
    assign SwitchCtrl = (ioRead == 1'b1) ? 1'b1 : 1'b0;//拨动开关输入
endmodule

    /*always @* begin
    //差通过input device输入情况
    if((memWrite==1'b1)||(ioWrite==1'b1))
        if(memRead == 1'b1)begin//从mem读，向设备输出
            write_data <= m_rdata;
        end
        if(ioRead == 1'b1)begin
            write_data <= r_rdata;//从register读，写入mem
        end
    else
        write_data = 32'hZZZZZZZZ;
        if(memRead == 1'b1)begin
            data <= m_rdata;//从mem读，写入register
        end
        if(ioRead == 1'b1)begin
            data <= io_rdata;//从I/O设备读，写入register
        end
    end*/
