import MidiToBoard
# durations_happyBday = [0.65,0.10,0.25,1,1,1,2,
#              0.65,0.10,0.25,1,1,1,2,
#              0.65,0.10,0.25,1,1,1,1,2,
#              0.65,0.10,0.25,1,1,1,2]

# pitches_happyBday = [60,0,60,62,60,65,64,
#            60,0,60,62,60,67,65,
#            60,0,60,72,69,65,64,62,
#            70,0,70,69,65,67,65]

# pitches_erik =   [52,  53,  55,  0,   55,  0,   55,  60,  0,   60,  64, 0,   64,  62,  60,]
# durations_erik = [1.5, 0.5, 0.9, 0.1, 0.9, 0.1, 1,   0.9, 0.1, 1,  0.9, 0.1, 1.5, 0.5, 1,]

#pitches_weezer =   [80,  76,  80,  82,  84,  82,  80,  76,  68, 77, 75, 72, 68,   70,  72,  70,  68,  65, 63]
#durations_weezer = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1,  1,  1,  0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1,  1]
song_number = 8
midi_path = "linging.mid"

song_pitches, song_durations = MidiToBoard.MidiConvert(midi_path)


pitches_file = open(f"song{song_number}_pitch.sv", 'w')

pitches_file.write(f"module song{song_number}_pitch(\n\tinput logic [10:0] note_index,\n\toutput logic [6:0] note_pitch\n);\n")
pitches_file.write(f"\nalways_comb begin\n\tcase (note_index)\n")

for val_indx in range(len(song_pitches)):
    print(f"{val_indx}: note_pitch = {song_pitches[val_indx]};")
    pitches_file.write(f"\t\t{val_indx}: note_pitch = {song_pitches[val_indx]};\n")

pitches_file.write("\t\tdefault: note_pitch = 0;\n\tendcase\nend\nendmodule")
pitches_file.close()
print()

durs_file = open(f"song{song_number}_dur.sv", 'w')

durs_file.write(f"module song{song_number}_dur #(\n\tparameter int CLOCK_FREQ = 100_000_000\n) (\n\tinput logic [10:0] note_index,\n\toutput logic [28:0] note_dur // max 10s at 100MHz clock\n);\n")
durs_file.write(f"\nlocalparam real TEMPO_BPM = 120;\nlocalparam real CYCLES_PER_BEAT = CLOCK_FREQ*(60/TEMPO_BPM);\nlocalparam real CYCLES_PER_US = CLOCK_FREQ/1000_000;\n")
durs_file.write(f"\nalways_comb begin\n\t// the quarter note is one beat and therfore can be multipled by CYCLES_PER_BEAT\n\tcase (note_index)\n")

for val_indx in range(len(song_durations)):
    print(f"{val_indx}: note_dur = CYCLES_PER_US * {song_durations[val_indx]};")
    durs_file.write(f"\t\t{val_indx}: note_dur = CYCLES_PER_US * {song_durations[val_indx]};\n")

durs_file.write(f"\t\tdefault: note_dur = 0;\n\tendcase\nend\nendmodule")
durs_file.close()
