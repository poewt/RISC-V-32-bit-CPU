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
                Result = A << B;
            end
            3'b110: begin // SRL
                Result = A >> B;
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

        // Zero flags
        if (Result == 0) begin
            Zero = 1;
        end else begin
            Zero = 0;
        end

        // Negative flags
        if (Result[31] == 1) begin
            N = 1;
        end else begin
            N = 0;
        end

        // Handle N, Zero flags only on ADD and SUB
        if (ALUControl == 3'b000) begin // ADD
            // V - A&B must have same sign and
            // V - A must have diff sign from Result
            if (!(A[31] ^ B[31]) && (A[31] ^ Result[31])) begin
                V = 1;
            end else begin
                V = 0;
            end
        end else if (ALUControl == 3'b001) begin // SUB
            // V - A&B must have diff sign and
            // V - if A is pos then Result must be neg
            // V - if A is neg then Result must be pos
            if ((A[31] ^ B[31]) && (A[31] ^ Result[31])) begin
                V = 1;
            end else begin
                V = 0;
            end
        end else begin // Reset otherwise
                V = 0;
        end
    end
endmodule