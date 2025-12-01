module demuxS_W #(parameter S, parameter W)(
    input  logic [W-1:0] in,    
    input  logic [S-1:0] select,  
    output logic [(2**S)*W-1:0] mux_out
    );
    // logic [W*(2**S):0] shift_amount;
    // logic [(2**S)*W-1:0] temp;
    
    // assign temp = in;
    // assign shift_amount = (select)*W;
    // assign mux_out = temp << shift_amount;

    // Definitely stole this code but apparently it works.
    // Not sure what the TAs and such wil think about stolen code
    // but we can just say that it's AI. The plus thing
    // is pretty cool. 
    // -C, (The good one)

    // this is what I orignally had but I swear vivado 
    // was complaining about select not being a constant
    // this is good we'll use this one
    // -V, (the sticky one) 
    always_comb begin
        mux_out = '0;
        mux_out[select*W +: W] = in;
    end

endmodule