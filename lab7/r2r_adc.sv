module r2r_adc (
    input  logic        clk,
    input  logic        reset,
    input  logic        enable,
    input  logic        comp_result,
    input  logic        adc_method_select,

    output logic [7:0]  compare_neg_r2r,
    output logic        drdy_out,
    output logic [7:0]  data_out
);
    // Internal Signals
    logic [7:0] r2r_out_sweep, r2r_out_sar;
    logic       r2r_adc_sweep_ready, r2r_adc_sar_ready; 
    logic [7:0] r2r_adc_sweep_raw_data, r2r_adc_sar_raw_data;

    // Performs an ADC sweep using the R2R ladder to produce an analog output
    r2r_adc_sweep r2r_adc_sweep_inst (
        .clk(clk),
        .reset(reset),
        .comp_result(comp_result),
        .compare_neg_r2r(r2r_out_sweep),
        .drdy_out(r2r_adc_sweep_ready),
        .data_out(r2r_adc_sweep_raw_data)
    );

    // Performs a sweep based ADC using the R2R ladder to produce an analog output using sucessive approximation
    r2r_adc_sar r2r_adc_sar_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .comp_result(comp_result),
        .compare_neg_r2r(r2r_out_sar),
        .drdy_out(r2r_adc_sar_ready),
        .data_out(r2r_adc_sar_raw_data)
    );

    // Selects between the two ADC methods: the sweep based or the SAR based
    muxS_W #(.S(1), .W(8)) r2r_adc_method_r2r_out_mux(
        .in({r2r_out_sweep, r2r_out_sar}),
        .select(adc_method_select),
        .mux_out(compare_neg_r2r)
    );

    // Extension of the method select mux; maps data for when the ADC outputs are ready
    muxS_W #(.S(1), .W(1)) r2r_adc_method_ready_mux(
        .in({r2r_adc_sweep_ready, r2r_adc_sar_ready}),
        .select(adc_method_select),
        .mux_out(drdy_out)
    );

    // Extension of the method select to output the raw data
    muxS_W #(.S(1), .W(8)) r2r_adc_method_raw_data_mux(
        .in({r2r_adc_sweep_raw_data, r2r_adc_sar_raw_data}),
        .select(adc_method_select),
        .mux_out(data_out)
    );
endmodule