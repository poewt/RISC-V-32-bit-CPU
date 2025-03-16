module extend_tb ();
    reg [24:0] imm_in;
    reg [2:0] extend_ctrl;
    wire [31:0] imm_out;

    extend uut(
        imm_in,
        extend_ctrl,
        imm_out
    );

    task assert_test(
        input [127:0] label,
        input [24:0] imm_in,
        input [31:0] imm_out,
        input [31:0] expected
    ); begin
        $display("============================================");
        $display("Imm In  : %b", imm_in);
        $display("Imm Out : %b", imm_out);
        $display("Expected: %b", expected);
        if (imm_out != expected)
            $display("%0s: FAIL", label);
        else
            $display("%0s: PASS", label);
        $display("============================================");
        end
    endtask

    // ! SAFE TEST BENCHES 

    initial begin
        $dumpfile("extend_tb.vcd");
        $dumpvars(0, extend_tb);

        // Test cases (imm_in is only bits [31:7] of the instruction)

        // Case I-Type (Immediate Type - 20 Bit Sign Extension + Bits 31 to 20)
        imm_in = 25'b000000000000_0111111111111; extend_ctrl = 3'b000; #10;
        assert_test("I-TYPE", imm_in, imm_out, { 20'b0, 12'b000000000000});

        // Case I-Type (Immediate Type - 20 Bit Sign Extension + Bits 31 to 20)
        imm_in = 25'b011111111111_1111111111111; #10;
        assert_test("I-TYPE", imm_in, imm_out, { 20'b0, 12'b011111111111});

        // Case I-Type (Immediate Type - 20 Bit Sign Extension + Bits 31 to 20)
        imm_in = 25'b100111111111_1111111111111; #10; // Negative case (MSB = 1)
        assert_test("I-TYPE", imm_in, imm_out, { ~20'b0, 12'b100111111111});

        // Case S-Type (Store Type - 13 Bit Sign Extension +  Bits 31 to 25 + Bits 11 to 7)
        imm_in = 25'b0000000_0000001111111_11111; extend_ctrl = 3'b001; #10;
        assert_test("S-TYPE", imm_in, imm_out, { 
            13'b0, // Sign extension
            7'b0000000, // Bits 31 to 25
            5'b11111 // Bits 11 to 7
        });

        // Case B-Type (Branch Type - 19 Bit Sign Extension + Bit 31 + Bit 7 + Bits 30 to 25 + Bits 11 to 8 + 0)
        imm_in = 25'b0_000000_0000001111111_1111_1; extend_ctrl = 3'b010; #10;
        assert_test("B-TYPE", imm_in, imm_out, {
            19'b0, // Sign extension
            1'b0, // Bit 31
            1'b1, // Bit 7
            6'b000000, // Bits 30 to 25
            4'b1111, // Bits 11 to 8
            1'b0 // 0 for word alignment
        });

        // Case U-Type (Upper Immediate Type - Upper Bits 31 to 12 + Lower Extended 0s)
        imm_in = 25'b00000000000001111111_11111; extend_ctrl = 3'b011; #10;
        assert_test("U-TYPE", imm_in, imm_out, {
            20'b00000000000001111111, // Upper Bits 31 to 12
            12'b0 // Lower Extended Zeros
        });

        // todo Case J-Type (Jump Type - 11 Bit Sign Extension + Bit 31 + Bits 19 to 12 + Bit 20 + Bits 30 to 21 + 0)
        imm_in = 25'b0_0000000000_0_01111111_11111; extend_ctrl = 3'b100; #10;
        assert_test("J-TYPE", imm_in, imm_out, {
            11'b0, // Sign extension
            1'b0, // Bit 31
            8'b01111111, // Bits 19 to 12
            1'b0, // Bit 20
            10'b0000000000, // Bits 30 to 21
            1'b0 // 0 for word alignment
        });

        $finish;
    end

endmodule