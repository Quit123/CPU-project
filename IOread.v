`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 14:58:15
// Design Name: 
// Module Name: IOread
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


module IOread (
    input			reset,				// reset, active high ��λ�ź� (�ߵ�ƽ��Ч)
	input			ior,				// from Controller, 1 means read from input device(�ӿ���������I/O��)
    input			switchctrl,			// means the switch is selected as input device (��memorio������ַ�߶��߻�õĲ��뿪��ģ��Ƭѡ)
    input	[15:0]	ioread_data_switch,	// the data from switch(���������Ķ����ݣ��˴����Բ��뿪��)
    output	[15:0]	ioread_data 		// the data to memorio (���������������͸�memorio)
);
    
    reg [15:0] ioread_data_design;
    assign ioread_data = ioread_data_design;
    
    always @* begin
        if (reset)
            ioread_data_design = 16'h0;
        else if (ior == 1) begin
            if (switchctrl == 1)
                ioread_data_design = ioread_data_switch;
            else
				ioread_data_design = ioread_data_design;
        end
    end
	
endmodule
