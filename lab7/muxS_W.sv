module muxS_W #(parameter S, parameter W)(
    input  logic [W-1:0] in [2**S-1:0],    
    input  logic [S-1:0] select,  
    output logic [W-1:0] mux_out
    );

    assign mux_out = in[select];
endmodule