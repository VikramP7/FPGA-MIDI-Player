module buzzer_pwm #(
    parameter int CLOCK_FREQ = 100_000_000 // System clock frequency in Hz
) (
    input  logic clk,    // Clock input
    input  logic reset,  // Active-high reset
    input  logic enable, // Active-high enable
    input  logic [24:0] period,
    output logic pwm_out // PWM signal output for buzzer
);

    logic [24:0] counter;
    logic [24:0] half_period;

    logic [24:0] old_period;
    logic change;

    assign half_period = period >> 1;

    // Toggle pwm_out on each zero pulse
    always_ff @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            pwm_out <= 0;
            old_period <= 0;
        end
        else if (enable) begin
            counter <= counter - 1;
            if ((counter == 0) || change) begin
                counter <= half_period;
                pwm_out <= ~pwm_out; // Toggle the PWM output
            end
        end
        old_period <= period;
    end

    assign change = |(old_period ^ period);

endmodule
