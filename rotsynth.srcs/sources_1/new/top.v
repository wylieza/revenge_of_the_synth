`timescale 1ns / 1ps
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

**************************************************************************************///////////////////////////////////////////////////////////////////////////////////


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
    
    
    
    
    
    
    
endmodule
