module music_adc_top_level (
    input  logic        clk,
    input  logic        reset, // center button
    
    input  logic [15:0] switches_inputs,
    
    input               vauxp15, // Analog input (positive) - connect to JXAC4:N2 PMOD pin  (XADC4)
    input               vauxn15, // Analog input (negative) - connect to JXAC10:N1 PMOD pin (XADC4)
    input  logic        pwm_adc_comp, // output of comparitor connected to pwm
    input  logic        r2r_adc_comp, // output of comparitor connected to r2r ladder
    
    output logic        CA, CB, CC, CD, CE, CF, CG, DP,
    output logic        AN1, AN2, AN3, AN4,
    output logic [15:0] led,
    output logic        buzzer_out,
    
    output logic        pwm_out,
    output logic [7:0]  r2r_out
);
    // NOTE MEMORY CHIP ON BASYS: s25fl032p-spi-x1-x2-x4

    // internal signals    
    // switch assignmnents
    logic raw_data_display_select;  // switch 0 to select between raw hex adc data and scaled averaged bcd data
    logic [1:0] ADC_select; // switches 15, 14 select between internal IP ADC (00), the PWM ADC (01), and the R2R ADC (10, 11)
    logic adc_method_select; // switch 0, chooses between sweep and sar
    logic [2:0] song_select;
    logic buzzer_mute;
    logic volume_control_sw;

    // adc internals
    logic [15:0] adc_raw_data; logic [15:0] xadc_raw_data; logic [7:0] pwm_adc_raw_data; logic [7:0] r2r_adc_raw_data;
    logic        adc_ready,                 XADC_ready,                 pwm_adc_ready,                r2r_adc_ready;
    logic [15:0] adc_raw_data_display;

    // scaling buses
    logic [15:0] adc_raw_scalar;
    logic [4:0]  adc_raw_shift;

    // averaged data of selected adc
    logic [15:0] adc_ave_data;
    logic [15:0] adc_scaled_ave_data;
    logic [15:0] bcd_adc_scaled_ave_data;
    
    logic xadc_enable;

    logic [15:0] sev_seg_disp;

    logic        buzzer_internal;
    logic        buzzer_volumed;

    logic raw_data_display_select_sync;
    logic [1:0] ADC_select_sync;
    logic adc_method_select_sync;
    logic pwm_adc_comp_sync;
    logic r2r_adc_comp_sync;

    logic buzzer_mute_sync;
    logic [2:0] song_select_sync;
    logic volume_control_sw_sync;

    // Constants
    localparam CHANNEL_ADDR = 7'h1f;     // XA4/AD15 (for XADC4)

    // switch assignment
    switch_assignment SWITCH_ASSIGNMENT (
        .switches(switches_inputs),
        .raw_data_display_select(raw_data_display_select),
        .adc_method_select(adc_method_select),
        .ADC_select(ADC_select),
        .song_select(song_select),
        .buzzer_mute(buzzer_mute),
        .volume_control_sw(volume_control_sw)
    );

    // synchronize the raw vs scaled and averaged data switch
    synchronizer raw_data_display_select_synchronizer (
        .clk(clk),
        .reset(reset),
        .unsynchronized_in(raw_data_display_select),
        .synchronized_out(raw_data_display_select_sync)
    );

    // synchronize the pwm vs r2r vs xadc select switches
    synchronizer #(.WIDTH(2)) ADC_select_synchronizer (
        .clk(clk),
        .reset(reset),
        .unsynchronized_in(ADC_select),
        .synchronized_out(ADC_select_sync)
    );

    // synchronize the sweep vs sar select switch
    synchronizer adc_method_select_synchronizer (
        .clk(clk),
        .reset(reset),
        .unsynchronized_in(adc_method_select),
        .synchronized_out(adc_method_select_sync)
    );

    // synchronize the pwm comparator output's input to the basys
    synchronizer pwm_adc_comp_synchronizer (
        .clk(clk),
        .reset(reset),
        .unsynchronized_in(pwm_adc_comp),
        .synchronized_out(pwm_adc_comp_sync)
    );

    // synchronize the r2r comparator output's input to the basys
    synchronizer r2r_adc_comp_synchronizer (
        .clk(clk),
        .reset(reset),
        .unsynchronized_in(r2r_adc_comp),
        .synchronized_out(r2r_adc_comp_sync)
    );

    // synchronize the buzzer mute output's input to the basys
    synchronizer buzzer_mute_synchronizer (
        .clk(clk),
        .reset(reset),
        .unsynchronized_in(buzzer_mute),
        .synchronized_out(buzzer_mute_sync)
    );

    // synchronize the song select switches
    synchronizer #(.WIDTH(3)) song_select_synchronizer (
        .clk(clk),
        .reset(reset),
        .unsynchronized_in(song_select),
        .synchronized_out(song_select_sync)
    );

    // synchronize the volume control enable
    synchronizer volume_control_synchronizer (
        .clk(clk),
        .reset(reset),
        .unsynchronized_in(volume_control_sw),
        .synchronized_out(volume_control_sw_sync)
    );

    // instantiation of the xadc
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

    r2r_adc r2r_adc_inst (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .comp_result(r2r_adc_comp_sync),
        .adc_method_select(adc_method_select_sync),
        .compare_neg_r2r(r2r_out),
        .drdy_out(r2r_adc_ready),
        .data_out(r2r_adc_raw_data)
    );

    pwm_adc pwm_adc_inst (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .comp_result(pwm_adc_comp_sync),
        .adc_method_select(adc_method_select_sync),
        .compare_neg_pwm(pwm_out),
        .drdy_out(pwm_adc_ready),
        .data_out(pwm_adc_raw_data)
    );

    // Select the ready signal as desired
    muxS_W #(.S(2), .W(1)) adc_ready_mux(
        .in({r2r_adc_ready, r2r_adc_ready, pwm_adc_ready, XADC_ready}),
        .select(ADC_select_sync),
        .mux_out(adc_ready)
    );

    // Select ADC data raw
    muxS_W #(.S(2), .W(16)) adc_raw_data_display_mux(
        // padding with zeros to make raw data displayable on screen
        .in({{8'b0,r2r_adc_raw_data}, {8'b0, r2r_adc_raw_data}, {8'b0, pwm_adc_raw_data}, {4'b0, xadc_raw_data[11:0]}}),
        .select(ADC_select_sync),
        .mux_out(adc_raw_data_display)
    );

    // Select the ADC data stream for processing
    muxS_W #(.S(2), .W(16)) adc_raw_data_mux(
        // padding with zeros to make raw data MSBs of input to averager
        .in({{r2r_adc_raw_data,8'b0}, {r2r_adc_raw_data, 8'b0}, {pwm_adc_raw_data, 8'b0}, xadc_raw_data}),
        .select(ADC_select_sync),
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

    scaling_calibrator SCALING_CALIBRATOR(
        .clk(clk),
        .reset(reset),
        .ADC_select(ADC_select_sync),
        .adc_method_select(adc_method_select_sync),
        .adc_raw_scalar(adc_raw_scalar),
        .adc_raw_shift(adc_raw_shift)
    );

    // Performs scaling on the raw averaged adc data to convert to human comprehendable form
    scalar #(
        .IN_WIDTH(16), 
        .SCALAR_WIDTH(16), 
        .SHIFT_WIDTH(5)) 
    adc_ave_data_scalar(
        .clk(clk),
        .reset(reset),
        .data_in(adc_ave_data),
        .scalar(adc_raw_scalar),
        .shift(adc_raw_shift),
        .data_out(adc_scaled_ave_data)
    );

    bin_to_bcd bin_to_bcd_inst(
        .clk(clk),
        .reset(reset),
        .bin_in(adc_scaled_ave_data),
        .bcd_out(bcd_adc_scaled_ave_data)
    );

    // Select raw or scaled average ADC data
    muxS_W #(.S(1), .W(16)) raw_or_cooked_data_selector(
        .in({adc_raw_data_display, bcd_adc_scaled_ave_data}),
        .select(raw_data_display_select_sync),
        .mux_out(sev_seg_disp)
    );

    buzzer_volume_control volume_controller(
        .clk(clk),
        .reset(reset),
        .volume(adc_raw_data),
        .buzzer_in(buzzer_internal),
        .buzzer_out(buzzer_volumed)
    );

    music_player #(.CLOCK_FREQ(100_000_000)) MUSIC_PLAYER(
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .song_select(song_select),
        .nmute(buzzer_mute),
        .buzzer_out(buzzer_internal)
    );

    muxS_W #(.S(1), .W(1)) buzzer_out_mux(
        .in({buzzer_volumed,buzzer_internal}),
        .select(volume_control_sw),
        .mux_out(buzzer_out)
    );

    // Seven Segment Display Subsystem
    basys_display BASYS_DISPLAY (
        .clk(clk), 
        .reset(reset),
        .en(1'b1),
        .sev_seg_disp(sev_seg_disp),
        .led(adc_ave_data),
        .raw_data_display_select(raw_data_display_select_sync),
        .ADC_select(ADC_select_sync),
        .adc_method_select(adc_method_select_sync),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD), 
        .CE(CE), .CF(CF), .CG(CG), .DP(DP), 
        .AN1(AN1), .AN2(AN2), .AN3(AN3), .AN4(AN4),
        .led_out(led)
    );

endmodule