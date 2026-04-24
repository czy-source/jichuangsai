`timescale 1ns / 1ps

// Top-level integration:
// MIPI CSI-2 packetized byte stream -> capture bridge -> existing vision pipeline
module vision_mipi_top (
    input  wire       clk,
    input  wire       rst_n,

    // From MIPI CSI-2 RX front-end (packetized byte stream)
    input  wire       csi_pkt_valid,
    input  wire [7:0] csi_pkt_data,
    input  wire       csi_pkt_start,
    input  wire       csi_pkt_end,

    output wire [2:0] color_id,
    output wire       color_en,

    output wire       frame_done,
    output wire [31:0] area,
    output wire [15:0] centroid_x,
    output wire [15:0] centroid_y,
    output wire [15:0] xmin,
    output wire [15:0] xmax,
    output wire [15:0] ymin,
    output wire [15:0] ymax,

    output wire       shape_valid,
    output wire [1:0] shape_id,
    output wire       size_valid,
    output wire [1:0] size_id,

    output wire       mipi_frame_active,
    output wire [15:0] mipi_dropped_payload_packets
);

    parameter [2:0] TARGET_COLOR = 3'd1;
    parameter [5:0] MIPI_DT_RGB888 = 6'h24;

    wire        in_vsync;
    wire        in_hsync;
    wire        in_en;
    wire [7:0]  in_data;

    mipi_csi2_capture_bridge #(
        .DT_RGB888(MIPI_DT_RGB888)
    ) u_mipi_bridge (
        .clk(clk),
        .rst_n(rst_n),
        .in_pkt_valid(csi_pkt_valid),
        .in_pkt_data(csi_pkt_data),
        .in_pkt_start(csi_pkt_start),
        .in_pkt_end(csi_pkt_end),
        .out_vsync(in_vsync),
        .out_hsync(in_hsync),
        .out_en(in_en),
        .out_data(in_data),
        .frame_active(mipi_frame_active),
        .dropped_payload_packets(mipi_dropped_payload_packets)
    );

    vision_top #(
        .TARGET_COLOR(TARGET_COLOR)
    ) u_vision (
        .clk(clk),
        .rst_n(rst_n),
        .in_vsync(in_vsync),
        .in_hsync(in_hsync),
        .in_en(in_en),
        .in_data(in_data),
        .color_id(color_id),
        .color_en(color_en),
        .frame_done(frame_done),
        .area(area),
        .centroid_x(centroid_x),
        .centroid_y(centroid_y),
        .xmin(xmin),
        .xmax(xmax),
        .ymin(ymin),
        .ymax(ymax),
        .shape_valid(shape_valid),
        .shape_id(shape_id),
        .size_valid(size_valid),
        .size_id(size_id)
    );

endmodule

