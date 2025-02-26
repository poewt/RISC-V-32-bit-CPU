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
        input signed [31:0] expected
    );
        begin
            $display("==================================================");
            $display("%0s", label);
            $display("A: %d", A);
            $display("B: %d", B);
            $display("Expected: %d", expected);
            $display("Result:   %d", Result);
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
        assert_test("ADD +A +B", 124+73);

        // SUB A > B
        ALUControl = 3'b001;
        #10
        assert_test("SUB A > B", 124-73);

        // SUB A < B
        A = 32'd20;
        B = 32'd120;
        ALUControl = 3'b001;
        #10
        assert_test("SUB A < B", 20-120);

        // SUB A == B
        A = 32'd124;
        B = 32'd124;
        ALUControl = 3'b001;
        #10
        assert_test("SUB A == B", 124-124);

        // AND
        ALUControl = 3'b010;
        #10
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