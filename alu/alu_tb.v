module alu_tb ();
    // test inputs
    reg signed [31:0] A, B;
    reg [2:0] ALUControl;

    // test outputs
    wire signed [31:0] Result;
    wire V, N, Zero;

    alu uut(
        A,
        B,
        ALUControl,
        Result,
        V,
        N,
        Zero
    );

    // Task for test assertion
    task assert_test(
        input [127:0] label,
        input signed [31:0] expected,
        input use_bin
    );
        begin
            $display("==================================================");
            $display("%0s", label);

            if (use_bin) begin
                $display("A:        %b", A);
                $display("B:        %b", B);
                $display("Expected: %b", expected);
                $display("Result:   %b", Result);
            end else begin
                $display("A:        %d", A);
                $display("B:        %d", B);
                $display("Expected: %d", expected);
                $display("Result:   %d", Result);
            end

            $display("Flags: V(%b), N(%b), Zero(%b)", V, N, Zero);
            
            if (Result != expected) begin
                $display("❌ Test Failed! Expected: %0d, Got: %0d", expected, Result);

            // ADD ============================================================================================

            // Negative
            end else if (ALUControl == 3'b000 && A + B < 0 && N != 1) begin
                $display("❌ Test Failed! Expected N: 1, Got N: %0d", N);
            // Zero
            end else if (ALUControl == 3'b000 && A + B == 0 && Zero != 1) begin
                $display("❌ Test Failed! Expected Zero: 1, Got Zero: %0d", Zero);
            // Overflow
            end else if (ALUControl == 3'b000 && !(A[31] ^ B[31]) && (A[31] ^ Result[31]) && V != 1) begin
                $display("❌ Test Failed! Expected V: 1, Got V: %0d", V);

            // SUB ============================================================================================

            // Negative
            end else if (ALUControl == 3'b001 && A - B < 0 && N != 1) begin
                $display("❌ Test Failed! Expected N: 1, Got N: %0d", N);
            // Zero
            end else if (ALUControl == 3'b001 && A - B == 0 && Zero != 1) begin
                $display("❌ Test Failed! Expected Zero: 1, Got Zero: %0d", Zero);
            // Overflow
            end else if (ALUControl == 3'b001 && (A[31] ^ B[31]) && (A[31] ^ Result[31]) && V != 1) begin
                $display("❌ Test Failed! Expected V: 1, Got V: %0d", V);

            // PASS ============================================================================================
            end else begin
                $display("✅ Test Passed!");
            end
        end
    endtask

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // ADD +A +B
        ALUControl = 3'b000;
        A = 32'd124;
        B = 32'd73;
        #10
        assert_test("ADD +A +B", 124+73, 0);

        // ADD +A -B
        ALUControl = 3'b000;
        A = 32'd124;
        B = -32'd73;
        #10
        assert_test("ADD +A -B", 124+(-73), 0);

        // ADD -A -B
        ALUControl = 3'b000;
        A = -32'd124;
        B = -32'd73;
        #10
        assert_test("ADD -A -B", -124+(-73), 0);

        // SUB A > B
        A = 32'd124;
        B = 32'd73;
        ALUControl = 3'b001;
        #10
        assert_test("SUB A > B", 124-73, 0);

        // SUB A < B
        A = 32'd20;
        B = 32'd120;
        ALUControl = 3'b001;
        #10
        assert_test("SUB A < B", 20-120, 0);

        // SUB A == B
        A = 32'd124;
        B = 32'd124;
        ALUControl = 3'b001;
        #10
        assert_test("SUB A == B", 124-124, 0);

        // SUB A - (-B)
        A = 32'd20;
        B = -32'd120;
        ALUControl = 3'b001;
        #10
        assert_test("SUB A - (-B)", 20-(-120), 1);

        // SUB A - (-B)
        A = -32'd20;
        ALUControl = 3'b001;
        #10
        assert_test("SUB -A - (-B)", -20-(-120), 0);

        // AND
        A = 32'd124;
        B = 32'd73;
        ALUControl = 3'b010;
        #10
        assert_test("AND", 32'd124 & 32'd73, 1);

        // OR
        ALUControl = 3'b011;
        #10
        $display("OR Result: %0b", Result);
        assert_test("OR", 32'd124 | 32'd73, 1);

        // XOR
        ALUControl = 3'b100;
        #10
        $display("XOR Result: %0b", Result);
        assert_test("XOR", 32'd124 ^ 32'd73, 1);

        // SLL
        B = 5; 
        ALUControl = 3'b101;
        #10
        assert_test("SLL", 32'd124 << 5, 1);

        // SRL
        ALUControl = 3'b110;
        #10
        assert_test("SRL", 32'd124 >> 5, 1);

        // A LESS THAN B
        A = -32'd50;
        B = -32'd36;
        ALUControl = 3'b111;
        #10
        assert_test("SLT", 1, 0);

        // A GREATER THAN B
        A = 32'd50;
        B = -32'd36;
        ALUControl = 3'b111;
        #10
        assert_test("SLT", 0, 0);

        // A EUQAL B
        A = 32'd50;
        B = 32'd50;
        ALUControl = 3'b111;
        #10
        assert_test("SLT", 0, 0);

        // OVERFLOW V ADD +A +B
        A = 32'h7FFFFFFF;
        B = 32'h7FFFFFFF;
        ALUControl = 3'b000;
        #10
        assert_test("V ADD +A +B", 32'h7FFFFFFF+32'h7FFFFFFF, 1);

        // OVERFLOW V ADD -A -B
        A = 32'h80000000;
        B = 32'hAAAAAAAA;
        ALUControl = 3'b000;
        #10
        assert_test("V ADD -A -B", 32'h80000000+32'hAAAAAAAA, 1);

        // OVERFLOW V SUB +A -B => A-(-B) => A+B
        A = 32'h0FFFFFFF;
        B = 32'h8FFFFFFF;
        ALUControl = 3'b001;
        #10
        assert_test("V SUB +A -B", 32'h0FFFFFFF-32'h8FFFFFFF, 1);

        // OVERFLOW V SUB -A +B => -A-B => (-A) + (-B)
        A = 32'h8FFFFFFF;
        B = 32'h7FFFFFFF;
        ALUControl = 3'b001;
        #10
        assert_test("V SUB -A +B", 32'h8FFFFFFF-32'h7FFFFFFF, 1);

        $finish;
    end
endmodule