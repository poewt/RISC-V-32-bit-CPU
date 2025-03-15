module pc_tb;

    reg clk;
    reg reset;
    reg [31:0] pc_in;
    wire [31:0] pc_out;
    
    // Instantiate the PC module
    pc dut (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );
    
    // Clock process
    always #5 clk <= ~clk;
    
    // Test process
    initial begin
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, pc_tb);

        clk = 1;

        reset = 1; #10;
        if (pc_out != 32'h00000000)
            $display("Test Reset : FAIL");
        else
            $display("Test Reset: PASS");

        reset = 0; #10;
        
        pc_in = 32'h00000004; #10;
        if (pc_out != 32'h00000004)
            $display("Test 1 : FAIL");
        else
            $display("Test 1 : PASS");

        pc_in = 32'h00000008; #10;
        if (pc_out != 32'h00000008)
            $display("Test 2 : FAIL");
        else
            $display("Test 2 : PASS");

        pc_in = 32'h0000000C; #10;
        if (pc_out != 32'h0000000C)
            $display("Test 3 : FAIL");
        else
            $display("Test 3 : PASS");
        
        // Simulation finished
        $display("Simulation finished");
        $finish;
    end

endmodule
