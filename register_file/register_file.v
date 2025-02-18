`timescale 1ns/1ps

module register_file (
    input CLK, WE3,
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
            registers[i] = 32'h00000000;
        end
    end

    // Continuously assign reads based on A1 and A2 bit values
    assign RD1 = registers[A1];
    assign RD2 = registers[A2];

    // Logic happens on every positive edge of the clock
    always @ (posedge CLK) begin
        // Write only if write enabled
        if (WE3 == 1'b1 && A3 != 5'b00000) begin
            // Access register directly using A3 as the index
            registers[A3] <= WD3;
        end
    end
endmodule