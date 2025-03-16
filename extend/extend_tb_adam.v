`timescale 1ns / 1ps

module extend_tb;

    // Constants
    localparam [2:0] I_Type = 3'b000;
    localparam [2:0] S_Type = 3'b001;
    localparam [2:0] B_Type = 3'b010;
    localparam [2:0] U_Type = 3'b011;
    localparam [2:0] J_Type = 3'b100;

    // Signals
    reg [31:7] imm = 25'b0;
    reg [2:0] immSrc = 3'b0;
    wire [31:0] immExt;

    // Instantiate Extend module
    extend uut (
        .imm_in(imm),
        .extend_ctrl(immSrc),
        .imm_out(immExt)
    );

    initial begin

        // Case 1: I_Type: ADDI x5, x1, -10
        immSrc = I_Type;
        imm = {12'b111111110110, 13'b0000100000101};
        #10;
        if ($signed(immExt) !== -10) $error("Case 1: Failed");
        else $display("Case 1: Pass");

        // Case 2: S_Type: SW x6, -52
        immSrc = S_Type;
        imm = {7'b1111110, 5'b00110, 5'b00010, 3'b010, 5'b01100};
        #10;
        if ($signed(immExt) !== -52) $error("Case 2: Failed");
        else $display("Case 2: Pass");

        // Case 3: J_Type: JAL x1, 1024
        immSrc = J_Type;
        imm = {1'b0, 10'b1000000000, 1'b0, 8'b00000000, 5'b00001};
        #10;
        if ($signed(immExt) !== 1024) $error("Case 3: Failed");
        else $display("Case 3: Pass");

        // Case 4: B_Type: BEQ x3, x4, -16
        immSrc = B_Type;
        imm = {1'b1, 6'b111111, 5'b00100, 5'b00011, 3'b000, 4'b1000, 1'b1};
        #10;
        if ($signed(immExt) !== -16) $error("Case 4: Failed");
        else $display("Case 4: Pass");

        // Case 5: U_Type: LUI x7, 0x12345
        immSrc = U_Type;
        imm = {20'h12345, 5'b00111};
        #10;
        if (immExt !== 32'h12345000) $error("Case 5: Failed");
        else $display("Case 5: Pass");

        $display("Test Bench Complete");
        $finish;
    end

endmodule
