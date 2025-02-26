module alu(
    input signed [31:0] A, B,
    input [2:0] ALUControl,
    output reg signed [31:0] Result,
    output reg V, N, Zero
);

    always @(A, B, ALUControl) begin
        case (ALUControl)
            3'b000: begin // ADD
                Result = A + B;
            end
            3'b001: begin // SUB
                Result = A - B;
            end
            3'b010: begin // AND
                Result = A & B;
            end
            3'b011: begin // OR
                Result = A | B;
            end
            3'b100: begin // XOR
                Result = A ^ B;
            end
            3'b101: begin // SLL
                Result = A << 1;
            end
            3'b110: begin // SRL
                Result = A >> 1;
            end
            3'b111: begin // SLT
                if (A - B < 0)
                    // Set Less Than to 1
                    Result = 32'd1;
                else
                    // Set Less Than to 0
                    Result = 32'd0;
            end
            default:
                Result = 0;
        endcase

        if (A - B < 0) begin
            N <= 1;
            Zero <= 0;
        end else if (A - B == 0) begin
            Zero <= 1;
            N <= 0;
            V <= 0;
        end else begin
            V <= 0;
            N <= 0;
            Zero <= 0;
        end
    end
endmodule