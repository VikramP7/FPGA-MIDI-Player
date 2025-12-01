module pwm_adc (
    input  logic        clk,
    input  logic        reset,
    input  logic        enable,
    input  logic        comp_result,
    input  logic        adc_method_select,

    output logic        compare_neg_pwm,
    output logic        drdy_out,
    output logic [7:0]  data_out
);

    logic [7:0] pwm_out_sweep, pwm_out_sar;
    logic       pwm_adc_sweep_ready, pwm_adc_sar_ready; 
    logic [7:0] pwm_adc_sweep_raw_data, pwm_adc_sar_raw_data;

    // Perform ADC sweep and output data
    pwm_adc_sweep pwm_adc_sweep_inst (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .comp_result(comp_result),
        .compare_neg_pwm(pwm_out_sweep),
        .drdy_out(pwm_adc_sweep_ready),
        .data_out(pwm_adc_sweep_raw_data)
    );

    // Perform successive ADC and output data
    pwm_adc_sar pwm_adc_sar_inst (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .comp_result(comp_result),
        .compare_neg_pwm(pwm_out_sar),
        .drdy_out(pwm_adc_sar_ready),
        .data_out(pwm_adc_sar_raw_data)
    );

    
    muxS_W #(.S(1), .W(1)) pwm_adc_method_pwm_out_mux(
        .in({pwm_out_sweep, pwm_out_sar}),
        .select(adc_method_select),
        .mux_out(compare_neg_pwm)
    );

    // Maps the ready signal from when the 
    muxS_W #(.S(1), .W(1)) pwm_adc_method_ready_mux(
        .in({pwm_adc_sweep_ready, pwm_adc_sar_ready}),
        .select(adc_method_select),
        .mux_out(drdy_out)
    );

    // Select between the normal sweep and the SAR approximation
    muxS_W #(.S(1), .W(8)) pwm_adc_method_raw_data_mux(
        .in({pwm_adc_sweep_raw_data, pwm_adc_sar_raw_data}),
        .select(adc_method_select),
        .mux_out(data_out)
    );
endmodule