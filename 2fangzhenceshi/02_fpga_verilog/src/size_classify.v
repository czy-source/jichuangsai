`timescale 1ns / 1ps

module size_classify (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        in_valid,
    input  wire [31:0] area,
    input  wire [31:0] th_2p0_max,
    input  wire [31:0] th_2p5_max,
    input  wire [31:0] th_3p0_max,
    output reg         out_valid,
    output reg [1:0]   size_id
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_valid <= 1'b0;
            size_id   <= 2'd0;
        end else begin
            out_valid <= 1'b0;
            if (in_valid) begin
                out_valid <= 1'b1;
                if (area <= th_2p0_max)      size_id <= 2'd1;
                else if (area <= th_2p5_max) size_id <= 2'd2;
                else if (area <= th_3p0_max) size_id <= 2'd3;
                else                          size_id <= 2'd0;
            end
        end
    end

endmodule
