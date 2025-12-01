module song3_dur #(
    parameter int CLOCK_FREQ = 100_000_000
) (
    input logic [10:0] note_index,
    output logic [28:0] note_dur // max 10s at 100MHz clock
);

localparam real TEMPO_BPM = 120;
localparam real CYCLES_PER_BEAT = CLOCK_FREQ*(60/TEMPO_BPM);

always_comb begin
    // the quarter note is one beat and therfore can be multipled by CYCLES_PER_BEAT
    case (note_index)
        0: note_dur = CYCLES_PER_BEAT * 0.5;
        1: note_dur = CYCLES_PER_BEAT * 0.5;
        2: note_dur = CYCLES_PER_BEAT * 0.5;
        3: note_dur = CYCLES_PER_BEAT * 0.5;
        4: note_dur = CYCLES_PER_BEAT * 0.5;
        5: note_dur = CYCLES_PER_BEAT * 0.5;
        6: note_dur = CYCLES_PER_BEAT * 0.5;
        7: note_dur = CYCLES_PER_BEAT * 0.5;
        8: note_dur = CYCLES_PER_BEAT * 1;
        9: note_dur = CYCLES_PER_BEAT * 1;
        10: note_dur = CYCLES_PER_BEAT * 1;
        11: note_dur = CYCLES_PER_BEAT * 0.5;
        12: note_dur = CYCLES_PER_BEAT * 0.5;
        13: note_dur = CYCLES_PER_BEAT * 0.5;
        14: note_dur = CYCLES_PER_BEAT * 0.5;
        15: note_dur = CYCLES_PER_BEAT * 0.5;
        16: note_dur = CYCLES_PER_BEAT * 0.5;
        17: note_dur = CYCLES_PER_BEAT * 1;
        18: note_dur = CYCLES_PER_BEAT * 1;
        default: note_dur = 0;
    endcase
end

endmodule