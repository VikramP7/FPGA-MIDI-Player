module song0_pitch(
    input logic [10:0] note_index,
    output logic [6:0] note_pitch
);

always_comb begin
case (note_index)
    0: note_pitch = 60;
    1: note_pitch = 0;
    2: note_pitch = 60;
    3: note_pitch = 62;
    4: note_pitch = 60;
    5: note_pitch = 65;
    6: note_pitch = 64;

    7: note_pitch = 60;
    8: note_pitch = 0;
    9: note_pitch = 60;
    10: note_pitch = 62;
    11: note_pitch = 60;
    12: note_pitch = 67;
    13: note_pitch = 65;

    14: note_pitch = 60;
    15: note_pitch = 0;
    16: note_pitch = 60;
    17: note_pitch = 72;
    18: note_pitch = 69;
    19: note_pitch = 65;
    20: note_pitch = 64;
    21: note_pitch = 62;
    
    22: note_pitch = 70;
    23: note_pitch = 0;
    24: note_pitch = 70;
    25: note_pitch = 69;
    26: note_pitch = 65;
    27: note_pitch = 67;
    28: note_pitch = 65;
    default: note_pitch = 0;
endcase
end

endmodule