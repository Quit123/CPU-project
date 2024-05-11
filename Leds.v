`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 14:28:51
// Design Name: 
// Module Name: Leds
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


module Leds (
    input			ledrst,		// reset, active high (��λ�ź�,�ߵ�ƽ��Ч)//reset
    input			led_clk,	// clk for led (ʱ���ź�)//cpu_clk
    input			ledwrite,	// led write enable, active high (д�ź�,�ߵ�ƽ��Ч)//һ����button�����º�led��ʼ����
    input			ledcs,		// 1 means the leds are selected as output (��memorio���ģ��ɵ�����λ�γɵ�LEDƬѡ�ź�)//LEDCtrl
    input	[1:0]	ledaddr,	// 2'b00 means updata the low 8bits of ledout, 2'b10 means updata the high 8 bits of ledout
    input	[15:0]	ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    output	[7:0]	ledout		// the data writen to the leds  of the board
);

    reg [7:0] ledout_design;
    assign ledout = ledout_design;

    always @ (posedge led_clk or posedge ledrst) begin
        if (ledrst)
            ledout_design <= 24'h000000;
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		else if (ledcs && ledwrite) begin
			if (ledaddr == 2'b00)
				ledout_design[7:0] <= {ledwdata[7:0] };
			else if (ledaddr == 2'b10 )
				ledout_design[7:0] <= { ledwdata[15:8]};
			else
				ledout_design <= ledout_design;
        end else begin
            ledout_design <= ledout_design;
        end
    end
	
endmodule

