/*
 * Preforms a Successive-approximation based ADC using the PWM and low pass filter to produce an analog output
 * 
*/

localparam int WIDTH = 8;

module pwm_adc_sar (
    input  logic        clk,
    input  logic        reset,
    input  logic        enable,
    input  logic        comp_result,

    output logic        compare_neg_pwm,
    output logic        drdy_out,
    output logic [WIDTH-1:0]  data_out
);

logic drdy;
logic wait_done;

/*--------------------- FINITE STATE MACHINE ---------------------*/

typedef enum logic [2:0] { 
    STATE_SET_CURRENT_BIT,
    STATE_WAIT,
    STATE_TOO_HIGH,
    STATE_SHIFT,
    STATE_RESET
 } statetype;

statetype current_state, next_state;

// state machine outputs
logic pwm_update_en;
logic a;
logic sarry_shift_en;

// state register
always_ff @(posedge clk) begin
    if(reset) begin
        current_state <= STATE_RESET;
    end
    else begin
        current_state <= next_state;
    end
end

// Next State Logic
always_comb begin
    case (current_state)
        STATE_SET_CURRENT_BIT: begin
            next_state = STATE_WAIT;
        end
        STATE_WAIT: begin
            if (wait_done) begin
                if(comp_result)
                    next_state = STATE_SHIFT;
                else
                    next_state = STATE_TOO_HIGH;
            end 
            else begin
                next_state = STATE_WAIT;
            end
        end
        STATE_TOO_HIGH: begin
            next_state = STATE_SHIFT;
        end
        STATE_SHIFT: begin
            next_state = STATE_SET_CURRENT_BIT;
        end
        STATE_RESET: begin
            next_state = STATE_SET_CURRENT_BIT;
        end
        default:
            next_state = STATE_RESET;
    endcase
end

// output logic
always_comb begin
    case (current_state)
        STATE_SET_CURRENT_BIT: begin
            a = 1;
            pwm_update_en = 1;
            sarry_shift_en = 0;
        end
        STATE_WAIT: begin
            a = 0;
            pwm_update_en = 0;
            sarry_shift_en = 0;
        end
        STATE_TOO_HIGH: begin
            a = 0;
            pwm_update_en = 1;
            sarry_shift_en = 0;
        end
        STATE_SHIFT: begin
            a = 0;
            pwm_update_en = 0;
            sarry_shift_en = 1;
        end
        STATE_RESET: begin
            a = 0;
            pwm_update_en = 0;
            sarry_shift_en = 0;
        end
        default: begin
            a = 0;
            pwm_update_en = 0;
            sarry_shift_en = 0;
        end
    endcase
end

/*--------------------- END FINITE STATE MACHINE ---------------------*/

/* ---------- SARRY_ONE SHIFTING LOGIC ----------------------*/
logic [WIDTH-1:0] sarry_one;

always_ff @( posedge clk ) begin
    if(reset | drdy) begin
        sarry_one <= 8'b1000_0000;
    end
    else if (sarry_shift_en) begin
        sarry_one <= sarry_one >> 1;
    end
end


/*-------------------- PWM REGISTER ------------------*/
logic [7:0] compare_neg_pwm_duty_reg;

always_ff @( posedge clk ) begin
    if(reset) begin
        compare_neg_pwm_duty_reg <= 8'b0;
    end
    else if (drdy) begin
        compare_neg_pwm_duty_reg <= 8'b1000_0000;
    end
    else if (pwm_update_en) begin
        if(a) begin
            compare_neg_pwm_duty_reg <= compare_neg_pwm_duty_reg | sarry_one;
        end
        else if(~a) begin
            compare_neg_pwm_duty_reg <= compare_neg_pwm_duty_reg & ~sarry_one;
        end
    end
end

/*-------------------- DATA OUT REGISTER ------------------*/
always_ff @( posedge clk ) begin
    if (reset) begin
        data_out <= 8'b0;
    end
    else if (drdy) begin
        data_out <= compare_neg_pwm_duty_reg;
    end
end

/*------------------ DRDY LOGIC -----------------------*/
assign drdy = ~(|sarry_one); // sarry_one == 0

/*-------------- MODULE OUTPUTS ---------------------*/
assign drdy_out = drdy;

// updates ever 10ms
mydowncounter #(.PERIOD(10000)) pwm_adc_wait(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .zero(wait_done)
);

// generate the output adc that will be filtered
pwm #(.WIDTH(WIDTH)) pwm_adc_pwm_sar_inst (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .duty_cycle(compare_neg_pwm_duty_reg),
    .pwm_out(compare_neg_pwm)
);
    
endmodule