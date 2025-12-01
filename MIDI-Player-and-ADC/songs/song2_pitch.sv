module song2_pitch(
	input logic [10:0] note_index,
	output logic [6:0] note_pitch
);

always_comb begin
	case (note_index)
		0: note_pitch = 60;
		1: note_pitch = 0;
		2: note_pitch = 61;
		3: note_pitch = 0;
		4: note_pitch = 63;
		5: note_pitch = 0;
		6: note_pitch = 63;
		7: note_pitch = 0;
		8: note_pitch = 63;
		9: note_pitch = 0;
		10: note_pitch = 68;
		11: note_pitch = 0;
		12: note_pitch = 68;
		13: note_pitch = 0;
		14: note_pitch = 72;
		15: note_pitch = 0;
		16: note_pitch = 72;
		17: note_pitch = 0;
		18: note_pitch = 70;
		19: note_pitch = 0;
		20: note_pitch = 68;
		21: note_pitch = 0;
		22: note_pitch = 63;
		23: note_pitch = 0;
		24: note_pitch = 63;
		25: note_pitch = 0;
		26: note_pitch = 63;
		27: note_pitch = 0;
		28: note_pitch = 67;
		29: note_pitch = 0;
		30: note_pitch = 68;
		31: note_pitch = 0;
		32: note_pitch = 70;
		33: note_pitch = 0;
		34: note_pitch = 63;
		35: note_pitch = 0;
		36: note_pitch = 63;
		37: note_pitch = 0;
		38: note_pitch = 63;
		39: note_pitch = 0;
		40: note_pitch = 72;
		41: note_pitch = 0;
		42: note_pitch = 70;
		43: note_pitch = 0;
		44: note_pitch = 68;
		45: note_pitch = 0;
		default: note_pitch = 0;
	endcase
end
endmodule