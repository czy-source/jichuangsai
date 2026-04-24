`timescale 1ns / 1ps

// CSI-2 byte-packet parser (after D-PHY + lane alignment stage).
// Input is packetized byte stream:
//   - in_pkt_start: first byte of packet (Data ID)
//   - in_pkt_end  : optional end-of-packet marker (not strictly required)
//   - in_pkt_valid/data: packet bytes
//
// This parser extracts:
//   1) short packet events: FS/FE/LS/LE
//   2) long packet payload byte stream + datatype/vc tagging
module mipi_csi2_byte_packet_decoder (
    input  wire       clk,
    input  wire       rst_n,

    input  wire       in_pkt_valid,
    input  wire [7:0] in_pkt_data,
    input  wire       in_pkt_start,
    input  wire       in_pkt_end,

    output reg        short_fs_pulse,
    output reg        short_fe_pulse,
    output reg        short_ls_pulse,
    output reg        short_le_pulse,
    output reg [1:0]  short_vc,
    output reg [15:0] short_data_field,

    output reg        payload_valid,
    output reg [7:0]  payload_byte,
    output reg        payload_first,
    output reg        payload_last,
    output reg [5:0]  payload_dt,
    output reg [1:0]  payload_vc,

    output reg        protocol_error
);

    localparam [1:0] ST_IDLE    = 2'd0;
    localparam [1:0] ST_HEADER  = 2'd1;
    localparam [1:0] ST_PAYLOAD = 2'd2;
    localparam [1:0] ST_CRC     = 2'd3;

    localparam [5:0] DT_FS = 6'h00;
    localparam [5:0] DT_FE = 6'h01;
    localparam [5:0] DT_LS = 6'h02;
    localparam [5:0] DT_LE = 6'h03;

    reg [1:0]  state;
    reg [1:0]  hdr_cnt;
    reg [1:0]  crc_cnt;
    reg [7:0]  hdr_byte0; // data_id
    reg [7:0]  hdr_byte1; // wc_l / short_data_l
    reg [7:0]  hdr_byte2; // wc_h / short_data_h
    reg [15:0] wc_total;
    reg [15:0] wc_rem;

    wire [5:0] hdr_dt = hdr_byte0[5:0];
    wire [1:0] hdr_vc = hdr_byte0[7:6];
    wire [15:0] hdr_wc = {hdr_byte2, hdr_byte1};

    wire is_short_packet = (hdr_dt == DT_FS) || (hdr_dt == DT_FE) ||
                           (hdr_dt == DT_LS) || (hdr_dt == DT_LE);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state            <= ST_IDLE;
            hdr_cnt          <= 2'd0;
            crc_cnt          <= 2'd0;
            hdr_byte0        <= 8'd0;
            hdr_byte1        <= 8'd0;
            hdr_byte2        <= 8'd0;
            wc_total         <= 16'd0;
            wc_rem           <= 16'd0;

            short_fs_pulse   <= 1'b0;
            short_fe_pulse   <= 1'b0;
            short_ls_pulse   <= 1'b0;
            short_le_pulse   <= 1'b0;
            short_vc         <= 2'd0;
            short_data_field <= 16'd0;

            payload_valid    <= 1'b0;
            payload_byte     <= 8'd0;
            payload_first    <= 1'b0;
            payload_last     <= 1'b0;
            payload_dt       <= 6'd0;
            payload_vc       <= 2'd0;

            protocol_error   <= 1'b0;
        end else begin
            short_fs_pulse <= 1'b0;
            short_fe_pulse <= 1'b0;
            short_ls_pulse <= 1'b0;
            short_le_pulse <= 1'b0;

            payload_valid <= 1'b0;
            payload_first <= 1'b0;
            payload_last  <= 1'b0;

            protocol_error <= 1'b0;

            case (state)
                ST_IDLE: begin
                    if (in_pkt_valid && in_pkt_start) begin
                        hdr_byte0 <= in_pkt_data;
                        hdr_cnt   <= 2'd1;
                        state     <= ST_HEADER;
                    end
                end

                ST_HEADER: begin
                    if (in_pkt_valid) begin
                        if (in_pkt_start) begin
                            // Re-sync to a new packet boundary.
                            protocol_error <= 1'b1;
                            hdr_byte0 <= in_pkt_data;
                            hdr_cnt   <= 2'd1;
                            state     <= ST_HEADER;
                        end else if (hdr_cnt == 2'd1) begin
                            hdr_byte1 <= in_pkt_data;
                            hdr_cnt   <= 2'd2;
                        end else if (hdr_cnt == 2'd2) begin
                            hdr_byte2 <= in_pkt_data;
                            hdr_cnt   <= 2'd3;
                        end else begin
                            // Header byte3(ECC) consumed at this beat.
                            short_vc         <= hdr_vc;
                            short_data_field <= {hdr_byte2, hdr_byte1};

                            if (is_short_packet) begin
                                short_fs_pulse <= (hdr_dt == DT_FS);
                                short_fe_pulse <= (hdr_dt == DT_FE);
                                short_ls_pulse <= (hdr_dt == DT_LS);
                                short_le_pulse <= (hdr_dt == DT_LE);
                                state          <= ST_IDLE;
                            end else begin
                                payload_dt <= hdr_dt;
                                payload_vc <= hdr_vc;
                                wc_total   <= hdr_wc;
                                wc_rem     <= hdr_wc;

                                if (hdr_wc == 16'd0) begin
                                    crc_cnt <= 2'd0;
                                    state   <= ST_CRC;
                                end else begin
                                    state <= ST_PAYLOAD;
                                end
                            end
                        end
                    end
                end

                ST_PAYLOAD: begin
                    if (in_pkt_valid) begin
                        if (in_pkt_start) begin
                            // Unexpected packet boundary inside payload.
                            protocol_error <= 1'b1;
                            hdr_byte0 <= in_pkt_data;
                            hdr_cnt   <= 2'd1;
                            state     <= ST_HEADER;
                        end else begin
                            payload_valid <= 1'b1;
                            payload_byte  <= in_pkt_data;
                            payload_first <= (wc_rem == wc_total);
                            payload_last  <= (wc_rem == 16'd1);

                            if (wc_rem != 16'd0) begin
                                wc_rem <= wc_rem - 16'd1;
                            end

                            if (wc_rem == 16'd1) begin
                                crc_cnt <= 2'd0;
                                state   <= ST_CRC;
                            end
                        end
                    end
                end

                ST_CRC: begin
                    if (in_pkt_valid) begin
                        if (crc_cnt == 2'd1) begin
                            state <= ST_IDLE;
                        end else begin
                            crc_cnt <= crc_cnt + 2'd1;
                        end
                    end

                    if (in_pkt_end) begin
                        state <= ST_IDLE;
                    end
                end

                default: state <= ST_IDLE;
            endcase
        end
    end

endmodule
