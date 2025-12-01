module music_player #(parameter int CLOCK_FREQ=100_000_000) (
    input  logic         clk,
    input  logic         reset,
    input  logic         enable,
    input  logic [2:0]   song_select,
    input  logic         nmute,
    input  logic [15:0]  volume,
    
    output logic         buzzer_out
);
    // Internal signal declarations
    logic [24:0] buzzer_period;
    logic buzzer_enable;
    logic [6:0] cur_pitch, cur_song0_pitch, cur_song1_pitch, cur_song2_pitch, cur_song3_pitch, cur_song4_pitch, cur_song5_pitch, cur_song6_pitch, cur_song7_pitch;
    logic [28:0] cur_dur, cur_song0_dur, cur_song1_dur, cur_song2_dur, cur_song3_dur, cur_song4_dur, cur_song5_dur, cur_song6_dur, cur_song7_dur;
    logic [10:0] cur_note_index;


    song0_dur #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) cur_song_happy_dur(
        .note_index(cur_note_index),
        .note_dur(cur_song0_dur)
    );
    song1_dur #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) cur_song_scale_dur(
        .note_index(cur_note_index),
        .note_dur(cur_song1_dur)
    );
    song2_dur #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) cur_song_erik_dur(
        .note_index(cur_note_index),
        .note_dur(cur_song2_dur)
    );

    song3_dur #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) cur_song_weezer_dur(
        .note_index(cur_note_index),
        .note_dur(cur_song3_dur)
    );

    song4_dur #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) cur_song_giant_dur(
        .note_index(cur_note_index),
        .note_dur(cur_song4_dur)
    );

    song5_dur #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) cur_song_five_dur(
        .note_index(cur_note_index),
        .note_dur(cur_song5_dur)
    );

    song6_dur #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) cur_song_teq_dur(
        .note_index(cur_note_index),
        .note_dur(cur_song6_dur)
    );
    
    song7_dur #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) cur_song_linging_dur(
        .note_index(cur_note_index),
        .note_dur(cur_song7_dur)
    );

    muxS_W #(.S(3), .W(29)) cur_dur_mux (
        .in({cur_song7_dur, cur_song6_dur, cur_song5_dur, cur_song4_dur, cur_song3_dur, cur_song2_dur, cur_song1_dur, cur_song0_dur}),
        .select(song_select),
        .mux_out(cur_dur)
    );

    song0_pitch cur_song_happy_pitch (
        .note_index(cur_note_index),
        .note_pitch(cur_song0_pitch)
    );

    song1_pitch cur_song_scale_pitch (
        .note_index(cur_note_index),
        .note_pitch(cur_song1_pitch)
    );

    song2_pitch cur_song_erik_pitch (
        .note_index(cur_note_index),
        .note_pitch(cur_song2_pitch)
    );

    song3_pitch cur_song_weezer_pitch (
        .note_index(cur_note_index),
        .note_pitch(cur_song3_pitch)
    );

    song4_pitch cur_song_giant_pitch (
        .note_index(cur_note_index),
        .note_pitch(cur_song4_pitch)
    );

    song5_pitch cur_song_five_pitch (
        .note_index(cur_note_index),
        .note_pitch(cur_song5_pitch)
    );

    song6_pitch cur_song_teq_pitch (
        .note_index(cur_note_index),
        .note_pitch(cur_song6_pitch)
    );

    song7_pitch cur_song_linging_pitch (
        .note_index(cur_note_index),
        .note_pitch(cur_song7_pitch)
    );

    muxS_W #(.S(3), .W(7)) cur_pitch_mux (
        .in({cur_song7_pitch, cur_song6_pitch, cur_song5_pitch, cur_song4_pitch, cur_song3_pitch, cur_song2_pitch, cur_song1_pitch, cur_song0_pitch}),
        .select(song_select),
        .mux_out(cur_pitch)
    );


    song_player_timer #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) player (
        .clk(clk),
        .reset(reset),
        .enable(nmute),
        .cur_note_dur(cur_dur),
        .note_index(cur_note_index)
    );


    note_to_period  #(
        .CLOCK_FREQ(CLOCK_FREQ) // System clock frequency in Hz
    ) note_to_period_inst (
        .note(cur_pitch),
        .period(buzzer_period)
    );

    assign buzzer_enable = (cur_pitch != 0) && enable && nmute;

    buzzer_pwm #(
        .CLOCK_FREQ(100_000_000) // System clock frequency in Hz
    ) buzzer_inst (
        .clk(clk),
        .reset(reset),
        .enable(buzzer_enable),
        .period(buzzer_period),
        .pwm_out(buzzer_out) // Connect this to the buzzer output pin
    );

    
endmodule