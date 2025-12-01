module song_player_timer #(
    parameter int CLOCK_FREQ = 100_000_000 // System clock frequency in Hz
) (
    input  logic clk,    // Clock input
    input  logic reset,  // Active-high reset
    input  logic enable, // Active-high enable
    input  logic [28:0] cur_note_dur, // max 10s at 100MHz clock
    input logic [2:0]  song_select,
    output logic [10:0] note_index // PWM signal output for buzzer
);

logic [28:0] dur_counter;
logic [10:0] cur_note_index;
logic [2:0]  old_song_select;

always_ff @(posedge clk) begin
    if (reset) begin
        dur_counter <= 28'b0;
        cur_note_index <= 0;
    end
    else if (enable) begin
        if (old_song_select^song_select) begin
            note_index <= 0;
            dur_counter <= 0;
        end
        else if (dur_counter >= cur_note_dur) begin
            dur_counter <= 0;
            cur_note_index <= cur_note_index + 1;
        end
        else begin
            dur_counter <= dur_counter + 1;
        end
        
    end
end

assign note_index = cur_note_index;

endmodule