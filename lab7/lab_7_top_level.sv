module lab_7_top_level (
    input  logic        clk,
    input  logic        reset, // center button
    
    input  logic        raw_data_display_select, // switch 0 to select between raw hex adc data and scaled averaged bcd data
    input  logic [1:0]  ADC_select, // select between internal IP ADC, the PWM ADC, and the R2R ADC
    input  logic        adc_method_select,
    
    input               vauxp15, // Analog input (positive) - connect to JXAC4:N2 PMOD pin  (XADC4)
    input               vauxn15, // Analog input (negative) - connect to JXAC10:N1 PMOD pin (XADC4)
    input  logic        pwm_adc_comp, // output of comparitor connected to pwm
    input  logic        r2r_adc_comp, // output of comparitor connected to r2r ladde
    
    output logic        CA, CB, CC, CD, CE, CF, CG, DP,
    output logic        AN1, AN2, AN3, AN4,
    output logic [15:0] led,
    
    output logic        pwm_out,
    output logic [7:0]  R2R_out
);
    // internal signals
    logic [7:0] r2r_out_sweep, r2r_out_sar;
    logic       r2r_adc_sweep_ready, r2r_adc_sar_ready; 
    logic [7:0] r2r_adc_sweep_raw_data, r2r_adc_sar_raw_data;
    
    logic [7:0] pwm_out_sweep, pwm_out_sar;
    logic       pwm_adc_sweep_ready, pwm_adc_sar_ready; 
    logic [7:0] pwm_adc_sweep_raw_data, pwm_adc_sar_raw_data;

    logic [15:0] adc_raw_data; logic [11:0] xadc_raw_data; logic [15:0] pwm_adc_raw_data; logic [7:0] r2r_adc_raw_data;
    logic [15:0] adc_ave_data,              xadc_ave_data,              pwm_adc_ave_data,             r2r_adc_ave_data;
    logic [15:0] adc_scaled_ave_data,       xadc_scaled_ave_data,       pwm_adc_scaled_ave_data,      r2r_adc_scaled_ave_data;
    logic        adc_ready,                 XADC_ready,                 pwm_adc_ready,                r2r_adc_ready;
    logic [15:0] bcd_adc_scaled_ave_data;
    logic xadc_enable;

    logic [15:0] xadc_scalar, pwm_adc_scalar, r2r_adc_scalar;
    logic [4:0]  xadc_shift,  pwm_adc_shift,  r2r_adc_shift;

    logic [15:0] sev_seg_disp;

    // Constants
    localparam CHANNEL_ADDR = 7'h1f;     // XA4/AD15 (for XADC4)

    xadc_wiz_0 XADC_INST (
            .di_in(16'h0000),        // Not used for reading
            .daddr_in(CHANNEL_ADDR), // Channel address
            .den_in(xadc_enable),         // Enable signal
            .dwe_in(1'b0),           // Not writing, so set to 0
            .drdy_out(XADC_ready),        // Data ready signal (when high, ADC data is valid)
            .do_out(xadc_raw_data),           // ADC data output
            .dclk_in(clk),           // Use system clock
            .reset_in(reset),   // Active-high reset
            .vp_in(1'b0),            // Not used, leave disconnected
            .vn_in(1'b0),            // Not used, leave disconnected
            .vauxp15(vauxp15),       // Auxiliary analog input (positive)
            .vauxn15(vauxn15),       // Auxiliary analog input (negative)
            .channel_out(),          // Current channel being converted
            .eoc_out(xadc_enable),        // End of conversion
            .alarm_out(),            // Not used
            .eos_out(),       // End of sequence
            .busy_out()      // XADC busy signal
    );

    // Performs an ADC sweep using the R2R ladder to produce an analog output
    r2r_adc_sweep r2r_adc_sweep_inst (
        .clk(clk),
        .reset(reset),
        .comp_result(r2r_adc_comp),
        .compare_neg_r2r(r2r_out_sweep),
        .drdy_out(r2r_adc_sweep_ready),
        .data_out(r2r_adc_sweep_raw_data)
    );

    // Performs a sweep based ADC using the R2R ladder to produce an analog output using sucessive approximation
    r2r_adc_sar r2r_adc_sar_inst (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .comp_result(r2r_adc_comp),
        .compare_neg_r2r(r2r_out_sar),
        .drdy_out(r2r_adc_sar_ready),
        .data_out(r2r_adc_sar_raw_data)
    );

    // Selects between the two ADC methods: the sweep based or the SAR based
    muxS_W #(.S(1), .W(8)) r2r_adc_method_r2r_out_mux(
        .in({r2r_out_sweep, r2r_out_sar}),
        .select(adc_method_select),
        .mux_out(R2R_out)
    );

    // Extension of the method select mux; maps data for when the ADC outputs are ready
    muxS_W #(.S(1), .W(1)) r2r_adc_method_ready_mux(
        .in({r2r_adc_sweep_ready, r2r_adc_sar_ready}),
        .select(adc_method_select),
        .mux_out(r2r_adc_ready)
    );

    // Extension of the method select to output the raw data
    muxS_W #(.S(1), .W(8)) r2r_adc_method_raw_data_mux(
        .in({r2r_adc_sweep_raw_data, r2r_adc_sar_raw_data}),
        .select(adc_method_select),
        .mux_out(r2r_adc_raw_data)
    );

    // Perform ADC sweep and output data
    pwm_adc_sweep pwm_adc_sweep_inst (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .comp_result(pwm_adc_comp),
        .compare_neg_pwm(pwm_out_sweep),
        .drdy_out(pwm_adc_sweep_ready),
        .data_out(pwm_adc_sweep_raw_data)
    );

    // 
    pwm_adc_sar pwm_adc_sar_inst (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .comp_result(pwm_adc_comp),
        .compare_neg_pwm(pwm_out_sar),
        .drdy_out(pwm_adc_sar_ready),
        .data_out(pwm_adc_sar_raw_data)
    );

    // 
    muxS_W #(.S(1), .W(1)) pwm_adc_method_pwm_out_mux(
        .in({pwm_out_sweep, pwm_out_sar}),
        .select(adc_method_select),
        .mux_out(pwm_out)
    );

    // Maps the ready signal from when the 
    muxS_W #(.S(1), .W(1)) pwm_adc_method_ready_mux(
        .in({pwm_adc_sweep_ready, pwm_adc_sar_ready}),
        .select(adc_method_select),
        .mux_out(pwm_adc_ready)
    );

    // Select between the normal sweep and the SAR approximation
    muxS_W #(.S(1), .W(8)) pwm_adc_method_raw_data_mux(
        .in({pwm_adc_sweep_raw_data, pwm_adc_sar_raw_data}),
        .select(adc_method_select),
        .mux_out(pwm_adc_raw_data)
    );

    // Select the ready singla as desired
    muxS_W #(.S(2), .W(1)) adc_ready_mux(
        .in({r2r_adc_ready, r2r_adc_ready, pwm_adc_ready, XADC_ready}),
        .select(ADC_select),
        .mux_out(adc_ready)
    );

    // Select the ADC data stream for processing
    muxS_W #(.S(2), .W(16)) adc_raw_data_mux(
        // padding with zeros to make raw data MSBs of input to averager
        .in({{r2r_adc_raw_data,8'b0}, {r2r_adc_raw_data, 8'b0}, {pwm_adc_raw_data, 8'b0}, {xadc_raw_data, 4'b0}}),
        .select(ADC_select),
        .mux_out(adc_raw_data)
    );

    // Averager for processing the ADC outut data
    adc_averager #(.power(8)) general_adc_averager(
        .clk(clk),
        .reset(reset),
        .ready(adc_ready),
        .adc_data(adc_raw_data),
        .ave_adc_data(adc_ave_data)
    );

    // Select the data stream to output the averaged data on; maps input data to some part of the output bus
    demuxS_W #(.S(2), .W(16)) adc_ave_demux(
        .in(adc_ave_data),
        .select(ADC_select),
        .mux_out({r2r_adc_ave_data, r2r_adc_ave_data, pwm_adc_ave_data, xadc_ave_data})
    );

    // Performs scaling on the XADC raw averaged data to convert to human comprehendable form
    scalar #(
        .IN_WIDTH(16), 
        .SCALAR_WIDTH(16), 
        .SHIFT_WIDTH(5)) 
    xadc_scalar_mod(
        .clk(clk),
        .reset(reset),
        .data_in(xadc_ave_data),
        .scalar(xadc_scalar),
        .shift(xadc_shift),
        .data_out(xadc_scaled_ave_data)
    );

    // Performs scaling on the raw averaged PWM ADC data to convert to human readable form
    scalar #(
        .IN_WIDTH(16), 
        .SCALAR_WIDTH(16), 
        .SHIFT_WIDTH(5)) 
    pwm_adc_scalar_mod(
        .clk(clk),
        .reset(reset),
        .data_in(pwm_adc_ave_data),
        .scalar(pwm_adc_scalar),
        .shift(pwm_adc_shift),
        .data_out(pwm_adc_scaled_ave_data)
    );

    // Performs scaling on the raw averaged R2R ADC data to convert to human readable form
    scalar #(
        .IN_WIDTH(16), 
        .SCALAR_WIDTH(16), 
        .SHIFT_WIDTH(5)) 
    r2r_adc_scalar_mod(
        .clk(clk),
        .reset(reset),
        .data_in(r2r_adc_ave_data),
        .scalar(r2r_adc_scalar),
        .shift(r2r_adc_shift),
        .data_out(r2r_adc_scaled_ave_data)
    );

    // Select the desired output from the bus of scaled averaged ADC outputs
    muxS_W #(.S(2), .W(16)) scaled_ave_data_mux(
        .in({r2r_adc_scaled_ave_data, r2r_adc_scaled_ave_data, pwm_adc_scaled_ave_data, xadc_scaled_ave_data}),
        .select(ADC_select),
        .mux_out(adc_scaled_ave_data)
    );

    bin_to_bcd bin_to_bcd_inst(
        .clk(clk),
        .reset(reset),
        .bin_in(adc_scaled_ave_data),
        .bcd_out(bcd_adc_scaled_ave_data)
    );

    // Select raw or scaled average ADC data
    muxS_W #(.S(1), .W(16)) raw_or_cooked_data_selector(
        .in({adc_ave_data, bcd_adc_scaled_ave_data}),
        .select(raw_data_display_select),
        .mux_out(sev_seg_disp)
    );

    // Seven Segment Display Subsystem
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk(clk), 
        .reset(reset),
        .en(1'b1),
        .sec_dig1(sev_seg_disp[3:0]),     // Lowest digit
        .sec_dig2(sev_seg_disp[7:4]),     // Second digit
        .min_dig1(sev_seg_disp[11:8]),    // Third digit
        .min_dig2(sev_seg_disp[15:12]),   // Highest digit
        .decimal_point(decimal_pt),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), 
        .CE(CE), .CF(CF), .CG(CG), .DP(DP), 
        .AN1(AN1), .AN2(AN2), .AN3(AN3), .AN4(AN4)
    );

    assign led = adc_raw_data;
    
endmodule