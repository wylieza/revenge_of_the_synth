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
Enable Bit > No

******************************/

// Testbenching: https://www.edaplayground.com/x/vqu

module sample_generator(
  input clk,
  input [7:0] phIndex,
  input [1:0] waveform,		// 00: Sine, 01: Square, 11: Sawtooth, 01: Triangle
  output reg [10:0] sampVal
);
  
  // Setup wavefrom identifier constants
  parameter [1:0] SINE = 2'b00;
  parameter [1:0] SQUARE = 2'b01;
  parameter [1:0] TRIANGLE = 2'b10;
  parameter [1:0] SAW = 2'b11;
  
  wire [10:0] sineSamp;		// Instantiate sine sample value variable
  
  // Create module of the fullsine_256
  fullsine_256 fs_samples(
    clk,
    phIndex,
    sineSamp							// Return sample value for sine waveform
  );
    
  always @(*) begin
    
    //------------------------
    // SINE
    //------------------------
    if(waveform == SINE) begin      
      sampVal <= sineSamp;				// Set sinewave sample value
    end 

    //------------------------
    // SQUARE
    //------------------------
    else if(waveform == SQUARE) begin
      if(phIndex < 8'd128) begin		// Set square wave sample value
        sampVal <= 11'd2047;	
      end 
      else begin
        sampVal <= 11'd0;
      end    
    end

    //------------------------
    // SAWTOOTH
    //------------------------
    else if(waveform == SAW) begin
      sampVal <= (phIndex<<3);	// Set sawtooth value (propto phase index)
    end

    //------------------------
    // TRIANGLE
    //------------------------
    else if(waveform == TRIANGLE) begin
      if(phIndex < 8'd128) begin		// First half
        sampVal <= (phIndex<<4);
      end 
      else begin
        sampVal <= 2047-(phIndex<<4);
      end  
    end

    //------------------------
    // OTHER? (Just in case)
    //------------------------
    else begin
      sampVal <= 1024;    // Set output to "0"
    end
    
  end
  
endmodule
