module top_sim();

reg CLK100MHZ = 1;
reg [15:0] SW;
reg BTNC = 0;
reg BTNU = 0;
reg BTNL = 0;
reg BTNR = 0;
reg BTND = 0;
wire AUD_PWM; 
wire AUD_SD;
wire [15:0] LED;
wire CA;
wire CB;
wire CC;
wire CD;
wire CE;
wire CF;
wire CG;
wire DP;
wire [7:0] AN;

top top_uut(
    CLK100MHZ,
    SW,
    BTNC,
    BTNU,
    BTNL,
    BTNR,
    BTND,
    AUD_PWM, 
    AUD_SD,
    LED,
    CA,
    CB,
    CC,
    CD,
    CE,
    CF,
    CG,
    DP,
    AN);
    
integer i;

wire reset;
assign reset = top_uut.reset;

wire [7:0] an_probe;
assign an_probe = top_uut.AN;

wire [7:0] ssunits_disable_probe;
assign ssunits_disable_probe = top_uut.ssunits_disable;

wire [3:0] BCD0_probe;
assign BCD0_probe = top_uut.m_ssdriver.BCD0;

initial begin
    for (i = 0; i < 100; i = i +1) begin
        #1 CLK100MHZ = ~CLK100MHZ;    
    end


end








endmodule