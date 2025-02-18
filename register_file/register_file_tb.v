module register_file_tb ();
    // Test inputs
    reg clk, writeEn;
    reg [31:0] writeData;
    reg [1:0] writeSel;

    // Test outpus
    wire [31:0] readData1;

    // Instantiate unit under test
    register_file uut (
        clk,
        writeEn,
        writeSel,
        writeData,
        readData1
    );

    // Clock gen
    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);

        // Initialize clock and write enable signals
        clk = 0;
        writeEn = 1;

        writeData = 32'h00000000;
        #10 // wait for one clock cycle low->high

        writeData = 32'hFFFFFFFF;
        #10

        writeData = 32'h0F0F0F0F;
        #10

        writeEn = 1; // Enabled here

        writeData = 32'hFFFFFFFF;
        #10

        writeData = 32'h0F0F0F0F;
        #10

        writeData = 32'h00000000;
        #10

        $finish;
    end
endmodule