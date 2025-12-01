module switch_assignment (
    input  logic [15:0] switches,

    output logic raw_data_display_select,
    output logic [1:0] ADC_select,
    output logic adc_method_select,
    output logic [2:0] song_select,
    output logic buzzer_mute,
    output logic volume_control_sw
);


    assign raw_data_display_select = switches[0];
    assign adc_method_select = switches[13];
    assign ADC_select = switches[15:14];
    assign song_select = switches[11:9];
    assign buzzer_mute = switches[3];
    assign volume_control_sw = switches[4];

endmodule