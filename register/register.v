module register (
    input [31:0] d,
    input clk,
    output reg [31:0] q
);
    // Initialize register to zero on start
    initial q = 32'h00000000;

    // Update q on positive edge of clock
    always @ (posedge clk) begin
        q <= d;
    end
endmodule