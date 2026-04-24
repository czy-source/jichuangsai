# SC431HAI 数据手册 V1.1

**发布日期：** 2024-08-16  
**版权所有：** © 思特威（上海）电子科技股份有限公司

---

## ◼ 应用领域

- ◆ 家用安防监控系统
- ◆ 可移动设备相机
- ◆ 视频电话会议设备
- ◆ 行车记录仪

## ◼ 产品特性

- ◆ 高动态范围
  - ➢ 行交叠宽动态
- ◆ 低功耗
- ◆ 高灵敏度
- ◆ 高信噪比
- ◆ 像素双转换增益
- ◆ 优异高温性能
- ◆ 高色彩还原度
- ◆ 48 x 模拟增益，16 x 数字增益
- ◆ 动态 DPC
- ◆ 外部控制帧率及多传感器同步
- ◆ 水平/垂直窗口调整
- ◆ 2 x 2 binning 模式
- ◆ I2C 接口寄存器编程

## ◼ 关键参数（典型值）

| 参数 | 描述 |
|------|------|
| 分辨率 | 400 万 |
| 像素阵列 | 2568 (H) x 1448 (V) |
| 像素尺寸 | 2.0 μm x 2.0 μm |
| 镜头光学尺寸 | 1/3.06” |
| 最大图像传输速率 | 2560 (H) x 1440 (V) @ 30/60 fps 10-bit 1.2 V |
| 输出接口 | 8/10-bit 1/2/4-Lane MIPI |
| 输出格式 | RAW RGB |
| CRA | 15° |
| 灵敏度 | 4319 mV/lux·s |
| 动态范围 | 线性模式: 81 dB；HDR 模式: >100 dB |
| 信噪比 | 38.47 dB |
| 工作温度范围 | -30°C ~ +85°C |
| 最佳工作温度范围 | -20°C ~ +60°C |
| 电源电压 | AVDD = 2.8±0.1 V, DVDD = 1.2±0.06 V, DOVDD = 1.8±0.1 V |
| 封装尺寸 | CSP, 5.790 mm x 3.554 mm, 35-pin |
| ESD 等级 | HBM classification: 2；CDM classification: C3 |

---

## 目录

1. [系统描述](#1-系统描述)
2. [功能介绍](#2-功能介绍)
3. [电气特性](#3-电气特性)
4. [光学特性](#4-光学特性)
5. [封装信息](#5-封装信息)
6. [订购信息](#6-订购信息)
7. [版本变更记录](#7-版本变更记录)

---

## 1. 系统描述

### 1.1. 芯片概述

SC431HAI 是监控相机领域先进的数字 CMOS 图像传感器，最高支持 2560 (H) x 1440 (V) @ 60 fps 的传输速率。SC431HAI 输出 raw 格式图像，有效像素窗口为 2568 (H) x 1448 (V)，支持复杂的片上操作，例如窗口化、水平镜像、垂直倒置等。SC431HAI 支持通过标准的 I2C 接口读写寄存器，并可以通过 EFSYNC/FSYNC 引脚实现外部控制曝光。

### 1.2. 系统框架

SC431HAI 图像传感器的功能模块包含：光学阵列、模拟处理模块、数字处理模块、系统控制、PLL、I2C Slave 等。支持 MIPI 接口输出。典型应用示意图包含 DOVDD、AVDD、DVDD 供电，I2C 接口（SCL、SDA），MIPI 时钟和数据通道，以及 XSHUTDN、EFSYNC、FSYNC、EXTCLK 等控制信号。

### 1.3. 芯片初始化

#### 1.3.1. 上电时序

上电时序要求：DOVDD → DVDD → AVDD → XSHUTDN → EXTCLK Available → Initial setting → SDA/SCL 初始化。

**注：** T1≥0ms，T2≥0ms，T3≥0ms，T4≥4ms。

#### 1.3.2. 下电时序

下电时序要求：SDA/SCL Standby-on → CK lane/Data lane LP11 Hi-Z → EXTCLK 关闭 → XSHUTDN 关闭 → AVDD 关闭 → DVDD 关闭 → DOVDD 关闭。

**注：**
1. T0≥6 EXTCLKs，T1≥0ms，T2≥0ms，T3≥0ms，T4≥0ms。
2. 在 DOVDD 下电状态下，禁止 XSHUTDN/EXTCLK/SDA/SCL 为高电平。

#### 1.3.3. 睡眠模式

睡眠模式下，SC431HAI 停止输出图像数据流，工作在低功耗状态，保持当前寄存器值。

**表 1-1 睡眠模式控制寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| 软睡眠模式使能 | 16’h0100 | 8’h00 | Bit[0]: manual sleep mode ctrl；1 ~ sleep mode disable；0 ~ sleep mode enable |
| 低功耗软睡眠模式使能 | 16’h302c / 16’h0100 | 8’h00 | sleep mode enable (stream off): 16’h302c, 8’h0f；16’h0100, 8’h00；sleep mode disable (stream on): 16’h302c, 8’h00；16’h0100, 8’h01 |

**注：** 以上寄存器写入 sensor 的先后顺序不可变更。

#### 1.3.4. 复位模式

复位模式下，SC431HAI 停止输出图像数据流，工作在低功耗状态，重置所有寄存器。提供两种方式进入复位模式：
1. 将 XSHUTDN 拉低，此时不支持 I2C 读写；
2. 将寄存器 16’h0103[0] 写入 1，此复位模式持续 150 ns。

**表 1-2 软复位控制寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| 软复位使能 | 16’h0103 | 8’h0 | Bit[0]: soft reset |

### 1.4. 配置接口

SC431HAI 提供标准的 I2C 总线配置接口对寄存器进行读写，I2C 设备地址由 PAD SID 的电平值决定，内部有下拉电阻。Slave Address（从机地址）由 SID 决定，Sub Address 与寄存器相关。

**表 1-3 I2C 设备地址控制**

| SID | 7-bit I2C 设备地址 | 8-bit I2C 写地址 | 8-bit I2C 读地址 |
|-----|-------------------|------------------|------------------|
| 低电平 | 7’h30 | 8’h60 | 8’h61 |
| 高电平 | 7’h32 | 8’h64 | 8’h65 |

消息类型：16-bit 地址、8-bit 数据和 7-bit 设备地址。

**I2C Write：** S → 0 A → Address[15:8] A → Address[7:0] A → data A/Ã → P

**I2C Read：** S → 0 A → Address[15:8] A → Address[7:0] A → Sr → 1 A → data → Ã → P

- S: Start Condition
- P: Stop Condition
- Sr: Restart Condition
- A: Acknowledge
- Ã: No-Acknowledge

**表 1-4 I2C 接口时序详细参数**

| Symbol | Parameter | Standard-mode (Min / Max) | Fast-mode (Min / Max) | Unit |
|--------|-----------|---------------------------|-----------------------|------|
| f_SCL | SCL clock frequency | 0 / 100 | 0 / 400 | kHz |
| t_HD;STA | hold time (repeated) START condition | 4.0 / - | 0.6 / - | μs |
| t_LOW | LOW period of the SCL clock | 4.7 / - | 1.3 / - | μs |
| t_HIGH | HIGH period of the SCL clock | 4.0 / - | 0.6 / - | μs |
| t_SU;STA | set-up time for a repeated START condition | 4.7 / - | 0.6 / - | μs |
| t_HD;DAT | data hold time | 0 / - | 0 / - | μs |
| t_SU;DAT | data set-up time | 250 / - | - / - | ns |
| t_r | rise time of both SDA and SCL signals | - / 1000 | - / 300 | ns |
| t_f | fall time of both SDA and SCL signals | - / 300 | - / 300 | ns |
| t_SU;STO | set-up time for STOP condition | 4.0 / - | 0.6 / - | μs |
| t_BUF | bus free time between a STOP and START condition | 4.7 / - | 1.3 / - | μs |
| t_VD;DAT | data valid time | - / 3.45 | - / 0.9 | μs |
| t_VD;ACK | data valid acknowledge time | - / 3.45 | - / 0.9 | μs |
| t_SP | pulse width of spikes that must be suppressed by the input filter | - / - | 0 / 50 | ns |

**注：** 判断上升沿起始或下降沿终止的电平阈值为 30%；判断上升沿终止或下降沿起始的阈值为 70%。

### 1.5. Sensor ID

**表 1-5 Sensor ID 寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| SENSOR ID 高位 | 16’h3107 | 8’hcd | SENSOR ID[15:8] |
| SENSOR ID 低位 | 16’h3108 | 8’h6b | SENSOR ID[7:0] |

### 1.6. 数据接口

#### 1.6.1. MIPI

SC431HAI 提供串行视频端口（MIPI），支持 8/10-bit，1/2/4-lane 串行输出，传输速率推荐不大于 1.4 Gbps。

MIPI 数据包结构包含短数据包（Short Packet）和长数据包（Long Packet）。数据标识 DI（Data Identifier）包括虚拟通道（VC）和数据类型（DT）。默认情况下，Sensor 给出的 MIPI 数据 VC 值都是 0。

**表 1-6 MIPI 数据类型**

| DT | 描述 |
|----|------|
| 6’h00 | 帧起始短包 |
| 6’h01 | 帧结束短包 |
| 6’h02 | 行起始短包 |
| 6’h03 | 行结束短包 |
| 6’h2a | 8-bit 模式下数据长包 |
| 6’h2b | 10-bit 模式下数据长包 |

**表 1-7 MIPI 调整寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| MIPI lane 数量 | 16’h3018 | 8’h7a | Bit[7:5]: MIPI lane num；3’h0 ~ 1 lane mode；3’h1 ~ 2 lane mode；3’h3 ~ 4 lane mode |
| MIPI 输出数据模式 | 16’h3031 | 8’h0a | Bit[3:0]: MIPI bit mode；4’h8 ~ raw8 mode；4’ha ~ raw10 mode |
| PHY 数据模式 | 16’h3037 | 8’h20 | Bit[6:5]: phy bit mode；2’h0 ~ 8bit mode；2’h1 ~ 10bit mode |
| MIPI clock 设置 | 16’h303f | 8’h01 | Bit[7]: pclk sel；1’h0 ~ sel MIPI_pclk；1’b1 ~ sel DVP_pclk |
| MIPI LP 驱动 | 16’h3650 | 8’h31 | Bit[1:0]: MIPI LP 驱动能力调整，默认 2’h1 |
| MIPI HS 驱动 | 16’h3651 | 8’h9d | Bit[3:0]: MIPI HS 驱动能力调整，默认 4’hd |
| MIPI Lane 0 延时 | 16’h3652 | 8’h00 | Bit[3]: lane0 相位反向；Bit[1:0]: lane0 延时，40ps/step |
| MIPI Lane 1 延时 | 16’h3652 | 8’h00 | Bit[7]: lane1 相位反向；Bit[5:4]: lane1 延时，40ps/step |
| MIPI Lane 2 延时 | 16’h3653 | 8’h00 | Bit[3]: lane2 相位反向；Bit[1:0]: lane2 延时，40ps/step |
| MIPI Lane 3 延时 | 16’h3653 | 8’h00 | Bit[7]: lane3 相位反向；Bit[5:4]: lane3 延时，40ps/step |
| MIPI Clock 延时 | 16’h3654 | 8’h30 | Bit[3]: 时钟反向；Bit[1:0]: 时钟延时，40ps/step |

### 1.7. 锁相环

SC431HAI 的 PLL 模块允许的输入时钟频率范围为 6~40 MHz，其中 VCO 输出频率（F_VCO）的范围为 400 MHz-1400 MHz。

PLL 结构：F_EXTCLK → Pre_Divider → PFD → LPF → VCO → Divider → F_SYSCLK

---

## 2. 功能介绍

### 2.1. LED Strobe

SC431HAI 支持 LED Strobe 功能，可通过 FSYNC 引脚输出。

**表 2-1 LED Strobe 控制寄存器（模式1）**

| 功能 | 寄存器地址 | 默认值 | 说明 |
|------|-----------|--------|------|
| LED Strobe 使能 | 16’h3362[0] | 8’h70 | Bit[0] LED Strobe 使能控制；1’b0 ~ 关闭；1’b1 ~ 打开 |
| LED Strobe 输出引脚 | 16’h300a[1] / 16’h300a[2] | - | 通过 FSYNC 引脚输出；16’h300a[1] = 0；16’h300a[2] = 1；16’h3033[4] = 1 |
| LED Strobe 脉冲输出信号开始位置时间控制 | {16’h3382, 16’h3383} | 16’h0000 | 配合 LED Strobe 使能，值越大，输出信号变化越早于帧开始位置 |
| LED Strobe 脉冲输出信号结束位置时间控制 | {16’h3386, 16’h3387} | - | 结束位置寄存器需小于开始位置寄存器 |

**表 2-2 LED Strobe 控制寄存器（模式2）**

| 功能 | 寄存器地址 | 默认值 | 说明 |
|------|-----------|--------|------|
| LED Strobe 使能 | 16’h4d0b[0] | 8’h00 | Bit[0] LED Strobe 使能控制 |
| LED Strobe 输出引脚 | 16’h300a[1] / 16’h300a[2] | - | 通过 FSYNC 引脚输出；16’h300a[1] = 0；16’h300a[2] = 1；16’h3033[1] = 1 |
| LED Strobe 脉冲宽度 | {16’h4d0c, 16’h4d0d} | 16’h0000 | 脉冲输出信号宽度由寄存器控制，以 {16’h320c, 16’h320d}/2 为单位 |

### 2.2. Slave Mode

Slave Mode 是主控芯片通过 EFSYNC 或者做输入时的 FSYNC 信号触发帧读出，以达到多个 sensor 同步成像的工作模式。

**工作流程：**
1. 当 SC431HAI 工作在 Slave Mode 时，芯片自动进入 Active State 状态，等待 EFSYNC/FSYNC 触发；
2. EFSYNC/FSYNC 触发上升沿有效，EFSYNC 高电平持续时间不小于 4 个 EXTCLK 周期；
3. 当 EFSYNC/FSYNC 触发后，芯片进入 RB Rows（有效数据读出之前的等待时间，由寄存器控制，以行为单位）；
4. Active Rows 时，读出芯片图像数据，由寄存器控制，以行为单位；
5. Blank Rows 时，读出芯片图像数据之后的消隐时间，由寄存器控制，以行为单位；
6. Active State 时，芯片等待下一次 EFSYNC/FSYNC 触发，建议 Active State 为 0；
7. EFSYNC/FSYNC 上升沿间隔为一帧时间，允许有 40 ns 偏差。

**注：**
- 只有当 SC431HAI 处于 Active State 时，EFSYNC/FSYNC 触发才有效；
- Sensor 会提前 40 ns 退出 Blank Rows 进入 Active State。

VTS 表示帧长，VTS = RB Rows + Active Rows + Blank Rows。

**表 2-3 Slave mode 控制寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| Slave mode enable | 16’h3222 | 8’h00 | Bit[0]: 1 ~ slave mode；0 ~ master mode |
| Trigger Pad sel | 16’h3224 | 8’hc2 | Bit[4]: 1 ~ sel FSYNC；0 ~ sel EFSYNC |
| FSYNC OEN | 16’h300a | 8’h20 | Bit[2]: 1 ~ FSYNC as output PAD；0 ~ FSYNC as input PAD |
| EFSYNC IEN | 16’h300a | 8’h20 | Bit[6]: 1 ~ EFSYNC as input PAD |
| RB rows | {16’h3230, 16’h3231} | 16’h0000 | Rows Before Read 控制寄存器 |
| Active Rows, Blank Rows | - | - | Active Rows + Blank Rows = VTS – RB Rows |
| VTS | {16’h320e, 16’h320f} | 16’h05dc | 帧长，最大帧长 16’h7ff0 |

### 2.3. 宽动态

宽动态（HDR）是指通过把两帧相同场景、不同曝光时间的图片合成一帧，从而提高图像的动态范围。SC431HAI 支持行交叠 HDR。

#### 2.3.1. 行交叠 HDR

SC431HAI 行交叠 HDR 是指两种不同长短曝光时间的图像在帧内逐行交替输出。优势是同一像素的长短曝光时间间隔短，可避免合成带来的拖尾现象；通过不同曝光实现，具有噪声小的优势。

可以通过 MIPI 接口的 virtual channel 区分长短曝光数据（默认长曝光 VC 为 2’b00，短曝光 VC 为 2’b01），也可不通过 virtual channel 区分，通过行偏差区分（模式 a 与模式 b）。

**注：**
- max long exposure = 2*{16’h320e,16’h320f} - 2*{16’h3e23,16’h3e24} – ‘d21

**表 2-4 HDR 控制寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| HDR mode enable | 16’h3281 | 8’h00 | Bit[0]: 1 ~ HDR mode enable；0 ~ disable |
| SE start point | {16’h3e23, 16’h3e24} | 16’h0020 | short exposure start readout point |
| VC (Virtual Channel) | 16’h4816 | 8’h61 | Bit[4]: 1’h1 ~ hdr vc enable；1’h0 ~ disable |
| LE VC | 16’h4816 | 8’h61 | Bit[3:2]: Long exposure VC |
| SE VC | 16’h4816 | 8’h61 | Bit[1:0]: Short exposure VC |

### 2.4. AEC/AGC

AEC 调节曝光时间，AGC 调节增益值，使图像亮度落在设定亮度阈值范围内。

#### 2.4.1. AEC/AGC 的控制策略

SC431HAI 本身没有 AEC/AGC 功能，需要通过后端平台实现。调整策略为：曝光时间优先，曝光时间最长无法继续调整时，调整增益。

- 图像过暗：不开启增益直到曝光时间达上限 → 再调用自动增益控制
- 图像过亮：优先关闭增益 → 增益全部关闭后降低曝光时间

#### 2.4.2. AEC 控制寄存器说明

**表 2-5 曝光的手动控制寄存器**

| 功能 | 寄存器地址 | 说明 | 调节步长 | 最小值 | 最大值 |
|------|-----------|------|---------|--------|--------|
| 长曝光时间 | {16’h3e00[3:0], 16’h3e01[7:0], 16’h3e02[7:4]} | 线性模式下手动曝光时间，以半行为单位 | 1 | 4 | 2*{16’h320e,16’h320f} – ‘d11 |
| 短曝光时间 | {16’h3e22[3:0], 16’h3e04[7:0], 16’h3e05[7:4]} | 行交叠 HDR 模式下的短曝光时间，以半行为单位 | 4 | 8 | 2*{16’h3e23,16’h3e24} – ‘d19 |

**AEC 控制说明：**
1. AEC 的调节步长为半行时间，半行时间为一行时间除以 2；
2. 曝光时间及增益若在第 N 帧写入，第 N+2 帧生效；
3. 线性模式下建议在帧开始之后写入；行交叠 HDR 模式下建议长曝光数据在长曝光数据帧开始之后写入，短曝光数据在短曝光数据帧开始之后写入。

#### 2.4.3. AGC 控制寄存器说明

**表 2-6 增益寄存器控制**

| 模式 | ANA GAIN register | ANA FINE GAIN register | DIG GAIN register | DIG FINE GAIN register |
|------|-------------------|--------------------------|-------------------|------------------------|
| 线性模式/HDR 模式长曝光 | 16’h3e08 | 16’h3e09 | 16’h3e06 | 16’h3e07 |
| HDR 模式短曝光 | 16’h3e12 | 16’h3e13 | 16’h3e10 | 16’h3e11 |

**注：** 寄存器 16’h3e08 的 Bit[7] 是控制 DCG 增益的开关。

一般情况下优先调节模拟 gain 值，模拟 gain 到上限时调节数字 gain 值。SC431HAI 的 DIG FINE GAIN 精度为 1/32。

**表 2-7 模拟增益值控制寄存器（节选）**

| ANA GAIN | ANA FINE GAIN | GAIN Value | dB Value | ANA GAIN | ANA FINE GAIN | GAIN Value | dB Value |
|----------|---------------|------------|----------|----------|---------------|------------|----------|
| 8'h00 | 8'h20 | 1.000 | 0.000 | 8'h80 | 8'h20 | 1.540 | 3.750 |
| 8'h00 | 8'h21 | 1.031 | 0.267 | 8'h80 | 8'h21 | 1.588 | 4.018 |
| ... | ... | ... | ... | ... | ... | ... | ... |
| 8'h8F | 8'h3F | 48.510 | 33.717 | - | - | - | - |

**表 2-8 数字增益值控制寄存器（节选）**

| DIG GAIN | DIG FINE GAIN | GAIN Value | dB Value | DIG GAIN | DIG FINE GAIN | GAIN Value | dB Value |
|----------|---------------|------------|----------|----------|---------------|------------|----------|
| 8'h00 | 8'h80 | 1.000 | 0.000 | 8'h01 | 8'h80 | 2.000 | 6.021 |
| ... | ... | ... | ... | ... | ... | ... | ... |
| 8'h07 | 8'hFC | 15.750 | 23.946 | - | - | - | - |

### 2.5. Group Hold

SC431HAI 具有 Group hold 功能，最多支持 10 个寄存器打包；支持帧延迟写入功能。

**使用方法：**
1. 寄存器 16’h3812 写 8’h00，寄存器打包开始；
2. 寄存器 16’h3812 写 8’h30，寄存器打包结束。

打包生效的时刻为写 8’h30 之后第 N 个帧内生效时刻，N=0 表示当前帧，N=1 表示下一帧……延迟帧数由寄存器 16’h3802 控制。

**表 2-9 Group hold 控制寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| Group hold 功能开关 | 16’h3812 | 8’h00 | 写入 8’h00 启动，写入 8’h30 释放 |
| 帧延迟控制 | 16’h3802 | 8’h00 | Bit[1:0]: 写 0 表示当前帧，写 N 表示 N 帧延迟 |

### 2.6. DPC

SC431HAI 支持 DPC 功能。坏点判断原理是当前 pixel 值比周围相同颜色的 pixel 值都大（或小），且差值大于设定阈值。分为亮坏点（white pixel）和暗坏点（black pixel）。

**表 2-10 DPC 控制寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| 亮坏点消除功能开关 | 16’h5000[2] | 1’b1 | 1~enable；0~disable |
| 暗坏点消除功能开关 | 16’h5000[1] | 1’b1 | 1~enable；0~disable |

### 2.7. 视频输出模式

#### 2.7.1. 读取顺序

芯片第一个读取的 pixel 位置为 (0, 0)，像素尺寸为 2.0 μm x 2.0 μm，Active Array 为 2560 H x 1440 V。

提供镜像模式和倒置模式：
- 镜像模式：水平颠倒传感器的数据读出顺序
- 倒置模式：垂直颠倒传感器的读出顺序

**表 2-11 镜像和倒置模式控制寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| 镜像模式 | 16’h3221 | 8’h00 | Bit[2:1]: 2’b00 ~ mirror off；2’b11 ~ mirror on |
| 倒置模式 | 16’h3221 | 8’h00 | Bit[6:5]: 2’b00 ~ flip off；2’b11 ~ flip on |

#### 2.7.2. 输出窗口

**表 2-12 输出窗口寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| 窗口宽度 | {16’h3208, 16’h3209} | 16’h0a00 | 输出窗口宽度 |
| 窗口高度 | {16’h320a, 16’h320b} | 16’h05a0 | 输出窗口高度 |
| 列起始 | {16’h3210, 16’h3211} | 16’h0004 | 输出窗口列起始位置 |
| 行起始 | {16’h3212, 16’h3213} | 16’h0004 | 输出窗口行起始位置 |

### 2.8. 帧率计算

SC431HAI 帧率由 FAE 提供。简单计算一行时间的方法：

**一行时间 = 1 / (帧率 × 帧长)**

**表 2-13 帧率相关寄存器**

| 功能 | 寄存器地址 | 默认值 | 描述 |
|------|-----------|--------|------|
| 帧长 | {16’h320e[6:0], 16’h320f} | 16’h05dc | 帧长 = {16’h320e[6:0], 16’h320f} |

### 2.9. 测试模式

SC431HAI 提供一种灰度递增测试模式。

**表 2-14 测试模式控制寄存器**

| 功能 | 寄存器地址 | 寄存器值 | 默认值 | 描述 |
|------|-----------|----------|--------|------|
| 灰度渐变模式 | 16’h4501 | 8’hac | 8‘ha4 | Bit[3]: 0 ~ normal image；1 ~ incremental pattern |

---

## 3. 电气特性

**表 3-1 绝对最大额定值（所有电压都是 to pad 电压）**

| 项目 | 符号 | 绝对最大额定值 | 单位 |
|------|------|---------------|------|
| 模拟电源电压 AVDD | V_AVDD | -0.3 ~ 3.4 | V |
| I/O 电源电压 DOVDD | V_DOVDD | -0.3 ~ 2.2 | V |
| 数字电源电压 DVDD | V_DVDD | -0.3 ~ 1.4 | V |
| I/O 输入电压 | V_I | -0.3 ~ V_DOVDD + 0.3 | V |
| I/O 输出电压 | V_O | -0.3 ~ V_DOVDD + 0.3 | V |
| 工作温度 | T_OPR | -30 ~ +85 | °C |
| 最佳工作温度 | T_SPEC | -20 ~ +60 | °C |
| 贮存温度 | T_STG | -40 ~ +85 | °C |

**表 3-2 直流电气特性（所有电压都是 to pad 电压）**

| 项目 | 符号 | 最小值 | 典型值 | 最大值 | 单位 |
|------|------|--------|--------|--------|------|
| **电源** |
| 模拟电源电压 AVDD | V_AVDD | 2.7 | 2.8 | 2.9 | V |
| I/O 供电电压 DOVDD | V_DOVDD | 1.7 | 1.8 | 1.9 | V |
| 数字电源 DVDD | V_DVDD | 1.14 | 1.2 | 1.26 | V |
| **电流（工作电流*1 线性模式 60 fps MIPI 4-lane output）** |
| 模拟电源电流 | I_AVDD | - | 19.90 | - | mA |
| I/O 电源电流 | I_DOVDD | - | 0.10 | - | mA |
| 数字电源电流 | I_DVDD | - | 82.20 | - | mA |
| 总功耗 | Power | - | 154.54 | - | mW |
| **数字输入** |
| 输入低电平 | V_IL | - | - | 0.3 × DOVDD | V |
| 输入高电平 | V_IH | 0.7 × DOVDD | - | - | V |
| 输入电容 | C_IN | - | - | 10 | pF |
| **数字输出（25pF 标准负载）** |
| 输出高电平 | V_OH | 0.9 × DOVDD | - | - | V |
| 输出低电平 | V_OL | - | - | 0.1 × DOVDD | V |
| **串行接口输入（SCL 和 SDA）** |
| 输入低电平 | V_IL | -0.5 | 0 | 0.3 × DOVDD | V |
| 输入高电平 | V_IH | 0.7 × DOVDD | DOVDD | DOVDD + 0.5 | V |

**注：** *1 工作电流：（典型值）工作电压 2.8 V/1.8 V/1.2 V，Tj=25°C；亮度条件：芯片亮度达到最大亮度 1/3 时。

**表 3-3 外部时钟参数**

| 项目 | 符号 | 最小值 | 典型值 | 最大值 | 单位 |
|------|------|--------|--------|--------|------|
| EXTCLK 频率 | f_EXTCLK | 6 | - | 40 | MHz |
| EXTCLK 高电平脉冲宽度 | t_WH | 5 | - | - | ns |
| EXTCLK 低电平脉冲宽度 | t_WL | 5 | - | - | ns |
| EXTCLK 占空比 | - | 45 | 50 | 55 | % |

---

## 4. 光学特性

### 4.1. QE 曲线

SC431HAI QE 曲线请参考原数据手册图 4-1。

### 4.2. 主光线入射角（CRA）

SC431HAI CRA 为 15°，具体 CRA 曲线数据请参考原数据手册图 4-2。

| Image Height (%) | mm | CRA (deg.) |
|-------------------|-----|------------|
| 0 | 0.000 | 0.00 |
| 10 | 0.294 | 1.50 |
| 20 | 0.587 | 3.00 |
| 30 | 0.881 | 4.50 |
| 40 | 1.175 | 6.00 |
| 50 | 1.469 | 7.50 |
| 60 | 1.762 | 9.00 |
| 70 | 2.056 | 10.50 |
| 80 | 2.350 | 12.00 |
| 90 | 2.643 | 13.50 |
| 100 | 2.937 | 15.00 |

---

## 5. 封装信息

### 5.1. 封装尺寸

SC431HAI 提供 35-pin CSP 的封装。

**注：**
1. 芯片的 Chip Center 与 Array Center 不重合，Array Center 与 BGA Center 重合。以 Chip Center 为原点，Array Center 和 BGA Center 均为 (42, -44)，单位为 μm。
2. Top Side 中三角形直角指向 A1 所在位置。

**表 5-1 封装尺寸表**

| Parameter | Symbol | Nominal (mm) | Min / Max (mm) | Nominal (inch) | Min / Max (inch) |
|-----------|--------|--------------|----------------|----------------|------------------|
| Package Body Dimension X | A | 5.7900 | 5.7650 / 5.8150 | 0.22795 | 0.22697 / 0.22894 |
| Package Body Dimension Y | B | 3.5540 | 3.5290 / 3.5790 | 0.13992 | 0.13894 / 0.14091 |
| Package Height | C | 0.6650 | 0.6100 / 0.7200 | 0.02618 | 0.02402 / 0.02835 |
| Cavity wall height | C4 | 0.0410 | 0.0370 / 0.0450 | 0.00161 | 0.00146 / 0.00177 |
| Cavity wall+epoxy thickness | C5 | 0.0435 | 0.0385 / 0.0485 | 0.00171 | 0.00152 / 0.00191 |
| Si Thickness | C6 | 0.1500 | 0.1400 / 0.1600 | 0.00591 | 0.00551 / 0.00630 |
| Package Thickness (sensor to Ball) | C7 | 0.3215 | 0.2665 / 0.3765 | 0.01266 | 0.01049 / 0.01482 |
| Glass Thickness | C3 | 0.3000 | 0.2900 / 0.3100 | 0.01181 | 0.01142 / 0.01220 |
| Package Body Thickness | C2 | 0.5350 | 0.5000 / 0.5700 | 0.02106 | 0.01969 / 0.02244 |
| Ball Height | C1 | 0.1300 | 0.1000 / 0.1600 | 0.00512 | 0.00394 / 0.00630 |
| Ball Diameter | SΦ | 0.2500 | 0.2200 / 0.2800 | 0.00984 | 0.00866 / 0.01102 |
| Total Ball Count | N | 35 (6NC) | - / - | - | - / - |
| Ball Count X axis | N1 | 7 | - / - | - | - / - |
| Ball Count Y axis | N2 | 5 | - / - | - | - / - |
| Pins Pitch X axis | J1 | 0.6400 | 0.6300 / 0.6500 | 0.02520 | 0.02480 / 0.02559 |
| Pins Pitch Y axis | J2 | 0.5800 | 0.5700 / 0.5900 | 0.02283 | 0.02244 / 0.02323 |
| BGA ball center to package center offset in X-direction | X | -0.0420 | -0.0670 / -0.0170 | -0.00165 | -0.00264 / -0.00067 |
| BGA ball center to package center offset in Y-direction | Y | -0.0440 | -0.0690 / -0.0190 | -0.00173 | -0.00272 / -0.00075 |
| Edge to Ball Center Distance along X1 | S1 | 0.9330 | 0.9030 / 0.9630 | 0.03673 | 0.03555 / 0.03791 |
| Edge to Ball Center Distance along Y1 | S2 | 0.6610 | 0.6310 / 0.6910 | 0.02602 | 0.02484 / 0.02720 |
| Edge to Ball Center Distance along X2 | S3 | 1.0170 | 0.9870 / 1.0470 | 0.04004 | 0.03886 / 0.04122 |
| Edge to Ball Center Distance along Y2 | S4 | 0.5730 | 0.5430 / 0.6030 | 0.02256 | 0.02138 / 0.02374 |

### 5.2. 引脚描述

**表 5-2 引脚描述**

| 序号 | 编号 | 信号名 | 引脚类型 | 描述 |
|------|------|--------|----------|------|
| 1 | A1 | AGND | 地线 | 模拟地 |
| 2 | A2 | NC | - | NC |
| 3 | A3 | EXTCLK | 输入 | 时钟输入 |
| 4 | A4 | SDA | 输入/输出 | I2C 数据线 (open drain) |
| 5 | A5 | SCL | 输入 | I2C 时钟线 |
| 6 | A6 | XSHUTDN | 输入 | 复位信号输入（内置上拉电阻，低电位有效） |
| 7 | A7 | EFSYNC | 输入 | 外部帧同步信号 |
| 8 | B1 | AVDD | 电源 | 2.8 V 模拟电源 |
| 9 | B2 | DOGND | 地线 | I/O 地 |
| 10 | B3 | FSYNC | 输入/输出 | 输入时作为外部帧同步信号；输出时作为 LED Strobe 信号 |
| 11 | B4 | DVDD | 电源 | 1.2 V 数字电源 |
| 12 | B5 | SID | 输入 | I2C Device ID（内置下拉电阻，默认为低电位，对应 Device ID 是 7’h30） |
| 13 | B6 | DVDD | 电源 | 1.2 V 数字电源 |
| 14 | B7 | AVDD | 电源 | 2.8 V 模拟电源 |
| 15 | C1 | DVDD | 电源 | 1.2 V 数字电源 |
| 16 | C2 | NC | - | NC |
| 17 | C3 | DOVDD | 电源 | 1.8 V I/O 电源 |
| 18 | C4 | MCP | 输出 | MIPI 时钟正极信号 |
| 19 | C5 | MD2N | 输出 | MIPI 数据 2 负极信号 |
| 20 | C6 | PWDNB_NC | - | SC431HAI 没有 PWDNB，仅作为同系列芯片封装 P2P 预留 |
| 21 | C7 | AGND | 地线 | 模拟地 |
| 22 | D1 | MD3P | 输出 | MIPI 数据 3 正极信号 |
| 23 | D2 | MD1N | 输出 | MIPI 数据 1 负极信号 |
| 24 | D3 | MD1P | 输出 | MIPI 数据 1 正极信号 |
| 25 | D4 | MCN | 输出 | MIPI 时钟负极信号 |
| 26 | D5 | MD0N | 输出 | MIPI 数据 0 负极信号 |
| 27 | D6 | DOGND | 地线 | I/O 地 |
| 28 | D7 | VREFN/VREFN2 | 输出 | 内部参考电压（外接电容至 AGND） |
| 29 | E1 | MD3N | 输出 | MIPI 数据 3 负极信号 |
| 30 | E2 | NC | - | NC |
| 31 | E3 | NC | - | NC |
| 32 | E4 | DVDD | 电源 | 1.2 V 数字电源 |
| 33 | E5 | MD0P | 输出 | MIPI 数据 0 正极信号 |
| 34 | E6 | MD2P | 输出 | MIPI 数据 2 正极信号 |
| 35 | E7 | NC | - | NC |

**封装引脚图（Top View）：**

| A1 | A2 | A3 | A4 | A5 | A6 | A7 |
|----|----|----|----|----|----|----|
| AGND | NC | EXTCLK | SDA | SCL | XSHUTDN | EFSYNC |
| B1 | B2 | B3 | B4 | B5 | B6 | B7 |
| AVDD | DOGND | FSYNC | DVDD | SID | DVDD | AVDD |
| C1 | C2 | C3 | C4 | C5 | C6 | C7 |
| DVDD | NC | DOVDD | MCP | MD2N | PWDNB_NC | AGND |
| D1 | D2 | D3 | D4 | D5 | D6 | D7 |
| MD3P | MD1N | MD1P | MCN | MD0N | DOGND | VREFN/VREFN2 |
| E1 | E2 | E3 | E4 | E5 | E6 | E7 |
| MD3N | NC | NC | DVDD | MD0P | MD2P | NC |

---

## 6. 订购信息

**表 6-1 订购信息表**

| 产品编号 | 封装形式 | 描述 |
|----------|----------|------|
| SC431HAI-CSMNN00 | 35-pin CSP | 4 Megapixel, RAW/RGB, MIPI output |
| SC431HAI-CSMNF00 | 35-pin CSP | 4 Megapixel, RAW/RGB, MIPI output (贴膜) |

---

## 7. 版本变更记录

| 日期 | 版本 | 修改内容以及说明 |
|------|------|------------------|
| 2023-08-08 | 0.1 | 初始版本 |
| 2023-08-16 | 0.2 | 关键参数：增加 HDR 模式动态范围参数；产品特性：模拟增益改为 48 x；表 2-7 模拟增益值控制寄存器：删除 8'h3F 后面的增益值 |
| 2023-09-13 | 0.3 | AGC 控制寄存器说明：增加寄存器 16’h3e08 的备注；更改 SC431HAI 的 DIG FINE GAIN 的精度为 1/32 |
| 2023-11-29 | 0.4 | 更新产品名为"SC431HAI" |
| 2024-04-09 | 0.5 | 补充 LED Strobe 章节 |
| 2024-05-09 | 0.6 | 表 2-5 曝光的手动控制寄存器：更新行交叠 HDR 模式下长曝光时间和短曝光时间的最小值 |
| 2024-07-12 | 1.0 | 关键参数：MIPI 输出接口增加 8-bit；更新镜头光学尺寸、灵敏度和 CDM 等级；最大图像传输速率删除内供电源；MIPI：推荐传输速率最大值修改为 1.4 Gbps；表 2-2 LED Strobe 控制寄存器（模式2）：LED Strobe 脉冲宽度寄存器值单位修改；表 2-3 Slave mode 控制寄存器：更新 VTS 最大帧长；删除 EFSYNC OEN；表 2-4 HDR 控制寄存器：更新 SE start point 的默认值；表 2-9 Group hold 控制寄存器：更新帧延迟控制描述；AGC 控制寄存器说明：删除"将寄存器 16’h3e03 的 Bit[3:0] 设置为 4’hb"；表 5-2 引脚描述：更新 FSYNC 和 DVDD 描述；行交叠 HDR：Max long exposure 修改；表 3-3 外部时钟参数：删除交流参数；图 1-1 结构图和图 1-2 典型应用示意图：补充 FSYNC 输入；图 1-4 下电时序图：更新注释；表 5-1 封装尺寸表：更新封装尺寸 |
| 2024-08-16 | 1.1 | 表 1-1 睡眠模式控制寄存器：补充低功耗软睡眠模式使能；表 2-3 Slave mode 控制寄存器：补充 EFSYNC IEN |

---

## 联系我们

**总部**
- 地址：上海市闵行区田林路889号绿洲四期8号楼
- 电话：021-64853570
- 邮箱：sales@smartsenstech.com
- 网址：http://www.smartsenstech.com

**美国分公司**
- 地址：4340 Stevens Creek Blvd. Suite 280, San Jose, CA 95129
- 电话：+1（408）981-6626

**深圳分公司**
- 地址：深圳市龙岗区坂田街道雅宝路1号星河WORLD B座2801室
- 电话：0755-23739713

**思特威技术支持邮箱：** support@smartsenstech.com

---

*www.smartsenstech.com 版权所有 © 思特威（上海）电子科技股份有限公司*
