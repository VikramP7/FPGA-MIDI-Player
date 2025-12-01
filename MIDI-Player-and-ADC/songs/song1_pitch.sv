module song1_pitch(
    input logic [10:0] note_index,
    output logic [6:0] note_pitch
);

always_comb begin
case (note_index)
    0: note_pitch = 60;
    1: note_pitch = 62;
    2: note_pitch = 64;
    3: note_pitch = 65;
    4: note_pitch = 67;
    5: note_pitch = 69;
    6: note_pitch = 71;
    7: note_pitch = 72;
    default: note_pitch = 0;
endcase
end

endmodule