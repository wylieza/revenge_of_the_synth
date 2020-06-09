//Code Origin Notice//
//This code was originally provided by the EEE4020 course and has been modified/extended for use here in this project

module ssdriver(
    input clk, reset,
    input [3:0] BCD7, BCD6, BCD5, BCD4, BCD3, BCD2, BCD1, BCD0, //Decimal to display on each ssd unit
    output reg [7:0] ssunits_disable = 8'hFE, //ssd units disable bits (active low)
    output reg [7:0] segments_disable = 8'b0 //ssd segments disable bits (active low)
);


//decode decimal values into segment disable bits for each unit
wire [6:0]SS[7:0]; //array called SS of size 8, each element in this array is 7 bits wide 
bcd_decoder decoder0 (BCD0, SS[0]);
bcd_decoder decoder1 (BCD1, SS[1]);
bcd_decoder decoder2 (BCD2, SS[2]);
bcd_decoder decoder3 (BCD3, SS[3]);
bcd_decoder decoder4 (BCD4, SS[4]);
bcd_decoder decoder5 (BCD5, SS[5]);
bcd_decoder decoder6 (BCD6, SS[6]);
bcd_decoder decoder7 (BCD7, SS[7]);


//reduce 100 MHz clock to 1525.9 Hz -> rate at which units are switched between
reg [15:0]Count;
//reg [1:0]Count;

// Scroll through the digits, switching one on at a time
always @(posedge clk) begin
    Count <= Count + 1'b1;
    if (reset) ssunits_disable <= 8'hFE; //Disable all but first ss unit
    else if(&Count) ssunits_disable <= {ssunits_disable[6:0], ssunits_disable[7]}; //enable the next ss unit, disabling the previous
end

//------------------------------------------------------------------------------
always @(*) begin
    segments_disable[7] <= 1'b1; //disables the decimal point
    if (reset) begin
        segments_disable[6:0] <= 7'h7F; //under reset, disable all segments
    end else begin
        case(~ssunits_disable) //depending on which ss unit is currently enabled, enable the appropriate segments
            8'd1 : segments_disable[6:0] <= ~SS[0];
            8'd2 : segments_disable[6:0] <= ~SS[1];
            8'd4 : segments_disable[6:0] <= ~SS[2];
            8'd8 : segments_disable[6:0] <= ~SS[3];
            8'd16 : segments_disable[6:0] <= ~SS[4];
            8'd32 : segments_disable[6:0] <= ~SS[5];
            8'd64 : segments_disable[6:0] <= ~SS[6];
            8'd128 : segments_disable[6:0] <= ~SS[7];
            default: segments_disable[6:0] <= 7'h7F; //if bit corruption occurs, disable all segments
        endcase
    end
end

endmodule