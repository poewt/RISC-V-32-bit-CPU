`timescale 1ns/1ps

module register_tb ();
    // Test inputs
    reg [31:0] d;
    reg clk;
    reg en;

    // Output
    wire [31:0] q;

    // Instantiate unit under test (uut)
    register uut (
        d,
        clk,
        en,
        q
    );

    // Clock generation | every 5ns switch between high/low
    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_tb.vcd"); // Waveform
        $dumpvars(0, register_tb);

        // Initialize signals
        clk = 0;
        en = 0; // Disabled on start
        d = 32'h00000000;
        #10 // wait for one clock cycle low->high

        d = 32'hFFFFFFFF;
        #10

        d = 32'h0F0F0F0F;
        #10

        en = 1; // Enabled here
        d = 32'hFFFFFFFF;
        #10

        d = 32'h0F0F0F0F;
        #10

        d = 32'h00000000;
        #10

        $finish;
    end
endmodule