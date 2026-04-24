`timescale 1ns / 1ps

module tb_vision_top;

    parameter [2:0] TARGET_COLOR = 3'd5;

    reg         clk;
    reg         rst_n;
    reg         in_vsync, in_hsync, in_en;
    reg  [7:0]  in_data;

    wire [2:0]  color_id;
    wire        color_en;

    wire        frame_done;
    wire [31:0] area;
    wire [15:0] centroid_x, centroid_y, xmin, xmax, ymin, ymax;
    wire        shape_valid;
    wire [1:0]  shape_id;
    wire        size_valid;
    wire [1:0]  size_id;

    vision_top #(.TARGET_COLOR(TARGET_COLOR)) dut (
        .clk(clk), .rst_n(rst_n),
        .in_vsync(in_vsync), .in_hsync(in_hsync), .in_en(in_en), .in_data(in_data),
        .color_id(color_id), .color_en(color_en),
        .frame_done(frame_done),
        .area(area), .centroid_x(centroid_x), .centroid_y(centroid_y),
        .xmin(xmin), .xmax(xmax), .ymin(ymin), .ymax(ymax),
        .shape_valid(shape_valid), .shape_id(shape_id),
        .size_valid(size_valid), .size_id(size_id)
    );

    localparam W = 100;
    localparam H = 100;
    reg [7:0] img_mem [0:W*H*3-1];
    integer i,j,k;
    integer fout;

    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz
    end

    initial begin
        $dumpfile("wave_vision.vcd");
        $dumpvars(0, tb_vision_top);
        $readmemh("img_data.txt", img_mem);
        fout = $fopen("result_log.txt","w");

        rst_n=0; in_vsync=0; in_hsync=0; in_en=0; in_data=0;
        #100; rst_n=1; #100;

        // frame start: vsync 脉冲必须和第一个 dummy 字节对齐
        in_vsync=1;
        @(posedge clk); in_en=1; in_data=1;
        @(posedge clk); in_en=1; in_data=1;
        @(posedge clk); in_en=1; in_data=1;
        @(posedge clk); in_en=0;
        in_vsync=0;
        #40;

        for(i=0;i<H;i=i+1) begin
            for(j=0;j<W;j=j+1) begin
                for(k=0;k<3;k=k+1) begin
                    @(posedge clk);
                    in_en   <= 1'b1;
                    in_hsync <= (j==0 && k==0) ? 1'b1 : 1'b0;
                    in_data <= img_mem[(i*W+j)*3+k];
                end
            end
            @(posedge clk);
            in_en <= 1'b0;
            in_hsync <= 1'b0;
            #40;
        end

        // 再发一个 vsync 上升沿，触发 frame_done 输出上一帧统计
        in_vsync=1;
        @(posedge clk); in_en=1; in_data=1;
        @(posedge clk); in_en=1; in_data=1;
        @(posedge clk); in_en=1; in_data=1;
        @(posedge clk); in_en=0;
        in_vsync=0;

        @(posedge clk); in_en=1; in_data=1;
        @(posedge clk); in_en=1; in_data=1;
        @(posedge clk); in_en=1; in_data=1;
        @(posedge clk); in_en=0;

        #3000;
        $fclose(fout);
        $finish;
    end

    always @(posedge clk) begin
        if (color_en) begin
            $fdisplay(fout, "CID %0d", color_id);
        end
        if (frame_done) begin
            $display("[FRAME] area=%0d c=(%0d,%0d) bbox=(%0d,%0d,%0d,%0d)",
                area, centroid_x, centroid_y, xmin, xmax, ymin, ymax);
            $fdisplay(fout, "[FRAME] area=%0d c=(%0d,%0d) bbox=(%0d,%0d,%0d,%0d)",
                area, centroid_x, centroid_y, xmin, xmax, ymin, ymax);
        end
        if (shape_valid) begin
            $display("[SHAPE] id=%0d", shape_id);
            $fdisplay(fout, "[SHAPE] id=%0d", shape_id);
        end
        if (size_valid) begin
            $display("[SIZE ] id=%0d", size_id);
            $fdisplay(fout, "[SIZE ] id=%0d", size_id);
        end
    end

endmodule
