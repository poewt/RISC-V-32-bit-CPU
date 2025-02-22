module register_file_tb ();
    // Test inputs
    reg CLK, CLR, WE3;
    reg [4:0] A1, A2, A3;
    reg [31:0] WD3;

    // Test outputs
    wire [31:0] RD1, RD2;

    // Instantiate unit under test
    register_file uut (
        CLK,
        CLR,
        WE3,
        A1,
        A2,
        A3,
        WD3,
        RD1,
        RD2
    );

    // Clock gen | clock flips every 5 ns
    always #5 CLK = ~CLK;

    initial begin
        // Create waveform file for debugging
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);

        // Case 1 : Initialize clock, reset, and control signals
        CLK = 0;
        CLR = 1;
        WE3 = 0;
        WD3 = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        #10
        if (RD1 != 32'h00000000 || RD2 != 32'h00000000)
            $display("Case 1 : FAIL");
        else
            $display("Case 1 : PASS");

        // Disable clear
        CLR = 0;
        #10

        // Case 2 : Write disabled, attempt write (should not change register content)
        WE3 = 0;
        A3 = 5'd4;
        WD3 = 32'hABCDEF0;
        A2 = 5'd4;
        #10
        if (RD2 == 32'hABCDEF0)
            $display("Case 2 : FAIL");
        else
            $display("Case 2 : PASS");

        // Case 3 : Write enabled, write to register 4
        WE3 = 1;
        #10
        if (RD2 != 32'hABCDEF0)
            $display("Case 3 : FAIL");
        else
            $display("Case 3 : PASS");

        // Case 4 : Read back register 4
        A1 = 5'd4;
        #10
        if (RD1 != 32'hABCDEF0)
            $display("Case 4 : FAIL");
        else
            $display("Case 4 : PASS");

        // Write to register 1
        A3 = 5'd1;
        WD3 = 32'hDEADBEEF;
        #10

        // Case 5 : Read R1 after write
        A1 = 5'd1;
        #10
        if (RD1 != 32'hDEADBEEF)
            $display("Case 5 : FAIL");
        else
            $display("Case 5 : PASS");

        // Attempt write to register 0 (should remain 0)
        A3 = 5'd0;
        WD3 = 32'hFFFFFFFF;
        #10

        // Case 6 : Read register 0 (should be 0)
        A1 = 5'd0;
        #10
        if (RD1 == 32'hFFFFFFFF)
            $display("Case 6 : FAIL");
        else
            $display("Case 6 : PASS");

        // Case 7 : Change read registers while writing to another
        A1 = 5'd1;
        A2 = 5'd4;
        A3 = 5'd10;
        WD3 = 32'h12345678;
        #10
        if (RD1 != 32'hDEADBEEF || RD2 != 32'hABCDEF0)
            $display("Case 7 : FAIL");
        else
            $display("Case 7 : PASS");

        // Case 8 : Write to the same register twice
        A3 = 5'd2;
        WD3 = 32'hAAAA5555;
        #10
        WD3 = 32'h5555AAAA;
        #10
        A1 = 5'd2;
        #10
        if (RD1 != 32'h5555AAAA)
            $display("Case 8 : FAIL");
        else
            $display("Case 8 : PASS");

        // Case 9 : Immediate read after write (may fail if no write-through)
        A3 = 5'd3;
        WD3 = 32'hCAFEBABE;
        #10
        A1 = 5'd3;
        if (RD1 != 32'hCAFEBABE)
            $display("Case 9 : FAIL (No write-through or delay)");
        else
            $display("Case 9 : PASS");

        // Case 10 : Read from two different registers
        A1 = 5'd1;
        A2 = 5'd3;
        #10
        if (RD1 != 32'hDEADBEEF || RD2 != 32'hCAFEBABE)
            $display("Case 10 : FAIL");
        else
            $display("Case 10 : PASS");

        // Case 11 : Disable write, attempt to write, and verify no change
        WE3 = 0;
        A3 = 5'd5;
        WD3 = 32'hBEEFBEEF;
        #10
        A1 = 5'd5;
        #10
        if (RD1 == 32'hBEEFBEEF)
            $display("Case 11 : FAIL");
        else
            $display("Case 11 : PASS");

        // Case 12 : Reset after writing
        WE3 = 1;
        A3 = 5'd6;
        WD3 = 32'h11223344;
        #10
        CLR = 1;
        #10 // Allow time for RD1 to reflect the reset
        A1 = 5'd6;

        if (RD1 != 32'h00000000)
            $display("Case 12 : FAIL");
        else
            $display("Case 12 : PASS");

        $finish;
    end
endmodule