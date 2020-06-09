/**************************************************************************************
------ Module Description -----
Author > Justin Wylie

Description > Debouncing of a button

Usage:
Accepts > Button to debounce
Returns > The state of the button after debouncing

Clocking & Reset:
Requires Clock > Yes
Reset Bit > No
Enable Bit > No

**************************************************************************************/

module debounced_button(
    input clk, 
    input button,
    output reg debounced_state = 1'b0
);

reg [21:0] count; //assume count is null on FPGA configuration

//--------------------------------------------
always @(posedge clk) begin 
    if(debounced_state & !button)
        begin
        
        count <= count + 1'b1;
        
        if(&count)
            begin            
            debounced_state <= 1'b0;
            count <= 22'b0;            
        end   
        
    end else if(button)
    begin
        debounced_state <= 1'b1;        
    end
    
end 


endmodule


