module song3_pitch(
    input logic [10:0] note_index,
    output logic [6:0] note_pitch
);

always_comb begin
    case (note_index)
        0: note_pitch = 80;
        1: note_pitch = 76;
        2: note_pitch = 80;
        3: note_pitch = 82;
        4: note_pitch = 84;
        5: note_pitch = 82;
        6: note_pitch = 80;
        7: note_pitch = 76;
        8: note_pitch = 68;
        9: note_pitch = 77;
        10: note_pitch = 75;
        11: note_pitch = 72;
        12: note_pitch = 68;
        13: note_pitch = 70;
        14: note_pitch = 72;
        15: note_pitch = 70;
        16: note_pitch = 68;
        17: note_pitch = 65;
        18: note_pitch = 63;
        default: note_pitch = 0;
    endcase
end

endmodule