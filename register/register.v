module register (
    input [31:0] d,
    input clk, en,
    output reg [31:0] q
);
    // Initialize register to zero on start
    initial q = 32'h00000000;

    // Update q on positive edge of clock
    always @ (posedge clk) begin
        if (en == 1'b1) q <= d;
    end
endmodule