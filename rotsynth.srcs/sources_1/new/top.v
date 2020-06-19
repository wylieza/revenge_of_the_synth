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
    input [10:1] JA,
    input [4:1] JB,
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
wire btna1;
wire btna2;
wire btna3;
wire btna4;
wire btna5;
wire btna6;
wire btna7;
wire btna8;
wire btna9;
wire btna10;
wire btnb1;
wire btnb2;

reg btnl_ls;
reg btnr_ls;
reg btnu_ls;
reg btnd_ls;


//Debounce module instantiation
debounced_button m_btn_left(CLK100MHZ, BTNL, btn_left);
debounced_button m_btn_right(CLK100MHZ, BTNR, btn_right);
debounced_button m_btn_up(CLK100MHZ, BTNU, btn_up);
debounced_button m_btn_down(CLK100MHZ, BTND, btn_down);
debounced_button m_btn_center(CLK100MHZ, BTNC, btn_center);

debounced_button m_btn_aone(CLK100MHZ, JA[1], btna1);
debounced_button m_btn_atwo(CLK100MHZ, JA[2], btna2);
debounced_button m_btn_athree(CLK100MHZ, JA[3], btna3);
debounced_button m_btn_afour(CLK100MHZ, JA[4], btna4);
debounced_button m_btn_aseven(CLK100MHZ, JA[7], btna7);
debounced_button m_btn_aeight(CLK100MHZ, JA[8], btna8);
debounced_button m_btn_anine(CLK100MHZ, JA[9], btna9);
debounced_button m_btn_aten(CLK100MHZ, JA[10], btna10);
debounced_button m_btn_bone(CLK100MHZ, JB[1], btnb1);
debounced_button m_btn_btwo(CLK100MHZ, JB[2], btnb2);
debounced_button m_btn_afive(CLK100MHZ, JB[3], btnb3);
debounced_button m_btn_asix(CLK100MHZ, JB[4], btnb4);


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
reg [12:0] tick_periods [11:0]; // ticT = 100e6/(freq*256)
reg [1:0] waveforms [11:0];
wire [10:0] sample_values [11:0]; // 00: Sine, 	01: Square, 	11: Sawtooth


//Function Generators
function_generator m_fg_0(CLK100MHZ, tick_periods[0], waveforms[0], sample_values[0]);
function_generator m_fg_1(CLK100MHZ, tick_periods[1], waveforms[1], sample_values[1]);
function_generator m_fg_2(CLK100MHZ, tick_periods[2], waveforms[2], sample_values[2]);
function_generator m_fg_3(CLK100MHZ, tick_periods[3], waveforms[3], sample_values[3]);
function_generator m_fg_4(CLK100MHZ, tick_periods[4], waveforms[4], sample_values[4]);
function_generator m_fg_5(CLK100MHZ, tick_periods[5], waveforms[5], sample_values[5]);
function_generator m_fg_6(CLK100MHZ, tick_periods[6], waveforms[6], sample_values[6]);
function_generator m_fg_7(CLK100MHZ, tick_periods[7], waveforms[7], sample_values[7]);
function_generator m_fg_8(CLK100MHZ, tick_periods[8], waveforms[8], sample_values[8]);
function_generator m_fg_9(CLK100MHZ, tick_periods[9], waveforms[9], sample_values[9]);
function_generator m_fg_10(CLK100MHZ, tick_periods[10], waveforms[10], sample_values[10]);
function_generator m_fg_11(CLK100MHZ, tick_periods[11], waveforms[11], sample_values[11]);


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Voice Mixer Setup
reg [11:0] enable_mask = 8'b0;
wire [10:0] mixed_audio_sv;

mixer m_mixer(sample_values[0], sample_values[1], sample_values[2], sample_values[3], sample_values[4], sample_values[5], sample_values[6], sample_values[7], sample_values[8], sample_values[9], sample_values[10], sample_values[11], enable_mask, mixed_audio_sv);

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
//Octave and Waveform Selection
reg [1:0] octave = 2'b1;
reg [1:0] waveform = 2'b0;


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//SSD Update

always @(*) begin
    ssd_left_value <= waveform;
    ssd_right_value <= octave;
end



//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Clock Cycle Logic
always @(posedge CLK100MHZ) begin

    waveforms[0] <= waveform;
    waveforms[1] <= waveform;
    waveforms[2] <= waveform;
    waveforms[3] <= waveform;
    waveforms[4] <= waveform;
    waveforms[5] <= waveform;
    waveforms[6] <= waveform;
    waveforms[7] <= waveform;
    waveforms[8] <= waveform;
    waveforms[9] <= waveform;
    waveforms[10] <= waveform;
    waveforms[11] <= waveform;

    tick_periods[0] <= (13'd791 >> octave) << 1;
    tick_periods[1] <= (13'd838 >> octave) << 1;
    tick_periods[2] <= (13'd888 >> octave) << 1;
    tick_periods[3] <= (13'd941 >> octave) << 1;
    tick_periods[4] <= (13'd996 >> octave) << 1;
    tick_periods[5] <= (13'd1056 >> octave) << 1;
    tick_periods[6] <= (13'd1119 >> octave) << 1;
    tick_periods[7] <= (13'd1185 >> octave) << 1;  
    tick_periods[8] <= (13'd1256 >> octave) << 1;  
    tick_periods[9] <= (13'd1330 >> octave) << 1;  
    tick_periods[10] <= (13'd1409 >> octave) << 1;  
    tick_periods[11] <= (13'd1493 >> octave) << 1;  


    if(btn_center) begin
        leds[15:0] <= 16'hFFFF;
        octave <= 2'b1;
        waveform <= 2'b0;        
    end else
        leds[15:0] <= 16'h9999;
        
    enable_mask[0] <= btna1;
    enable_mask[1] <= btna2;
    enable_mask[2] <= btna3;
    enable_mask[3] <= btna4;
    enable_mask[4] <= btna7;
    enable_mask[5] <= btna8;
    enable_mask[6] <= btna9;
    enable_mask[7] <= btna10;
    enable_mask[8] <= btnb1;
    enable_mask[9] <= btnb2;
    enable_mask[10] <= btnb3;
    enable_mask[11] <= btnb4;
    
    
    btnl_ls <= btn_left;
    btnr_ls <= btn_right;
    btnu_ls <= btn_up;
    btnd_ls <= btn_down;
    
    
    if(btn_up && ~btnu_ls) begin
        octave <= octave + 2'b1;
        if (octave == 2'd2)
            octave <= 2'b0;
    end          
    
    if(btn_down && ~btnd_ls) begin
        octave <= octave - 2'b1;
        if (octave == 2'd0)
            octave <= 2'd2;
    end
        
    if(btn_left && ~btnl_ls) begin
        waveform <= waveform - 2'b1;
        if (waveform == 2'd3)
            waveform <= 2'd1;
    end
        
    if(btn_right && ~btnr_ls) begin
        waveform <= waveform + 2'b1;
        if (waveform == 2'd1)
            waveform <= 2'd3;
    end
        
      
    
    
    





end

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







endmodule
