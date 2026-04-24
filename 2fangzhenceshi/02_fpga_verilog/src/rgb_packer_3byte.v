`timescale 1ns / 1ps

module rgb_packer_3byte (
    input  wire       clk,
    input  wire       rst_n,

    input  wire       in_vsync,
    input  wire       in_hsync,
    input  wire       in_en,
    input  wire [7:0] in_data,

    output reg        pix_vsync,
    output reg        pix_hsync,
    output reg        pix_en,
    output reg [7:0]  pix_r,
    output reg [7:0]  pix_g,
    output reg [7:0]  pix_b
);

    reg [1:0] byte_cnt;
    reg [7:0] r_tmp, g_tmp;
    reg       vs_tmp, hs_tmp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            byte_cnt  <= 2'd0;
            r_tmp     <= 8'd0;
            g_tmp     <= 8'd0;
            vs_tmp    <= 1'b0;
            hs_tmp    <= 1'b0;
            pix_en    <= 1'b0;
            pix_r     <= 8'd0;
            pix_g     <= 8'd0;
            pix_b     <= 8'd0;
            pix_vsync <= 1'b0;
            pix_hsync <= 1'b0;
        end else begin
            pix_en <= 1'b0;

            if (in_en) begin
                case (byte_cnt)
                    2'd0: begin
                        r_tmp    <= in_data;
                        vs_tmp   <= in_vsync;
                        hs_tmp   <= in_hsync;
                        byte_cnt <= 2'd1;
                    end
                    2'd1: begin
                        g_tmp    <= in_data;
                        byte_cnt <= 2'd2;
                    end
                    2'd2: begin
                        pix_r     <= r_tmp;
                        pix_g     <= g_tmp;
                        pix_b     <= in_data;
                        pix_vsync <= vs_tmp;
                        pix_hsync <= hs_tmp;
                        pix_en    <= 1'b1;
                        byte_cnt  <= 2'd0;
                    end
                    default: byte_cnt <= 2'd0;
                endcase
            end
        end
    end

endmodule
