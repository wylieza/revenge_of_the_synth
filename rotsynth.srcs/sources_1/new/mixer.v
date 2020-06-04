/**************************************************************************************
------ Module Description -----
Name            > Mixer.v
Author          > Callum Tilbury

Description     > Uniformly mix a bus of 8 input signals into a single output

Usage:
 Accepts        > 8 x 11-bit signals
                > 1 x  8-bit enable bitmask
 Returns        > 1 x 11-bit mixed signal

Clocking & Reset:
 Requires Clock > No
 Reset Bit      > No
 Enable Bit     > No ... (enable bitmask — see above)
**************************************************************************************/

module mixer(
    // Signal Inputs
    // TODO: Would it be better to do this:
    //          input [10:0] signals [0:7]  ?
    //  Then, when inputting to the module, you can just concatenate 
    //     the input signals: mixer({signal_a, signal_b, ...})?
    input [10:0] signal_a,
    input [10:0] signal_b,
    input [10:0] signal_c,
    input [10:0] signal_d,
    input [10:0] signal_e,
    input [10:0] signal_f,
    input [10:0] signal_g,
    input [10:0] signal_h,
    // Enabled bitmask input
    input [7:0] enabled,
    // Outputs
    output [10:0] signal_mixed
);

    // TODO: Is there a more efficient way of doing this using logic instead of multiplication?
    wire [13:0] signal_mixed_prescale =
        enabled[0] * signal_a + 
        enabled[1] * signal_b + 
        enabled[2] * signal_c + 
        enabled[3] * signal_d + 
        enabled[4] * signal_e + 
        enabled[5] * signal_f + 
        enabled[6] * signal_g + 
        enabled[7] * signal_h;

    // Normalize the mixed signal back to 11 bits
    assign signal_mixed = (signal_mixed_prescale >> 3);

endmodule