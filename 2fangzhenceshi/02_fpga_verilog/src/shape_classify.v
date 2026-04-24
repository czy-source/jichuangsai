`timescale 1ns / 1ps

module shape_classify (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        in_valid,
    input  wire [31:0] area,
    input  wire [15:0] xmin,
    input  wire [15:0] xmax,
    input  wire [15:0] ymin,
    input  wire [15:0] ymax,
    input  wire [31:0] upper_cnt,
    input  wire [31:0] lower_cnt,

    output reg         out_valid,
    output reg [1:0]   shape_id
);

    reg [15:0] w, h;
    reg [31:0] box_area;
    reg in_valid_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            in_valid_d <= 1'b0;
        end else begin
            in_valid_d <= in_valid;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_valid <= 1'b0;
            shape_id  <= 2'd0;
            w <= 16'd0; h <= 16'd0; box_area <= 32'd0;
        end else begin
            out_valid <= 1'b0;
            if (in_valid_d) begin
                out_valid <= 1'b1;

                // 用阻塞赋值在同一拍内立即算出当前值，避免读到上一拍旧值
                if (xmax >= xmin) w = xmax - xmin + 16'd1;
                else              w = 16'd0;

                if (ymax >= ymin) h = ymax - ymin + 16'd1;
                else              h = 16'd0;

                if ((xmax >= xmin) && (ymax >= ymin))
                    box_area = (xmax - xmin + 16'd1) * (ymax - ymin + 16'd1);
                else
                    box_area = 32'd0;

                if (area < 32'd20) begin
                    shape_id <= 2'd0;
                end else begin
                    if ((area * 32'd100 > box_area * 32'd88) &&
                        ( (w > h) ? (w*10 < h*13) : (h*10 < w*13) )) begin
                        shape_id <= 2'd1; // cube
                    end else if ((area * 32'd100 >= box_area * 32'd68) &&
                                 (area * 32'd100 <= box_area * 32'd88) &&
                                 ( (w > h) ? (w*10 < h*13) : (h*10 < w*13) )) begin
                        shape_id <= 2'd2; // cylinder
                    end else if ((area * 32'd100 >= box_area * 32'd35) &&
                                 (area * 32'd100 <= box_area * 32'd65) &&
                                 (lower_cnt * 32'd10 >= upper_cnt * 32'd12)) begin
                        shape_id <= 2'd3; // cone
                    end else begin
                        shape_id <= 2'd0;
                    end
                end
            end
        end
    end

endmodule
