module song2_dur #(
	parameter int CLOCK_FREQ = 100_000_000
) (
	input logic [10:0] note_index,
	output logic [28:0] note_dur // max 10s at 100MHz clock
);

localparam real TEMPO_BPM = 120;
localparam real CYCLES_PER_BEAT = CLOCK_FREQ*(60/TEMPO_BPM);
localparam real CYCLES_PER_US = CLOCK_FREQ/1000_000;

always_comb begin
	// the quarter note is one beat and therfore can be multipled by CYCLES_PER_BEAT
	case (note_index)
		0: note_dur = CYCLES_PER_US * 748958;
		1: note_dur = CYCLES_PER_US * 1042;
		2: note_dur = CYCLES_PER_US * 248958;
		3: note_dur = CYCLES_PER_US * 1042;
		4: note_dur = CYCLES_PER_US * 498958;
		5: note_dur = CYCLES_PER_US * 1042;
		6: note_dur = CYCLES_PER_US * 498958;
		7: note_dur = CYCLES_PER_US * 1042;
		8: note_dur = CYCLES_PER_US * 498958;
		9: note_dur = CYCLES_PER_US * 1042;
		10: note_dur = CYCLES_PER_US * 498958;
		11: note_dur = CYCLES_PER_US * 1042;
		12: note_dur = CYCLES_PER_US * 498958;
		13: note_dur = CYCLES_PER_US * 1042;
		14: note_dur = CYCLES_PER_US * 498958;
		15: note_dur = CYCLES_PER_US * 1042;
		16: note_dur = CYCLES_PER_US * 748958;
		17: note_dur = CYCLES_PER_US * 1042;
		18: note_dur = CYCLES_PER_US * 248958;
		19: note_dur = CYCLES_PER_US * 1042;
		20: note_dur = CYCLES_PER_US * 498958;
		21: note_dur = CYCLES_PER_US * 1042;
		22: note_dur = CYCLES_PER_US * 123958;
		23: note_dur = CYCLES_PER_US * 376042;
		24: note_dur = CYCLES_PER_US * 123958;
		25: note_dur = CYCLES_PER_US * 376042;
		26: note_dur = CYCLES_PER_US * 123958;
		27: note_dur = CYCLES_PER_US * 376042;
		28: note_dur = CYCLES_PER_US * 498958;
		29: note_dur = CYCLES_PER_US * 1042;
		30: note_dur = CYCLES_PER_US * 498958;
		31: note_dur = CYCLES_PER_US * 1042;
		32: note_dur = CYCLES_PER_US * 498958;
		33: note_dur = CYCLES_PER_US * 1042;
		34: note_dur = CYCLES_PER_US * 123958;
		35: note_dur = CYCLES_PER_US * 376042;
		36: note_dur = CYCLES_PER_US * 123958;
		37: note_dur = CYCLES_PER_US * 376042;
		38: note_dur = CYCLES_PER_US * 123958;
		39: note_dur = CYCLES_PER_US * 376042;
		40: note_dur = CYCLES_PER_US * 748958;
		41: note_dur = CYCLES_PER_US * 1042;
		42: note_dur = CYCLES_PER_US * 248958;
		43: note_dur = CYCLES_PER_US * 1042;
		44: note_dur = CYCLES_PER_US * 498958;
		45: note_dur = CYCLES_PER_US * 498958;
		default: note_dur = 0;
	endcase
end
endmodule