`timescale 1ns / 1ps

module half_region_counter (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        in_vsync,
    input  wire        in_en,
    input  wire [15:0] in_x,
    input  wire [15:0] in_y,
    input  wire [2:0]  color_id,
    input  wire [2:0]  target_color,
    input  wire [15:0] ymin,
    input  wire [15:0] ymax,
    input  wire        frame_done, // latch control (from color_stats)

    output reg [31:0]  upper_cnt,
    output reg [31:0]  lower_cnt
);

    reg [31:0] upper_acc, lower_acc;
    reg [15:0] ymin_latched, ymax_latched;
    wire [15:0] y_mid = (ymin_latched + ymax_latched) >> 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            upper_acc    <= 32'd0;
            lower_acc    <= 32'd0;
            upper_cnt    <= 32'd0;
            lower_cnt    <= 32'd0;
            ymin_latched <= 16'd50; // 默认图像中线
            ymax_latched <= 16'd50;
        end else begin
            if (in_en && color_id == target_color) begin
                if (in_y <= y_mid) upper_acc <= upper_acc + 32'd1;
                else               lower_acc <= lower_acc + 32'd1;
            end

            if (frame_done) begin
                upper_cnt <= upper_acc;
                lower_cnt <= lower_acc;
                upper_acc <= 32'd0;
                lower_acc <= 32'd0;
                // 只有当前帧有有效目标时才更新 ymin/ymax
                // 避免空帧（ymin=65535, ymax=0）污染下一帧统计
                if (ymin <= ymax) begin
                    ymin_latched <= ymin;
                    ymax_latched <= ymax;
                end
            end
        end
    end

endmodule
