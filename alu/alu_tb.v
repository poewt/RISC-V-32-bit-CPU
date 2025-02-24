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

        // ADD
        ALUControl = 3'b000;
        A = 32'd124;
        B = 32'd73;
        $display("A: %b", A);
        $display("B: %b", B);
        #10
        $display("ADD Result: %0b", Result);

        // SUB
        ALUControl = 3'b001;
        #10
        $display("SUB Result: %0b", Result);

        // AND
        ALUControl = 3'b010;
        #10
        $display("AND Result: %0b", Result);

        // OR
        ALUControl = 3'b011;
        #10
        $display("OR Result: %0b", Result);

        // XOR
        ALUControl = 3'b100;
        #10
        $display("XOR Result: %0b", Result);

        // SHIFT LEFT LOGICAL
        ALUControl = 3'b101;
        #10
        $display("SLL Result: %0b", Result);

        // SHIFT RIGHT LOGICAL
        ALUControl = 3'b110;
        #10
        $display("SRL Result: %0b", Result);

        // A LESS THAN B
        ALUControl = 3'b111;
        #10
        $display("SLT Result: %0b", Result);

        $finish;
    end
endmodule