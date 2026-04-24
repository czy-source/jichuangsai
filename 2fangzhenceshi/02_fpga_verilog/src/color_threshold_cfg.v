`timescale 1ns / 1ps

module color_threshold_cfg (
    input  wire       clk,
    input  wire       rst_n,

    input  wire       in_vsync,
    input  wire       in_hsync,
    input  wire       in_en,
    input  wire [7:0] hsv_h,
    input  wire [7:0] hsv_s,
    input  wire [7:0] hsv_v,

    input  wire [7:0] th_v_black,
    input  wire [7:0] th_s_white,
    input  wire [7:0] th_v_white,
    input  wire [7:0] th_s_color,
    input  wire [7:0] th_v_color,

    input  wire [7:0] h_red_lo,
    input  wire [7:0] h_red_hi,
    input  wire [7:0] h_blue_lo,
    input  wire [7:0] h_blue_hi,
    input  wire [7:0] h_yel_lo,
    input  wire [7:0] h_yel_hi,

    output reg        out_vsync,
    output reg        out_hsync,
    output reg        out_en,
    output reg [2:0]  color_id
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_vsync <= 1'b0;
            out_hsync <= 1'b0;
            out_en    <= 1'b0;
            color_id  <= 3'd0;
        end else begin
            out_vsync <= in_vsync;
            out_hsync <= in_hsync;
            out_en    <= in_en;

            if (in_en) begin
                if (hsv_v < th_v_black) begin
                    color_id <= 3'd4; // black
                end else if ((hsv_s < th_s_white) && (hsv_v > th_v_white)) begin
                    color_id <= 3'd5; // white
                end else if (((hsv_h <= h_red_lo) || (hsv_h >= h_red_hi)) &&
                             (hsv_s > th_s_color) && (hsv_v > th_v_color)) begin
                    color_id <= 3'd1; // red
                end else if ((hsv_h >= h_blue_lo) && (hsv_h <= h_blue_hi) &&
                             (hsv_s > th_s_color) && (hsv_v > th_v_color)) begin
                    color_id <= 3'd2; // blue
                end else if ((hsv_h >= h_yel_lo) && (hsv_h <= h_yel_hi) &&
                             (hsv_s > th_s_color) && (hsv_v > th_v_color)) begin
                    color_id <= 3'd3; // yellow
                end else begin
                    color_id <= 3'd0;
                end
            end else begin
                color_id <= 3'd0;
            end
        end
    end

endmodule
