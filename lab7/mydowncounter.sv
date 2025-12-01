module mydowncounter #(
    parameter int PERIOD = 1000  // Number to count down from, must be positive
) (
    input  logic clk,    // Clock input
    input  logic reset,  // Active-high reset
    input  logic enable, // Active-high enable
    output logic zero    // Pulses high for one clock cycle when counter reaches zero
);

    // Calculate the number of bits needed to represent PERIOD
    localparam int COUNT_WIDTH = $clog2(PERIOD);

    logic [COUNT_WIDTH-1:0] counter;

    always_ff @(posedge clk) begin
        if(reset) begin
            counter <= PERIOD-1;
        end
        else if (counter == 16'b0) begin
            counter <= PERIOD-1;
        end
        else if (enable) begin
            counter <= counter - 1;
        end
        
    end

    assign zero = counter == 0;
endmodule