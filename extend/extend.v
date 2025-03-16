module extend (
    input [31:7] imm_in,
    input [2:0] extend_ctrl,
    output reg [31:0] imm_out
);

    always @(imm_in, extend_ctrl) begin
        case (extend_ctrl)
            3'b000: begin // I-Type (Immediate)
                imm_out = { { 20{imm_in[31]} }, imm_in[31:20]};
            end
            3'b001: begin // S-Type (Stores)
                imm_out = { { 13{imm_in[31]} }, imm_in[31:25], imm_in[11:7] };
            end
            3'b010: begin // B-Type (Branch)
                // * LSB bit is 0 for word alignment (branch type)
                imm_out = { { 19{imm_in[31]} }, imm_in[31], imm_in[7], imm_in[30:25], imm_in[11:8], 1'b0 };
            end
            3'b011: begin // U-Type (Upper Immediate)
                // * lower 12 bits are always 0s
                imm_out = { imm_in[31:12], 12'b0};
            end
            3'b100: begin // J-Type (Jump)
                // * LSB is 0 for word alignment (jump type)
                imm_out = { { 11{imm_in[31]} } , imm_in[31], imm_in[19:12], imm_in[20], imm_in[30:21], 1'b0 };
            end
            default: begin // X
                imm_out = 32'b0;
            end
        endcase
    end
    
endmodule