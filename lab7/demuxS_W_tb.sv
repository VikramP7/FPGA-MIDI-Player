`timescale 1ns / 1ns

module demuxS_W_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 10ns for 100MHz clock
    parameter SHORT_WAIT = (15*CLK_PERIOD);
    parameter LONG_WAIT =  (100*CLK_PERIOD);

    // Signals
    logic [15:0] data_in;
    logic [15:0] data_out0;
    logic [15:0] data_out1;
    logic [15:0] data_out2;
    logic [15:0] data_out3;
    logic [1:0] select;

    logic reset;
    logic clk;

    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end

    // Instantiate the Unit Under Test (UUT)
    demuxS_W #(.S(2), .W(16)) uut (
        .in(data_in),
        .select(select),
        .mux_out({data_out3, data_out2, data_out1, data_out0})
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        data_in = 16'h0000;
        select = 2'b00;
        
        reset = 0;
        #(CLK_PERIOD);
        reset = 1;
        #CLK_PERIOD
        reset = 0;
        #CLK_PERIOD

        #(100);
        
        // Test case 0:
        data_in = 16'h0000;
        select = 2'b00;
        #LONG_WAIT
        
        // Test case 1:
        data_in = 16'h0000;
        select = 2'b01;
        #LONG_WAIT

        // Test case 2:
        data_in = 16'hFFFF;
        select = 2'b00;
        #LONG_WAIT

        // Test case 3:
        data_in = 16'hFFFA;
        select = 2'b01;
        #LONG_WAIT

        // Test case 4:
        data_in = 16'hFFBF;
        select = 2'b10;
        #LONG_WAIT

        // Test case 5:
        data_in = 16'hFCFF;
        select = 2'b11;
        #LONG_WAIT


        // End simulation
        #(5 * CLK_PERIOD);
        $stop;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("Time = %0t: data_in = %b, select = %b, data_out", 
                 $time, data_in, select, data_out0);
    end

endmodule