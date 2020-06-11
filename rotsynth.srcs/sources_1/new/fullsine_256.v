/**************************************************************************************
------ Module Description -----
Author > Justin Wylie

Description > Access the samples in a 64 sample quater sine memory block and abstracts
to a 256 sample fullsine memory unit

Usage:
Accepts > Sample number 0-255
Returns > The value of the sample

Clocking & Reset:
Requires Clock > Yes
Reset Bit > No
Enable Bit > No

**************************************************************************************/

module fullsine_256(
    input CLK100MHZ,
    input [7:0] sample_num,
    output reg [10:0] value
    );
    
    // Memory IO
    reg ena = 1;
    reg wea = 0;
    reg [5:0] addra = 0;
    reg [10:0] dina = 0; //We're not putting data in, so we can leave this unassigned
    wire [10:0] douta;   
    
    //Quart sine memory block
    quartsine_mem qs_mem(
        CLK100MHZ,
        ena,
        wea,
        addra,
        dina,
        douta
    );
    
    reg reverse;
    reg invert;
    reg [5:0] address = 0;
    
    always @(posedge CLK100MHZ) begin
    
        //Determine the states of 'reverse' and 'invert' flags
        if (&sample_num[7:6] && |sample_num[5:0]) begin
            //Code here to deal with 193-255 (63 samples)
            //Fourth Quart (1:63)
            reverse = 1;
            invert = 1;
            address = sample_num[5:0] - 1;
        
        
        end else if (&sample_num[7:6]) begin
            //Code here to deal with 192 (1 sample)
            //Third Quart (64)
            reverse = 0;
            invert = 1;
            address = 6'b111111;
        
        end else if (&sample_num[7:7] && |sample_num[5:0]) begin
            //Code here to deal with 129-191 (63 samples)
            //Third Quart (2:64)
            reverse = 0;
            invert = 1;
            address = sample_num[5:0];
        
        end else if (|sample_num[7:6] && |sample_num[5:0]) begin
            //Code here to deal with 65-128 (64 samples)
            //Second Quart (1:64)
            reverse = ~(sample_num == 65 || sample_num == 128);
            invert = ~sample_num[6];

            if(sample_num == 65)
                address = sample_num[5:0] - 2;            
            else
                address = sample_num[5:0] - 1;

        end else begin
            //Code here to deal with 0-64 (65 samples)
            //First Quart (1:64) + First Quart (64)
            reverse = 0;
            invert = 0;
            
            if(sample_num[6])
                address = 6'b111111;
            else
                address = sample_num[5:0];       
        end

        //Perforom reverse addressing if required
        if (reverse)
            addra = 6'd63 - address;
        else
            addra = address;   
            
    end
    
    //Updating of 'value' must only happen when the memory module returns a result
    always @(douta) begin
        //Invert [around 1024] if required
        if(invert)
            value <= 11'd2047 - douta;
        else
            value <= douta;
    end    

endmodule
