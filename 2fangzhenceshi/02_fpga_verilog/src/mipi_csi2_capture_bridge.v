`timescale 1ns / 1ps

// Bridge CSI-2 packetized byte stream -> existing vision byte-stream timing.
// Current direct path targets RGB888 payload packets (DT = 0x24).
module mipi_csi2_capture_bridge (
    input  wire       clk,
    input  wire       rst_n,

    // Byte packet input (after D-PHY + lane aligner or hard CSI RX packet adapter)
    input  wire       in_pkt_valid,
    input  wire [7:0] in_pkt_data,
    input  wire       in_pkt_start,
    input  wire       in_pkt_end,

    // Output format compatible with vision_top input
    output reg        out_vsync, // pulse at first output byte of a frame
    output reg        out_hsync, // pulse at first output byte of each line payload
    output reg        out_en,
    output reg [7:0]  out_data,

    output reg        frame_active,
    output reg [15:0] dropped_payload_packets
);

    parameter [5:0] DT_RGB888 = 6'h24;

    wire        fs_pulse, fe_pulse, ls_pulse, le_pulse;
    wire [1:0]  short_vc;
    wire [15:0] short_data_field;
    wire        payload_valid;
    wire [7:0]  payload_byte;
    wire        payload_first;
    wire        payload_last;
    wire [5:0]  payload_dt;
    wire [1:0]  payload_vc;
    wire        protocol_error;

    reg use_short_sync;
    reg fs_pending;

    mipi_csi2_byte_packet_decoder u_pkt_dec (
        .clk(clk),
        .rst_n(rst_n),
        .in_pkt_valid(in_pkt_valid),
        .in_pkt_data(in_pkt_data),
        .in_pkt_start(in_pkt_start),
        .in_pkt_end(in_pkt_end),
        .short_fs_pulse(fs_pulse),
        .short_fe_pulse(fe_pulse),
        .short_ls_pulse(ls_pulse),
        .short_le_pulse(le_pulse),
        .short_vc(short_vc),
        .short_data_field(short_data_field),
        .payload_valid(payload_valid),
        .payload_byte(payload_byte),
        .payload_first(payload_first),
        .payload_last(payload_last),
        .payload_dt(payload_dt),
        .payload_vc(payload_vc),
        .protocol_error(protocol_error)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_vsync <= 1'b0;
            out_hsync <= 1'b0;
            out_en    <= 1'b0;
            out_data  <= 8'd0;

            frame_active            <= 1'b0;
            dropped_payload_packets <= 16'd0;
            use_short_sync          <= 1'b0;
            fs_pending              <= 1'b0;
        end else begin
            out_vsync <= 1'b0;
            out_hsync <= 1'b0;
            out_en    <= 1'b0;

            if (fs_pulse || fe_pulse) begin
                use_short_sync <= 1'b1;
            end

            if (fs_pulse) begin
                frame_active <= 1'b1;
                fs_pending   <= 1'b1;
            end
            if (fe_pulse) begin
                frame_active <= 1'b0;
                fs_pending   <= 1'b0;
            end

            if (payload_valid && payload_first && (payload_dt != DT_RGB888)) begin
                dropped_payload_packets <= dropped_payload_packets + 16'd1;
            end

            if (payload_valid && (payload_dt == DT_RGB888) &&
                (frame_active || !use_short_sync)) begin
                out_en   <= 1'b1;
                out_data <= payload_byte;

                if (payload_first || ls_pulse) begin
                    out_hsync <= 1'b1;
                end

                if (fs_pending) begin
                    out_vsync <= 1'b1;
                    fs_pending <= 1'b0;
                end
            end
        end
    end

endmodule

