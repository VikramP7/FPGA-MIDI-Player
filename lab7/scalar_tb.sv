`timescale 1ns / 1ns

module scalar_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock
    parameter SHORT_WAIT = (15*CLK_PERIOD);
    parameter LONG_WAIT =  (100*CLK_PERIOD);

    // Signals
    logic [15:0] data_in;
    logic [15:0] data_out;
    logic [15:0] scalar;
    logic [4:0] shift;

    logic reset;
    logic clk;

    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end

    // Instantiate the Unit Under Test (UUT)
    scalar uut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .scalar(scalar),
        .shift(shift),
        .data_out(data_out)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        data_in = 16'h0000;
        scalar = 16'h0000;
        shift = 5'd0;
        
        reset = 0;
        #(CLK_PERIOD);
        reset = 1;
        #CLK_PERIOD
        reset = 0;
        #CLK_PERIOD

        #(100);
        
        // Test case 0:
        data_in = 16'h0000;
        scalar = 16'h0000;
        shift = 5'd0;
        #LONG_WAIT
        
        // Test case 1:
        data_in = 16'h0001;
        scalar = 16'h0008;
        shift = 5'd0;
        #LONG_WAIT

        // Test case 2:
        data_in = 16'hFFFF;
        scalar = 16'd13;
        shift = 5'd8;
        #LONG_WAIT

        // Test case 3:
        data_in = 16'hFFFF;
        scalar = 16'h0001;
        shift = 5'd4;
        #LONG_WAIT

        // Test case 4:
        data_in = 16'h0FFF;
        scalar = 16'h0010;
        shift = 5'd0;
        #LONG_WAIT

        // Test case 5:
        data_in = 16'h0FFF;
        scalar = 16'h0010;
        shift = 5'd4;
        #LONG_WAIT


        // End simulation
        #(5 * CLK_PERIOD);
        $stop;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("Time = %0t: data_in = %b, scalar = %b, shift = %b, data_out", 
                 $time, data_in, scalar, shift, data_out);
    end

endmodule