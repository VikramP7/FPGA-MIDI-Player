module scaling_calibrator (
    input logic         clk,
    input logic         reset,
    input  logic [1:0]  ADC_select, // switches 15, 14 select between internal IP ADC, the PWM ADC, and the R2R ADC
    input  logic        adc_method_select,

    output logic [15:0] adc_raw_scalar,
    output logic [4:0]  adc_raw_shift
);

    localparam logic [15:0] xadc_scalar = 13;
    localparam logic [4:0]  xadc_shift = 8;

    localparam logic [15:0] pwm_sweep_scalar = 408;     //lowkey i wanna try 408 & 13 (im gonna do it)
    localparam logic [4:0]  pwm_sweep_shift = 13;       // prev it was 785 and 14

    localparam logic [15:0] pwm_sar_scalar = 408;
    localparam logic [4:0]  pwm_sar_shift = 13;

    localparam logic [15:0] r2r_sweep_scalar = 829; // good
    localparam logic [4:0]  r2r_sweep_shift = 14;

    localparam logic [15:0] r2r_sar_scalar = 843;
    localparam logic [4:0]  r2r_sar_shift = 14;    

    muxS_W #(.S(3), .W(16)) scalar_selector (
        .in({r2r_sweep_scalar, r2r_sar_scalar, r2r_sweep_scalar, r2r_sar_scalar, pwm_sweep_scalar, pwm_sar_scalar, xadc_scalar, xadc_scalar}),
        .select({ADC_select, adc_method_select}),
        .mux_out(adc_raw_scalar)
    );

    muxS_W #(.S(3), .W(5)) shift_selector (
        .in({r2r_sweep_shift, r2r_sar_shift, r2r_sweep_shift, r2r_sar_shift, pwm_sweep_shift, pwm_sar_shift, xadc_shift, xadc_shift}),
        .select({ADC_select, adc_method_select}),
        .mux_out(adc_raw_shift)
    );

endmodule