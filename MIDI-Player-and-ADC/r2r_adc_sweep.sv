module r2r_adc_sweep (
    input  logic        clk,
    input  logic        reset,
    input  logic        comp_result,

    output logic [7:0]  compare_neg_r2r,
    output logic        drdy_out,
    output logic [7:0]  data_out
);
    localparam int max_count = 10000;

    logic [15:0] counter;
    logic update;

    logic [7:0] r2r_out;

    always_ff @(posedge clk) begin
        if(reset) begin
            counter <= max_count;
        end
        else if (counter != 16'b0) begin
            counter <= counter - 1;
        end
        else begin
            counter <= max_count;
        end
    end

    assign update = counter == 16'b0;

    always_ff @(posedge clk) begin
        if(reset) begin
            r2r_out <= 0;
        end
        else if (update) begin
            if ((comp_result==0)||(r2r_out==8'hff)) begin
                drdy_out <= 1;
                data_out <= r2r_out;
                r2r_out <= 0;
            end
            else begin
                r2r_out <= r2r_out + 1;
                drdy_out <= 0;
            end
        end
    end

    assign compare_neg_r2r = r2r_out;
endmodule