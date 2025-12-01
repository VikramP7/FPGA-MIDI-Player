`timescale 1ns / 1ps

module r2r_adc_sar_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock
    parameter SHORT_WAIT = (15*CLK_PERIOD);
    parameter LONG_WAIT =  (100*CLK_PERIOD);

    // Signals
    logic       r2r_adc_comp;
    logic [7:0] R2R_out;
    logic       r2r_adc_ready;
    logic [7:0] r2r_adc_raw_data;

    logic reset;
    logic clk;

    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end

    // Instantiate the Unit Under Test (UUT)
    r2r_adc_sar uut (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .comp_result(r2r_adc_comp),
        .compare_neg_r2r(R2R_out),
        .drdy_out(r2r_adc_ready),
        .data_out(r2r_adc_raw_data)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        r2r_adc_comp = 0;
        
        reset = 0;
        #(CLK_PERIOD);
        reset = 1;
        #CLK_PERIOD;
        reset = 0;
        //#CLK_PERIOD;

        #(100);
        
        // starting in STATE_RESET
        #(CLK_PERIOD);

        // now in STATE_SET_CURRENT_BIT
        #(CLK_PERIOD);
        
        // now in STATE_WAIT
        // now R2R is set and compare should change
        r2r_adc_comp = 0;
        #(CLK_PERIOD);

        // now in STATE_TOO_HIGH
        #(CLK_PERIOD);

        // now in STATE_SHIFT
        #(CLK_PERIOD);

        // now in STATE_SET_CURRENT_BIT
        #(CLK_PERIOD);

        // now in STATE_WAIT
        // now R2R is set and compare should change
        r2r_adc_comp = 1;
        #(CLK_PERIOD);

        // now in STATE_SHIFT
        #(CLK_PERIOD);

        // now in STATE_SET_CURRENT_BIT
        #(CLK_PERIOD);

        

        // End simulation
        #(256 * CLK_PERIOD);
        $stop;
    end

    // Optional: Monitor changes
    // initial begin
    //     $monitor("Time = %0t: data_in = %b, select = %b, data_out", 
    //              $time, data_in, select, data_out0);
    // end

endmodule