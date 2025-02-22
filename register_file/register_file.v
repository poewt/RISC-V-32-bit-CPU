module register_file (
    input CLK, CLR, WE3,
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    output  [31:0] RD1, RD2
);
    // Instantiate an array of 32 32-bit registers
    reg [31:0] registers [31:0];

    // Initialize all registers to zero
    initial begin : init_regs
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'd0;
        end
    end

    // Continuously assign reads based on A1 and A2 bit values
    assign RD1 = registers[A1];
    assign RD2 = registers[A2];

    // Logic happens on every positive edge of the clock
    always @ (posedge CLK) begin
        // Synchronus reset is prefered
        if (CLR) begin : reset_cycle
            // Reset all registers on clear
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (WE3 == 1'b1 && A3 != 5'd0) begin
            // Write if write enabled and not r0
            registers[A3] <= WD3; // Access register directly using A3 as the index
        end
    end
endmodule