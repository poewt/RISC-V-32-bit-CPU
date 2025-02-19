module register_file_tb ();
    // Test inputs
    reg CLK, WE3;
    reg [4:0] A1, A2, A3;
    reg [31:0] WD3;

    // Test outputs
    wire [31:0] RD1, RD2;

    // Instantiate unit under test
    register_file uut (
        CLK,
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

        // 1. Nothing being written, default read/write select
        CLK = 0;
        WE3 = 0;
        WD3 = 32'h00000000;
        A1 = 5'b00000;
        A2 = 5'b00000;
        A3 = 5'b00000;
        @(posedge CLK) // wait for one clock cycle low->high

        // 2. Assign write data despite no enable
        WD3 = 32'hABCDEF0;
        @(posedge CLK)

        // 3. Enable write data, should not update due to r0 select
        WE3 = 1;
        @(posedge CLK)

        // 4. Change write select to r1
        A3 = 5'b00001;
        @(posedge CLK)

        // 5. Change read select 1
        A1 = 5'b00001;
        @(posedge CLK)

        // 6. Change write select to r4, change write data, change read 2
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