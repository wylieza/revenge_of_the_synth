/******************************
------ Module Description -----

Author > Nicolas Reid

Description > Accepts tickPeriod and waveform definition, uses index_generator and sample_generator modules to find sample value

Usage:
Accepts > Tick Period: between 19531 and 93 --- A0 to C8 ((ticT = 100E6/(freq*256)) [15-bit]
		> Waveform definition: square/sine/triangle
Returns > Sample Value: [11-bit]

Clocking & Reset:
Requires Clock > Yes
Reset Bit > No
Enable Bit > Yes

******************************/

// Testbenching: https://www.edaplayground.com/x/59LN

module function_generator(
  input clk,
  input [12:0] ticT,				// Tick period
  input [1:0] waveform,				// 00: Sine, 	01: Square, 	11: Sawtooth
  output [10:0] sampVal
);
  
  wire [7:0] phIndex;
  
  index_generator inGen(
    clk,
    ticT,
    phIndex
  );
  
  sample_generator sapGen(
    clk,
    phIndex,
    waveform,
    sampVal
  );
  
endmodule
