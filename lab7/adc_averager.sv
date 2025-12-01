module adc_averager #(
    parameter int power = 8, // 2**power samples, default is 2**8 = 256 samples
    parameter int N_raw = 16, // number of bits to average
    parameter int N_ave = 16 // number of bits to average
) (
    input  logic        clk,
    input  logic        reset,
    input  logic        ready,
    input  logic [N_raw-1:0] adc_data,
    output logic [N_ave-1:0] ave_adc_data
);
    // Internal signals
    logic ready_r;
    logic ready_pulse;
    logic [N_ave-1:0] raw_shifted_data;
    logic [N_ave-1:0] ave_data;

    // Pulser 
    always_ff @(posedge clk)
        if (reset)
            ready_r <= 0;
        else
            ready_r <= ready;
       
    assign ready_pulse = ~ready_r & ready; // generate 1-clk pulse when ready goes high

    assign raw_shifted_data = adc_data << (N_ave-N_raw);

    averager #(
        .power(power), // 2**(power) samples, default is 2**8 = 256 samples (4^4 = 256 samples, adds 4 bits of ADC resolution)
        .N(N_ave)     // # of bits to take the average of
    ) AVERAGER (
        .reset(reset),
        .clk(clk),
        .EN(ready_pulse),
        .Din(raw_shifted_data),
        .Q(ave_data)
    );

    assign ave_adc_data = ave_data;
    
endmodule