module alu(
    input [31:0] A, B,
    input [2:0] ALUControl,
    output reg [31:0] Result
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
    end
endmodule