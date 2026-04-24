`timescale 1ns / 1ps

module color_stats (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        in_vsync,
    input  wire        in_en,
    input  wire [2:0]  color_id,
    input  wire [15:0] x,
    input  wire [15:0] y,
    input  wire [2:0]  target_color,

    output reg  [31:0] area,
    output reg  [15:0] centroid_x,
    output reg  [15:0] centroid_y,
    output reg  [15:0] xmin,
    output reg  [15:0] xmax,
    output reg  [15:0] ymin,
    output reg  [15:0] ymax,
    output reg         frame_done
);

    reg vs_d;
    wire vs_rise = in_vsync & ~vs_d;

    reg [31:0] sum_x, sum_y, cnt;
    reg [15:0] xmin_acc, xmax_acc, ymin_acc, ymax_acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vs_d <= 1'b0;
            sum_x <= 32'd0;
            sum_y <= 32'd0;
            cnt   <= 32'd0;
            xmin_acc <= 16'hFFFF; xmax_acc <= 16'd0;
            ymin_acc <= 16'hFFFF; ymax_acc <= 16'd0;

            area <= 32'd0;
            centroid_x <= 16'd0; centroid_y <= 16'd0;
            xmin <= 16'hFFFF; xmax <= 16'd0;
            ymin <= 16'hFFFF; ymax <= 16'd0;
            frame_done <= 1'b0;
        end else begin
            vs_d <= in_vsync;
            frame_done <= 1'b0;

            if (vs_rise) begin
                area <= cnt;
                if (cnt != 0) begin
                    centroid_x <= sum_x / cnt;
                    centroid_y <= sum_y / cnt;
                end else begin
                    centroid_x <= 16'd0;
                    centroid_y <= 16'd0;
                end
                xmin <= xmin_acc; xmax <= xmax_acc;
                ymin <= ymin_acc; ymax <= ymax_acc;
                frame_done <= 1'b1;

                sum_x <= 32'd0;
                sum_y <= 32'd0;
                cnt   <= 32'd0;
                xmin_acc <= 16'hFFFF; xmax_acc <= 16'd0;
                ymin_acc <= 16'hFFFF; ymax_acc <= 16'd0;
            end else if (in_en && (color_id == target_color)) begin
                cnt   <= cnt + 32'd1;
                sum_x <= sum_x + x;
                sum_y <= sum_y + y;
                if (x < xmin_acc) xmin_acc <= x;
                if (x > xmax_acc) xmax_acc <= x;
                if (y < ymin_acc) ymin_acc <= y;
                if (y > ymax_acc) ymax_acc <= y;
            end
        end
    end

endmodule
