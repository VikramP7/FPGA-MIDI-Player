module song7_pitch(
	input logic [10:0] note_index,
	output logic [6:0] note_pitch
);

always_comb begin
	case (note_index)
		0: note_pitch = 77;
		1: note_pitch = 0;
		2: note_pitch = 77;
		3: note_pitch = 0;
		4: note_pitch = 77;
		5: note_pitch = 0;
		6: note_pitch = 77;
		7: note_pitch = 0;
		8: note_pitch = 75;
		9: note_pitch = 0;
		10: note_pitch = 75;
		11: note_pitch = 0;
		12: note_pitch = 72;
		13: note_pitch = 0;
		14: note_pitch = 72;
		15: note_pitch = 0;
		16: note_pitch = 75;
		17: note_pitch = 0;
		default: note_pitch = 0;
	endcase
end
endmodule