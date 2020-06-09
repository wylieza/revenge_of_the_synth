`timescale 1us / 1ns
/**************************************************************************************
------ Module Description -----
Author > Justin Wylie

Description > This is the main driver module

Usage:
Accepts > All peripherals being used for input
Returns > All peripherals being used for output

Clocking & Reset:
Requires Clock > Yes
Reset Bit > No
Enable Bit > No

**************************************************************************************/


module top(
    input  CLK100MHZ,
    input [15:0] SW,
    input BTNC,
    input BTNU,
    input BTNL,
    input BTNR,
    input BTND,
    output AUD_PWM, 
    output AUD_SD,
    output [15:0] LED,
    output reg CA,
	output reg CB,
	output reg CC,
	output reg CD,
	output reg CE,
	output reg CF,
	output reg CG,
	output reg DP,
	output reg [7:0] AN = 8'hFF
    );


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Global Reset registers
reg reset = 1'b0;

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Leds
reg [15:0] leds;
assign LED = leds;

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Button debounced states 
wire btn_left;
wire btn_right;
wire btn_up;
wire btn_down;
wire btn_center;

//Debounce module instantiation
debounced_button m_btn_left(CLK100MHZ, BTNL, btn_left);
debounced_button m_btn_right(CLK100MHZ, BTNR, btn_right);
debounced_button m_btn_up(CLK100MHZ, BTNU, btn_up);
debounced_button m_btn_down(CLK100MHZ, BTND, btn_down);
debounced_button m_btn_center(CLK100MHZ, BTNC, btn_center);

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Seven Segment digits and control
reg [3:0] ss_ld3, ss_ld2, ss_ld1, ss_ld0, ss_rd3, ss_rd2, ss_rd1, ss_rd0; //'ss' - seven segment, 'l/r' - right/left, 'dn' - digit n (when higher n is higher significance (MSB vs LSB))
wire [7:0] ssunits_disable; //disable individual units
wire [7:0] segments_disable; //disable individual segments

//SS module instantiation
ssdriver m_ssdriver(CLK100MHZ, reset, ss_ld3, ss_ld2, ss_ld1, ss_ld0, ss_rd3, ss_rd2, ss_rd1, ss_rd0, ssunits_disable, segments_disable);

//SS display refresh circuit
always @(*) begin
    AN[7:0] <= ssunits_disable[7:0];
    CA <= segments_disable[0];
	CB <= segments_disable[1];
	CC <= segments_disable[2];
	CD <= segments_disable[3];
	CE <= segments_disable[4];
	CF <= segments_disable[5];
	CG <= segments_disable[6];
	DP <= segments_disable[7];
end

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------









//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Clock Cycle Logic
always @(posedge CLK100MHZ) begin
    if(btn_left) begin
        ss_ld3 <= 4'd3;
        ss_ld2 <= 4'd2;
        ss_ld1 <= 4'd1;
        ss_ld0 <= 4'd0;        
    end else begin
        ss_ld3 <= 4'd4;
        ss_ld2 <= 4'd3;
        ss_ld1 <= 4'd2;
        ss_ld0 <= 4'd1;
    end
    
    if(btn_right) begin
        ss_rd3 <= 4'd9;
        ss_rd2 <= 4'd8;
        ss_rd1 <= 4'd7;
        ss_rd0 <= 4'd6;        
    end else begin
        ss_rd3 <= 4'd8;
        ss_rd2 <= 4'd7;
        ss_rd1 <= 4'd6;
        ss_rd0 <= 4'd5;
    
    end
    
    if(btn_center) begin
        leds[15:0] <= 16'hFFFF;
    end else begin
        leds[15:0] <= 16'h9999;
    end






end

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







endmodule
