`timescale 1ns/1ps

module register_file (
    input clk, writeEn,
    input [1:0] writeSel,
    input [31:0] writeData,
    output  [31:0] readData1
);
    // Temp loop var
    genvar i;

    
    // todo - find how to select which register gets written to


    // todo - find how to select which register gets read

    // OR - perhaps implement the 32 registers directly into register_file as an array of arrays

    // Instantiate 4 registers
    generate
        for (i = 0; i < 4; i = i + 1) begin
            register u0 (writeData, clk, writeEn, readData1);
        end
    endgenerate
endmodule