module scalar #(
    parameter int IN_WIDTH = 16,
    parameter int SCALAR_WIDTH = 16,
    parameter int SHIFT_WIDTH = 5
)(
    input  logic        clk,
    input  logic        reset,
    input  logic [IN_WIDTH-1:0] data_in,
    input  logic [SCALAR_WIDTH-1:0] scalar,
    input  logic [SHIFT_WIDTH-1:0] shift,
    output logic [IN_WIDTH-1:0] data_out
);
    logic [IN_WIDTH+SCALAR_WIDTH-1:0] intermediate;
    // Probably a good idea to start adding some documentation to each of our modules so that they're a little more readable.
    // So I will be starting on that here. I will gradually go through the other modules and do that too. 
    // -C, (The good one)
    // Performs the scaling operation (multiply and right shift) for a given set of inputs.
    assign intermediate = (data_in * scalar); // this prevents multiplication truncation
    assign data_out = intermediate >> shift; 

endmodule