module alu_tb ();
    // test inputs
    reg [31:0] A, B;
    reg [2:0] ALUControl;

    // test outputs
    wire [31:0] Result;

    alu uut(
        A,
        B,
        ALUControl,
        Result
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        ALUControl = 3'b000;
        A = 32'd1;
        B = 32'd2;
        #10

        $display("ALU Result: %0d", Result);

        $finish;
    end
endmodule