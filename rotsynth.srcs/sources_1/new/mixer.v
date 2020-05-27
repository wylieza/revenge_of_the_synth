/*
    Mixer module
    EEE4120F: YODA Project

    Written by:     Callum Tilbury
    Last updated:   21-May-2020

    ---

    Inputs:     8 x 11-bit signals
    Outputs:    1 x 11-bit signal

    ---

*/

module mixer(
    // Inputs
    input [10:0] signal_a,
    input [10:0] signal_b,
    input [10:0] signal_c,
    input [10:0] signal_d,
    input [10:0] signal_e,
    input [10:0] signal_f,
    input [10:0] signal_g,
    input [10:0] signal_h,
    input [7:0] enabled,
    // Outputs
    output [10:0] signal_mixed
);

    wire [13:0] signal_mixed_prescale =
        enabled[0] * signal_a + 
        enabled[1] * signal_b + 
        enabled[2] * signal_c + 
        enabled[3] * signal_d + 
        enabled[4] * signal_e + 
        enabled[5] * signal_f + 
        enabled[6] * signal_g + 
        enabled[7] * signal_h;

    assign signal_mixed = (signal_mixed_prescale >> 3);

endmodule