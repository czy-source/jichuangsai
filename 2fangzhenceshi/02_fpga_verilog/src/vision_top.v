`timescale 1ns / 1ps

module vision_top (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        in_vsync,
    input  wire        in_hsync,
    input  wire        in_en,
    input  wire [7:0]  in_data,      // RGB byte stream: R,G,B

    output wire [2:0]  color_id,
    output wire        color_en,

    output wire        frame_done,
    output wire [31:0] area,
    output wire [15:0] centroid_x,
    output wire [15:0] centroid_y,
    output wire [15:0] xmin,
    output wire [15:0] xmax,
    output wire [15:0] ymin,
    output wire [15:0] ymax,

    output wire        shape_valid,
    output wire [1:0]  shape_id,     // 0 unk,1 cube,2 cylinder,3 cone
    output wire        size_valid,
    output wire [1:0]  size_id       // 0 unk,1 2.0cm,2 2.5cm,3 3.0cm
);

    // -----------------------------
    // 1) 3-byte pack -> pixel
    // -----------------------------
    wire        p_vsync, p_hsync, p_en;
    wire [7:0]  p_r, p_g, p_b;

    rgb_packer_3byte u_pack (
        .clk(clk), .rst_n(rst_n),
        .in_vsync(in_vsync), .in_hsync(in_hsync), .in_en(in_en), .in_data(in_data),
        .pix_vsync(p_vsync), .pix_hsync(p_hsync), .pix_en(p_en),
        .pix_r(p_r), .pix_g(p_g), .pix_b(p_b)
    );

    // -----------------------------
    // 2) RGB -> HSV
    // -----------------------------
    wire        h_vsync, h_hsync, h_en;
    wire [7:0]  h_h, h_s, h_v;

    rgb2hsv_simple u_hsv (
        .clk(clk), .rst_n(rst_n),
        .in_vsync(p_vsync), .in_hsync(p_hsync), .in_en(p_en),
        .in_r(p_r), .in_g(p_g), .in_b(p_b),
        .out_vsync(h_vsync), .out_hsync(h_hsync), .out_en(h_en),
        .out_h(h_h), .out_s(h_s), .out_v(h_v)
    );

    // -----------------------------
    // 3) Color threshold
    // -----------------------------
    wire c_vsync, c_hsync, c_en;
    wire [2:0] c_id;

    color_threshold_cfg u_thr (
        .clk(clk), .rst_n(rst_n),
        .in_vsync(h_vsync), .in_hsync(h_hsync), .in_en(h_en),
        .hsv_h(h_h), .hsv_s(h_s), .hsv_v(h_v),

        .th_v_black(8'd50),
        .th_s_white(8'd50),
        .th_v_white(8'd200),
        .th_s_color(8'd80),
        .th_v_color(8'd50),

        .h_red_lo(8'd15),
        .h_red_hi(8'd240),
        .h_blue_lo(8'd140),
        .h_blue_hi(8'd180),
        .h_yel_lo(8'd25),
        .h_yel_hi(8'd50),

        .out_vsync(c_vsync), .out_hsync(c_hsync), .out_en(c_en), .color_id(c_id)
    );

    assign color_id = c_id;
    assign color_en = c_en;

    // -----------------------------
    // 4) XY counter
    // -----------------------------
    wire [15:0] x, y;
    xy_counter u_xy (
        .clk(clk), .rst_n(rst_n),
        .in_vsync(c_vsync), .in_hsync(c_hsync), .in_en(c_en),
        .x(x), .y(y)
    );

    // -----------------------------
    // 5) Color stats (target color = parameter)
    // -----------------------------
    parameter [2:0] TARGET_COLOR = 3'd1;

    color_stats u_stats (
        .clk(clk), .rst_n(rst_n),
        .in_vsync(c_vsync),
        .in_en(c_en),
        .color_id(c_id),
        .x(x), .y(y),
        .target_color(TARGET_COLOR),
        .area(area),
        .centroid_x(centroid_x),
        .centroid_y(centroid_y),
        .xmin(xmin), .xmax(xmax), .ymin(ymin), .ymax(ymax),
        .frame_done(frame_done)
    );

    // -----------------------------
    // 6) Shape classify (use area+bbox+half stats)
    // For simplicity, derive upper/lower by y vs bbox mid and color mask
    // -----------------------------
    wire [31:0] upper_cnt, lower_cnt;

    half_region_counter u_half (
        .clk(clk), .rst_n(rst_n),
        .in_vsync(c_vsync), .in_en(c_en),
        .in_x(x), .in_y(y),
        .color_id(c_id), .target_color(TARGET_COLOR),
        .ymin(ymin), .ymax(ymax),
        .frame_done(frame_done),
        .upper_cnt(upper_cnt),
        .lower_cnt(lower_cnt)
    );

    shape_classify u_shape (
        .clk(clk), .rst_n(rst_n),
        .in_valid(frame_done),
        .area(area),
        .xmin(xmin), .xmax(xmax), .ymin(ymin), .ymax(ymax),
        .upper_cnt(upper_cnt), .lower_cnt(lower_cnt),
        .out_valid(shape_valid),
        .shape_id(shape_id)
    );

    // -----------------------------
    // 7) Size classify by area threshold
    // -----------------------------
    size_classify u_size (
        .clk(clk), .rst_n(rst_n),
        .in_valid(frame_done),
        .area(area),
        .th_2p0_max(32'd1200),
        .th_2p5_max(32'd2200),
        .th_3p0_max(32'd3600),
        .out_valid(size_valid),
        .size_id(size_id)
    );

endmodule
