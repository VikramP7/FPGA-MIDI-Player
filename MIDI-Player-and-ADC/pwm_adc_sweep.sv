module pwm_adc_sweep (
    input  logic        clk,
    input  logic        reset,
    input  logic        enable,
    input  logic        comp_result,

    output logic        compare_neg_pwm,
    output logic        drdy_out,
    output logic [WIDTH-1:0]  data_out
);

localparam int WIDTH = 8;

logic update;
logic [WIDTH-1:0] duty;

// generate the output adc that will be filtered
pwm #(.WIDTH(WIDTH)) pwm_adc_pwm_inst (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .duty_cycle(duty),
    .pwm_out(compare_neg_pwm)
);

// updates ever 3 pwm cycles, eg WIDTH = 8, 256ns*5
mydowncounter #(.PERIOD((2**WIDTH)*40)) pwm_adc_wait(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .zero(update)
);

// changes occur when the comp_result changes and when
// the down counter has waited 
// max time = 2^(2*WIDTH)*5*(1/CLK_FREQ)
always_ff @(posedge clk) begin
    if(reset) begin
        duty <= 0;
    end
    else if (update) begin
        if ((comp_result==0)||(duty==8'hff)) begin
            drdy_out <= 1;
            data_out <= duty;
            duty <= 0;
        end
        else begin
            duty <= duty + 1;
            drdy_out <= 0;
        end
    end
end
    
endmodule