module song7_dur #(
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
		0: note_dur = CYCLES_PER_US * 175735;
		1: note_dur = CYCLES_PER_US * 2940;
		2: note_dur = CYCLES_PER_US * 175735;
		3: note_dur = CYCLES_PER_US * 2940;
		4: note_dur = CYCLES_PER_US * 175735;
		5: note_dur = CYCLES_PER_US * 2940;
		6: note_dur = CYCLES_PER_US * 175735;
		7: note_dur = CYCLES_PER_US * 2940;
		8: note_dur = CYCLES_PER_US * 352206;
		9: note_dur = CYCLES_PER_US * 2940;
		10: note_dur = CYCLES_PER_US * 352206;
		11: note_dur = CYCLES_PER_US * 2940;
		12: note_dur = CYCLES_PER_US * 352206;
		13: note_dur = CYCLES_PER_US * 2940;
		14: note_dur = CYCLES_PER_US * 352206;
		15: note_dur = CYCLES_PER_US * 2940;
		16: note_dur = CYCLES_PER_US * 705147;
		17: note_dur = CYCLES_PER_US * 705147;
		default: note_dur = 0;
	endcase
end
endmodule