`timescale 1ns / 1ps

module xy_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       in_vsync,
    input  wire       in_hsync,
    input  wire       in_en,
    output reg [15:0] x,
    output reg [15:0] y
);

    reg vs_d, hs_d;
    wire vs_rise = in_vsync & ~vs_d;
    wire hs_rise = in_hsync & ~hs_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vs_d <= 1'b0;
            hs_d <= 1'b0;
        end else begin
            vs_d <= in_vsync;
            hs_d <= in_hsync;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x <= 16'd0;
            y <= 16'd0;
        end else begin
            if (vs_rise) begin
                x <= 16'd0;
                y <= 16'd0;
            end else if (hs_rise) begin
                x <= 16'd0;
                y <= y + 16'd1;
            end else if (in_en) begin
                x <= x + 16'd1;
            end
        end
    end

endmodule
