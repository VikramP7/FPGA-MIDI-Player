module synchronizer #(
    parameter int WIDTH = 1
) (
    input logic clk,
    input logic reset,

    input logic [WIDTH-1:0] unsynchronized_in,
    output logic [WIDTH-1:0] synchronized_out
);

    // internal signals
    logic [WIDTH-1:0] almost_synchronized;

    always_ff @( posedge clk ) begin 
        if (reset) begin
            synchronized_out <= 0;
            almost_synchronized <= 0;
        end
        else begin
            almost_synchronized <= unsynchronized_in;
            synchronized_out <= almost_synchronized;
        end
    end


    
endmodule