module song0_dur #(
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
        0: note_dur = CYCLES_PER_BEAT * 0.65;
        1: note_dur = CYCLES_PER_BEAT * 0.1;
        2: note_dur = CYCLES_PER_BEAT * 0.25;
        3: note_dur = CYCLES_PER_BEAT * 1;
        4: note_dur = CYCLES_PER_BEAT * 1;
        5: note_dur = CYCLES_PER_BEAT * 1;
        6: note_dur = CYCLES_PER_BEAT * 2;

        7: note_dur = CYCLES_PER_BEAT * 0.65;
        8: note_dur = CYCLES_PER_BEAT * 0.1;
        9: note_dur = CYCLES_PER_BEAT * 0.25;
        10: note_dur = CYCLES_PER_BEAT * 1;
        11: note_dur = CYCLES_PER_BEAT * 1;
        12: note_dur = CYCLES_PER_BEAT * 1;
        13: note_dur = CYCLES_PER_BEAT * 2;

        14: note_dur = CYCLES_PER_BEAT * 0.65;
        15: note_dur = CYCLES_PER_BEAT * 0.1;
        16: note_dur = CYCLES_PER_BEAT * 0.25;
        17: note_dur = CYCLES_PER_BEAT * 1;
        18: note_dur = CYCLES_PER_BEAT * 1;
        19: note_dur = CYCLES_PER_BEAT * 1;
        20: note_dur = CYCLES_PER_BEAT * 1;
        21: note_dur = CYCLES_PER_BEAT * 2;
        
        22: note_dur = CYCLES_PER_BEAT * 0.65;
        23: note_dur = CYCLES_PER_BEAT * 0.1;
        24: note_dur = CYCLES_PER_BEAT * 0.25;
        25: note_dur = CYCLES_PER_BEAT * 1;
        26: note_dur = CYCLES_PER_BEAT * 1;
        27: note_dur = CYCLES_PER_BEAT * 1;
        28: note_dur = CYCLES_PER_BEAT * 2;
        default: note_dur = 1;
    endcase
end

endmodule