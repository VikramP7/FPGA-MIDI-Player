module buzzer_volume_control (
    input  logic clk,
    input  logic reset,
    input  logic [15:0] volume,
    input  logic buzzer_in,

    output logic buzzer_out
);
    // local params
    localparam PWM_RES = 4;

    logic [PWM_RES-1:0] volume_small;
    logic [PWM_RES-1:0] counter;

    assign volume_small = volume >> 12; 

    always_ff @( posedge clk ) begin
        if(reset) begin
            counter <= 0;
        end
        else if(counter < volume_small) begin
            buzzer_out <= 1 & buzzer_in;
            counter <= counter + 1;
        end
        else begin
            buzzer_out <= 0 & buzzer_in;
            counter <= counter + 1;
        end
    end
endmodule