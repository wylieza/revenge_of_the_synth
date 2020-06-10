/******************************
------ Module Description -----

Author > Nicolas Reid

Description > Increments the phase index each time the clock signal counts up to the tick period

Usage:
Accepts > Tick Period: between 19531 and 93 - A0 to C8 ((ticT = 100E6/(freq*256)) [15-bit]
Returns > Phase index: used to access current sample value in memory (0-255) [8-bit]

Clocking & Reset:
Requires Clock > Yes
Reset Bit > No
Enable Bit > No

******************************/

// Testbenching: https://www.edaplayground.com/x/3E_y

module index_generator(
  input clk,
  input [12:0] ticT,				// Tick period
  output [7:0] phIndex				// Phase index
);
  
  reg [12:0] ticCount = 0;			// Counter to keep track of clock ticks
  reg [7:0] phIndex = 0;			// Initialise phase idex to 0
  
  
  always @(posedge clk) begin   
    
    ticCount <= ticCount + 1;		// Increment tick counter
    
    if (ticCount >= ticT) begin		// Check if cap has been reached
        phIndex <= phIndex + 1;		// The next sample value is needed -> increment phase index 
        ticCount <= 1;				// Reset tick counter
    end

  end
  
endmodule
