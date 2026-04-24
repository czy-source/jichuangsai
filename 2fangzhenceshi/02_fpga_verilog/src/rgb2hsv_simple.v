`timescale 1ns / 1ps

module rgb2hsv_simple (
    input  wire       clk,
    input  wire       rst_n,

    input  wire       in_vsync,
    input  wire       in_hsync,
    input  wire       in_en,
    input  wire [7:0] in_r,
    input  wire [7:0] in_g,
    input  wire [7:0] in_b,

    output reg        out_vsync,
    output reg        out_hsync,
    output reg        out_en,
    output reg [7:0]  out_h,
    output reg [7:0]  out_s,
    output reg [7:0]  out_v
);

    integer h_deg;
    reg [7:0] maxv, minv, d;
    reg [15:0] tmp16;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_vsync <= 1'b0;
            out_hsync <= 1'b0;
            out_en    <= 1'b0;
            out_h     <= 8'd0;
            out_s     <= 8'd0;
            out_v     <= 8'd0;
        end else begin
            out_vsync <= in_vsync;
            out_hsync <= in_hsync;
            out_en    <= in_en;

            if (in_en) begin
                maxv = (in_r >= in_g) ? ((in_r >= in_b) ? in_r : in_b)
                                      : ((in_g >= in_b) ? in_g : in_b);
                minv = (in_r <= in_g) ? ((in_r <= in_b) ? in_r : in_b)
                                      : ((in_g <= in_b) ? in_g : in_b);
                d    = maxv - minv;

                out_v <= maxv;

                if (maxv == 0) out_s <= 8'd0;
                else begin
                    tmp16 = (d * 16'd255) / maxv;
                    out_s <= tmp16[7:0];
                end

                if (d == 0) begin
                    out_h <= 8'd0;
                end else begin
                    if (maxv == in_r) begin
                        if (in_g >= in_b) h_deg = (60 * (in_g - in_b)) / d;
                        else              h_deg = 360 - (60 * (in_b - in_g)) / d;
                    end else if (maxv == in_g) begin
                        if (in_b >= in_r) h_deg = 120 + (60 * (in_b - in_r)) / d;
                        else              h_deg = 120 - (60 * (in_r - in_b)) / d;
                    end else begin
                        if (in_r >= in_g) h_deg = 240 + (60 * (in_r - in_g)) / d;
                        else              h_deg = 240 - (60 * (in_g - in_r)) / d;
                    end
                    tmp16 = (h_deg * 16'd255) / 360;
                    out_h <= tmp16[7:0];
                end
            end else begin
                out_h <= 8'd0;
                out_s <= 8'd0;
                out_v <= 8'd0;
            end
        end
    end

endmodule
