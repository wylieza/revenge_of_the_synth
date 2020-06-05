/******************************
------ Module Description -----

Author > Nicolas Reid

Description > Outputs a sample value for a given phase index and waveform definition

Usage:
Accepts > Phase index: used to access current sample value in memory (0-255) [8-bit]
		> Waveform definition: square/sine/triangle
Returns > Sample Value: [11-bit]

Clocking & Reset:
Requires Clock > Yes
Reset Bit > No
Enable Bit > Yes

******************************/

module sample_generator(
  input clk,
  input [7:0] phIndex,
  input [1:0] waveform,		// 00: Sine, 	01: Square, 	10: Triangle
  output reg [10:0] sampVal
);
  
  reg [10:0] sineSamp = 0;		// Instantiate sine sample value variable
  
  //Create module of the fullsine_256
  fullsine_256 fs_samples(
    clk,
    phIndex,
    sineSamp							// Return sample value for sine waveform
  );	
 
  always @(phIndex, waveform) begin
    
    if(!waveform) begin      
      sampVal <= sineSamp;				// Set sinewave sample value
    end 
    else if(waveform == 2'b01) begin
      if(phIndex < 8'd128) begin		// Set square wave sample value
        sampVal <= 11'd2047;	
      end 
      else begin
        sampVal <= 11'd0;
      end    
    end
    else if(waveform == 2'b10) begin
      sampVal <= (phIndex<<2) + 1024;	// Set triangle ramp value (propto phase index)
    end else begin
      sampVal <= 1024;					// Default
    
  end
  
endmodule
