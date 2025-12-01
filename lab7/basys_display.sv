module basys_display (
    input  logic        clk,
    input  logic        reset,
    input  logic        en,
    input  logic [15:0] sev_seg_disp,
    input  logic [15:0] led,

    input  logic        raw_data_display_select, // switch 0 to select between raw hex adc data and scaled averaged bcd data
    input  logic [1:0]  ADC_select, // switches 15, 14 select between internal IP ADC, the PWM ADC, and the R2R ADC
    input  logic        adc_method_select,

    output logic        CA, CB, CC, CD, CE, CF, CG, DP, // segment outputs (active-low)
    output logic        AN1, AN2, AN3, AN4, // anode outputs for digit selection (active-low)
    output logic [15:0] led_out
);

    // internal
    logic [3:0] decimal_pt;

    assign decimal_pt = {~raw_data_display_select, 3'b0};

    // Seven Segment Display Subsystem
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk(clk), 
        .reset(reset),
        .en(en),
        .sec_dig1(sev_seg_disp[3:0]),     // Lowest digit
        .sec_dig2(sev_seg_disp[7:4]),     // Second digit
        .min_dig1(sev_seg_disp[11:8]),    // Third digit
        .min_dig2(sev_seg_disp[15:12]),   // Highest digit
        .decimal_point(decimal_pt),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), 
        .CE(CE), .CF(CF), .CG(CG), .DP(DP), 
        .AN1(AN1), .AN2(AN2), .AN3(AN3), .AN4(AN4)
    );

    assign led_out = led;
    
endmodule