module song1_dur #(
    parameter int CLOCK_FREQ = 100_000_000
) (
    input logic [10:0] note_index,
    output logic [28:0] note_dur // max 10s at 100MHz clock
);

localparam real TEMPO_BPM = 5;
localparam real CYCLES_PER_BEAT = CLOCK_FREQ*(60/TEMPO_BPM);

always_comb begin
    // the quarter note is one beat and therfore can be multipled by CYCLES_PER_BEAT
    case (note_index)
        0: note_dur = CYCLES_PER_BEAT * 1;
        1: note_dur = CYCLES_PER_BEAT * 1;
        2: note_dur = CYCLES_PER_BEAT * 1;
        3: note_dur = CYCLES_PER_BEAT * 1;
        4: note_dur = CYCLES_PER_BEAT * 1;
        5: note_dur = CYCLES_PER_BEAT * 1;
        6: note_dur = CYCLES_PER_BEAT * 1;
        7: note_dur = CYCLES_PER_BEAT * 1;
        default: note_dur = 1;
    endcase
end

endmodule