/**************************************************************************************
------ Module Description -----
Author > Justin Wylie

Description > Convert an integer value to bcd format

Usage:
Accepts > 14 bit number with value < 9999
Returns > Four 4 bit numbers corresponding to the 4 bcd digits of the inputted number

Clocking & Reset:
Requires Clock > Yes
Reset Bit > No
Enable Bit > No

**************************************************************************************/

module decimal_to_bcd(
    input clk,
    input [13:0] decimal_value,
    output reg [3:0] digit3, digit2, digit1, digit0
    );
    
reg [13:0] decimal_value_reg;


always @(posedge clk) begin
    decimal_value_reg = decimal_value;

    //Bring number into range
    if(decimal_value_reg > 9999)
        decimal_value_reg = decimal_value_reg - 10000;
    
    //Determine digit 3
    if (decimal_value_reg >= 9000) begin
        digit3 = 4'd9;
        decimal_value_reg = decimal_value_reg - 9000;
    end else if (decimal_value_reg >= 8000) begin
        digit3 = 4'd8;
        decimal_value_reg = decimal_value_reg - 8000;
    end else if (decimal_value_reg >= 7000) begin
        digit3 = 4'd7;
        decimal_value_reg = decimal_value_reg - 7000;
    end else if (decimal_value_reg >= 6000) begin
        digit3 = 4'd6;
        decimal_value_reg = decimal_value_reg - 6000;
    end else if (decimal_value_reg >= 5000) begin
        digit3 = 4'd5;
        decimal_value_reg = decimal_value_reg - 5000;
    end else if (decimal_value_reg >= 4000) begin
        digit3 = 4'd4;
        decimal_value_reg = decimal_value_reg - 4000;
    end else if (decimal_value_reg >= 3000) begin
        digit3 = 4'd3;
        decimal_value_reg = decimal_value_reg - 3000;
    end else if (decimal_value_reg >= 2000) begin
        digit3 = 4'd2;
        decimal_value_reg = decimal_value_reg - 2000;
    end else if (decimal_value_reg >= 1000) begin
        digit3 = 4'd1;
        decimal_value_reg = decimal_value_reg - 1000;
    end else
        digit3 = 4'd0;
    
    
    //Determine digit 2
    if (decimal_value_reg >= 900) begin
        digit2 = 4'd9;
        decimal_value_reg = decimal_value_reg - 900;
    end else if (decimal_value_reg >= 800) begin
        digit2 = 4'd8;
        decimal_value_reg = decimal_value_reg - 800;
    end else if (decimal_value_reg >= 700) begin
        digit2 = 4'd7;
        decimal_value_reg = decimal_value_reg - 700;
    end else if (decimal_value_reg >= 600) begin
        digit2 = 4'd6;
        decimal_value_reg = decimal_value_reg - 600;
    end else if (decimal_value_reg >= 500) begin
        digit2 = 4'd5;
        decimal_value_reg = decimal_value_reg - 500;
    end else if (decimal_value_reg >= 400) begin
        digit2 = 4'd4;
        decimal_value_reg = decimal_value_reg - 400;
    end else if (decimal_value_reg >= 300) begin
        digit2 = 4'd3;
        decimal_value_reg = decimal_value_reg - 300;
    end else if (decimal_value_reg >= 200) begin
        digit2 = 4'd2;
        decimal_value_reg = decimal_value_reg - 200;
    end else if (decimal_value_reg >= 100) begin
        digit2 = 4'd1;
        decimal_value_reg = decimal_value_reg - 100;
    end else
        digit2 = 4'd0;
    
    //Determine digit 2
    if (decimal_value_reg >= 90) begin
        digit1 = 4'd9;
        decimal_value_reg = decimal_value_reg - 90;
    end else if (decimal_value_reg >= 80) begin
        digit1 = 4'd8;
        decimal_value_reg = decimal_value_reg - 80;
    end else if (decimal_value_reg >= 70) begin
        digit1 = 4'd7;
        decimal_value_reg = decimal_value_reg - 70;
    end else if (decimal_value_reg >= 60) begin
        digit1 = 4'd6;
        decimal_value_reg = decimal_value_reg - 60;
    end else if (decimal_value_reg >= 50) begin
        digit1 = 4'd5;
        decimal_value_reg = decimal_value_reg - 50;
    end else if (decimal_value_reg >= 40) begin
        digit1 = 4'd4;
        decimal_value_reg = decimal_value_reg - 40;
    end else if (decimal_value_reg >= 30) begin
        digit1 = 4'd3;
        decimal_value_reg = decimal_value_reg - 30;
    end else if (decimal_value_reg >= 20) begin
        digit1 = 4'd2;
        decimal_value_reg = decimal_value_reg - 20;
    end else if (decimal_value_reg >= 10) begin
        digit1 = 4'd1;
        decimal_value_reg = decimal_value_reg - 10;
    end else
        digit1 = 4'd0;
    
    digit0 = decimal_value_reg;       
        
end    
    
endmodule
