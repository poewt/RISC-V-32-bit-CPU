module pc (
    input clk, reset,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk) begin
        pc_out <= (reset == 1) ? 32'd0 : pc_in;
    end
endmodule