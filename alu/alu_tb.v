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
            end else if (A - B < 0 && N != 1) begin
                $display("❌ Test Failed! Expected N: 1, Got N: %0d", N);
            end else if (A - B == 0 && Zero != 1) begin
                $display("❌ Test Failed! Expected Zero: 1, Got Zero: %0d", Zero);
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
        assert_test("SUB A - (-B)", 20-(-120), 0);

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
        $display("==================================================");
        $display("AND Result: %0b", Result);

        // OR
        ALUControl = 3'b011;
        #10
        $display("OR Result: %0b", Result);

        // XOR
        ALUControl = 3'b100;
        #10
        $display("XOR Result: %0b", Result);

        // SHIFT LEFT LOGICAL
        ALUControl = 3'b101;
        #10
        $display("SLL Result: %0b", Result);

        // SHIFT RIGHT LOGICAL
        ALUControl = 3'b110;
        #10
        $display("SRL Result: %0b", Result);

        // A LESS THAN B
        ALUControl = 3'b111;
        #10
        $display("SLT Result: %0b", Result);

        $finish;
    end
endmodule