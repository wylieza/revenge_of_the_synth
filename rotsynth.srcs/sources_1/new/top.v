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
	output reg [7:0] AN = 8'hFE
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
reg[13:0] ssd_left_value;
reg[13:0] ssd_right_value;
wire [3:0] ss_ld3, ss_ld2, ss_ld1, ss_ld0, ss_rd3, ss_rd2, ss_rd1, ss_rd0; //'ss' - seven segment, 'l/r' - right/left, 'dn' - digit n (when higher n is higher significance (MSB vs LSB))
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

//SS Decimal to BCD converter modules
decimal_to_bcd m_decimal_to_bcd_left(CLK100MHZ, ssd_left_value, ss_ld3, ss_ld2, ss_ld1, ss_ld0);
decimal_to_bcd m_decimal_to_bcd_right(CLK100MHZ, ssd_right_value, ss_rd3, ss_rd2, ss_rd1, ss_rd0);

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Voices
reg [12:0] tick_periods [7:0]; // ticT = 100e6/(freq*256)
reg [1:0] waveforms [7:0];
wire [10:0] sample_values [7:0]; // 00: Sine, 	01: Square, 	11: Sawtooth


//Function Generators
function_generator m_fg_0(CLK100MHZ, tick_periods[0], waveforms[0], sample_values[0]);
function_generator m_fg_1(CLK100MHZ, tick_periods[1], waveforms[1], sample_values[1]);
function_generator m_fg_2(CLK100MHZ, tick_periods[2], waveforms[2], sample_values[2]);
function_generator m_fg_3(CLK100MHZ, tick_periods[3], waveforms[3], sample_values[3]);
function_generator m_fg_4(CLK100MHZ, tick_periods[4], waveforms[4], sample_values[4]);
function_generator m_fg_5(CLK100MHZ, tick_periods[5], waveforms[5], sample_values[5]);
function_generator m_fg_6(CLK100MHZ, tick_periods[6], waveforms[6], sample_values[6]);
function_generator m_fg_7(CLK100MHZ, tick_periods[7], waveforms[7], sample_values[7]);


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Voice Mixer Setup
reg [7:0] enable_mask = 8'b0;
wire [10:0] mixed_audio_sv;

mixer m_mixer(sample_values[0], sample_values[1], sample_values[2], sample_values[3], sample_values[4], sample_values[5], sample_values[6], sample_values[7], enable_mask, mixed_audio_sv);

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//PWM Audio Configuration
assign AUD_SD = 1'b1;  // Enable audio out

//Set up audio PWMor and attach the AUD_PWM pin to it
pwmor m_pwmor(
    CLK100MHZ,
    mixed_audio_sv,
    AUD_PWM
);


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Voice enable using switches

always @(*) begin
    enable_mask[7:3] <= SW[7:3];
end


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//SSD Update

always @(*) begin
    ssd_left_value <= tick_periods[0];
    ssd_right_value <= tick_periods[1];
end



//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Clock Cycle Logic
always @(posedge CLK100MHZ) begin

    

    waveforms[0] <= 2'b1;
    waveforms[1] <= 2'b1;
    waveforms[2] <= 2'b1;
    waveforms[3] <= 2'b11;
    waveforms[4] <= 2'b11;
    waveforms[5] <= 2'b11;
    waveforms[6] <= 2'b1;
    waveforms[7] <= 2'b11;
    

    tick_periods[0] <= 13'd1493; //Middle C
    tick_periods[1] <= 13'd1330; //D
    tick_periods[2] <= 13'd1185; //E
    tick_periods[3] <= 13'd1493;
    tick_periods[4] <= 13'd1330;
    tick_periods[5] <= 13'd1185;
    tick_periods[6] <= 13'd1000;
    tick_periods[7] <= 13'd1000;  

    if(btn_left)
        enable_mask[0] <= 1'b1;
    else
        enable_mask[0] <= 1'b0;

    if(btn_center) begin
        leds[15:0] <= 16'hFFFF;
        enable_mask[1] <= 1'b1;
    end else
        enable_mask[1] <= 1'b0;
        
    if(btn_right)
        enable_mask[2] <= 1'b1;
    else
        enable_mask[2] <= 1'b0;
        
    
    
    leds[15:0] <= 16'h9999;





end

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







endmodule
