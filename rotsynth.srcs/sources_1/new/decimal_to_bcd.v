/**************************************************************************************
------ Module Description -----
Author > Justin Wylie

Description > Convert an integer value to bcd format

Usage:
Accepts > 14 bit number with value < 9999
Returns > Four 4 bit numbers corresponding to the 4 bcd digits of the inputted number

Clocking & Reset:
Requires Clock > No
Reset Bit > No
Enable Bit > No

**************************************************************************************/

module decimal_to_bcd(
    input [13:0] decimal_value,
    output reg [3:0] digit3, digit2, digit1, digit0
    );
    
reg [13:0] value_under_e4;
reg [9:0] value_under_e3;
reg [6:0] value_under_e2;
reg [3:0] value_under_e1;

always @(*) begin
    if(decimal_value > 9999)
        value_under_e4 <= decimal_value - 10000;
        
    if(decimal_value[9:0] > 999)
        value_under_e3 <= decimal_value[9:0] - 1000;
    else
        value_under_e3 <= decimal_value[9:0];
        
    if(decimal_value[6:0] > 99)
        value_under_e2 <= decimal_value[6:0] - 100;
    else
        value_under_e2 <= decimal_value[6:0];
        
    if(decimal_value[3:0] > 9)
        value_under_e1 <= decimal_value[3:0] - 10;
    else
        value_under_e1 <= decimal_value[3:0];

end
    

    
always @(*) begin
    digit0 <= value_under_e1;
    digit1 <= (value_under_e2-value_under_e1)-9;

end
    
    
    
endmodule
