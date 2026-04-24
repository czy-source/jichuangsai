# MIPI 采集链路补齐说明（初赛向）

## 1. 当前项目是否缺少摄像头相关 Verilog？
是。当前 `02_fpga_verilog/src` 中仅有图像处理流水线（颜色/统计/形状/尺寸），没有摄像头接入模块，也没有 MIPI CSI-2 接收链路模块。

## 2. 当前新增内容
本次新增了 3 个可直接对接现有 `vision_top` 的模块：

1. `mipi_csi2_byte_packet_decoder.v`  
   - 作用：解析 CSI-2 包头/负载，输出 FS/FE/LS/LE 事件与长包 payload 字节流。  
   - 使用位置：位于 D-PHY + lane 对齐之后。

2. `mipi_csi2_capture_bridge.v`  
   - 作用：将 CSI-2 负载（当前按 RGB888）转换为现有工程输入时序：`in_vsync/in_hsync/in_en/in_data`。  
   - 使用位置：连接 `vision_top` 前端。

3. `vision_mipi_top.v`  
   - 作用：把 MIPI 采集桥与现有视觉识别主链路打通，作为“可落板顶层入口”。

## 3. 初赛完整采集与处理链路（建议）
`MIPI D-PHY Rx` → `Lane Align` → `CSI-2 Packet Decode` → `Payload Format Adapt` → `vision_top`（颜色/形状/尺寸）

本次代码覆盖了最后两段中的 `Packet Decode + vision_top接口桥接`，并预留了与前端对接的包级接口。

## 4. 仍缺少的“必须模块”（按初赛落地优先级）

1. **D-PHY Rx（硬/软）**  
   - 必要性：MIPI 电气层与高速串并转换入口，没有它无法采集相机数据。  
   - 说明：通常依赖厂商 IP（Efinix/Lattice/Xilinx）。

2. **Lane Deskew / Byte Align（若 D-PHY 不自带）**  
   - 必要性：多 lane 字节对齐，不对齐会导致包头解析错误。  
   - 说明：部分硬核 CSI Rx 已内建。

3. **Payload 格式适配（按传感器输出）**  
   - 必要性：当前桥接直通 RGB888；若相机输出 RAW10/RAW12/YUV422，需补对应解包/色彩转换。  
   - 说明：初赛颜色识别建议最终输入保持 RGB。

4. **相机配置控制器（I2C/SCCB）**  
   - 必要性：必须配置相机分辨率、帧率、MIPI lane 数、输出数据类型（建议 RGB888）。  
   - 说明：无该模块无法稳定出图或无法输出目标格式。

5. **跨时钟域与缓冲（Async FIFO / Frame Buffer）**  
   - 必要性：MIPI 字节时钟与算法时钟通常不同，需 CDC 与突发平滑。  
   - 说明：否则容易丢包、抖动、时序不闭合。

6. **流监控与异常恢复（可强烈建议）**  
   - 必要性：现场赛要抗异常（线缆抖动、时钟漂移、偶发包错）。  
   - 说明：至少要有帧计数、错误计数、重同步触发。

## 5. 接入建议（初赛可执行）
- 优先让相机输出 **RGB888**，直接复用本次 `mipi_csi2_capture_bridge`。  
- 若板卡已有厂商 CSI2 Rx IP，优先使用其输出接口适配到本次 decoder 输入。  
- 若只能输出 RAW10/RAW12，再补 RAW 解包 + 去马赛克模块后接 `vision_top`。

