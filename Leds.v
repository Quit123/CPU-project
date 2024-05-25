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
    input			ledrst,		// reset, active high (复位信号,高电平有效)//reset
    input			led_clk,	// clk for led (时钟信号)//cpu_clk
    //input			ledwrite,	// led write enable, active high (写信号,高电平有效)//一个新button，按下后led开始亮？
    input			ledcs,		// 1 means the leds are selected as output (从memorio来的，由低至高位形成的LED片选信号)//LEDCtrl
    input	[1:0]	ledaddr,	// 2'b00 means updata the low 8bits of ledout, 2'b10 means updata the high 8 bits of ledout
    input	[15:0]	ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    output	[15:0]	ledout		// the data writen to the leds  of the board
);

    reg [15:0] ledout_design;
    assign ledout = ledout_design;

    always @ (posedge led_clk or negedge ledrst) begin
        if (ledrst == 1'b0)begin
            ledout_design <= 16'h0000;
        end
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		else if(ledcs == 1'b1) begin
		    case(ledaddr)
		      2'b10: ledout_design[15:0] <= {ledwdata[7:0], ledout_design[7:0]};
		      2'b01: ledout_design[15:0] <= {ledout_design[15:8],ledwdata[7:0]};
		      2'b11: ledout_design[15:0] <= ledwdata[15:0];
		      default : ledout_design <= ledout_design;
		      endcase
		end else begin
		    ledout_design <= ledout_design;
		end
		/*else if (ledcs == 1'b1) begin
			if (ledaddr == 2'b00) begin
				ledout_design <= ledwdata;
			end else if (ledaddr == 2'b10 )begin
            case (ledaddr)
                2'b00: ledout_design <= ledwdata; // 更新低8位
                2'b10: ledout_design <= ledwdata; // 更新高8位
                default: ledout_design <= ledout_design; // 保持不变
            endcase
            end
        end else begin
            ledout_design <= ledout_design;
        end*/
	end
endmodule
/*else begin
            ledout_design <= ledout_design;
        end*///倒数第二个end
