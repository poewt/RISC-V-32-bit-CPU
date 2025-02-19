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
        // Create waveform file
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);

        // Initialize clock, write enable, and select signals

        // 1. Initialize default no write
        CLK = 0;
        CLR = 1;
        WE3 = 0;
        WD3 = 32'd0;
        A1 = 5'd0;
        A2 = 5'd0;
        A3 = 5'd0;
        @(posedge CLK) // wait for one clock cycle low->high

        // // Reset clear
        CLR = 0;
        @(posedge CLK)

        // 2. Case: Write disabled, new write data
        WD3 = 32'hABCDEF0;
        @(posedge CLK)

        // 3. Case: Write enabled, write pointing to r0
        WE3 = 1;
        @(posedge CLK)

        // 4. Case: Write towards r1
        A3 = 5'b00001;
        @(posedge CLK)

        // 5. Case: Read towards r1 at 1
        A1 = 5'b00001;
        @(posedge CLK)

        // 6. Case: Write to r4, new write data, read r4 at 2
        WD3 = 32'hFFFFFFFF;
        A3 = 5'b00100;
        A2 = 5'b00100;
        @(posedge CLK)

        // 7. Disable write
        WE3 = 0;
        @(posedge CLK)

        $finish;
    end
endmodule