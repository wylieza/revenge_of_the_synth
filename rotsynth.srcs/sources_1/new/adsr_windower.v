/**************************************************************************************
------ Module Description -----
Name            > adsr_windower.v
Author          > Callum Tilbury

Description     > Apply an ASDR envelope to a pressed note

Usage:
 Accepts        > 
                > 
 Returns        > 1 x 11-bit signal with envelope applied

Clocking & Reset:
 Requires Clock > Yes
 Reset Bit      > No
 Enable Bit     > No ...
**************************************************************************************/

// NOTE: NOT WORKING WITH ENABLE LINE YET

module adsr_windower (
    input CLK100MHz,
    
    input button_state,
    input [10:0] signal_in,

    // ADSR parameters
    input [18:0] A,
    input [18:0] D,
    input [10:0] S,
    input [18:0] R,

    output [10:0] signal_out
);

    // Setup wavefrom identifier constants
    parameter [1:0] SECTION_A = 0;
    parameter [1:0] SECTION_D = 1;
    parameter [1:0] SECTION_S = 2;
    parameter [1:0] SECTION_R = 3;

    reg [1:0] curr_section;

    reg [18:0] attack_counter = 0;
    reg [18:0] decay_counter = 0;
    reg [18:0] release_counter = 0;

    reg fully_released = 1;

    reg [10:0] scaler = 1024;
    
    always @ (posedge button_state) begin
        curr_section <= SECTION_A;
        fully_released <= 0;
    end

    always @ (negedge button_state) begin
        curr_section <= SECTION_R;
    end

    always @ (posedge CLK100MHz) begin
        
        if (!fully_released) begin

            // ATTACK section
            if (curr_section == SECTION_A) begin
                attack_counter <= attack_counter + 1;
                if (attack_counter >= (A-1)) begin
                    scaler <= scaler + 1;
                    attack_counter <= 0;
                    if (scaler == 2046) begin
                        curr_section <= SECTION_D;
                    end
                end
            end

            // DECAY section
            else if (curr_section == SECTION_D) begin
                decay_counter <= decay_counter + 1;
                if (decay_counter >= (D-1)) begin
                    decay_counter <= 0;
                    scaler <= scaler - 1;
                    if (scaler == S) begin
                        curr_section <= SECTION_S;
                    end
                end
            end

            // SUSTAIN section
            else if (curr_section == SECTION_S) begin
                // Nothing to do here
            end

            // RELEASE section
            else if (curr_section == SECTION_R) begin
                release_counter <= release_counter + 1;
                if (release_counter >= (R-1)) begin
                    release_counter <= 0;
                    scaler <= scaler - 1;
                    if (scaler == 1025) begin
                        fully_released <= 1;
                    end
                end
                
            end
        end
    end
    
    wire [21:0] scaled_internal = (signal_in >= 1024 ? ((signal_in * scaler) >> 11)
        : (1024 - ((2048 - signal_in) * scaler) >> 11));

    assign signal_out = scaled_internal[10:0];


endmodule
