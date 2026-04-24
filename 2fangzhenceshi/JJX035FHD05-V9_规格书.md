# JJX035FHD05-V9 规格书

**3.5" TFT LCD Module**

| | |
|---|---|
| **模块型号 (Module No.)** | JJX035FHD05-V9 |
| **产品类型 (Product type)** | Standard LCD Module |
| **分辨率** | 1920(RGB) x 1080 Pixels |
| **客户 (Customer)** | |
| **客户核准 (Approved)** | |

---

**深圳市聚吉鑫科技有限公司**  
**Shenzhen Jujixin Technology Co., Ltd.**

**SPEC-JJX035FHD05-V9**

**版本 (REV):** V00  
**日期:** 2022-11-25

---

## 目录 (CONTENTS)

| 章节 | 内容 | 页码 |
|------|------|------|
| 1 | 文档修订历史 (Document Revision History) | 3 |
| 2 | 总体描述 (General Description) | 4 |
| 3 | 机械规格 (Mechanical Specifications) | 5 |
| 4 | 接口信号 (Interface Signals) | 6 |
| 5 | 绝对最大额定值 (Absolute Maximum Ratings) | 7 |
| 6 | 电气规格 (Electrical Specifications) | 7 |
| 7 | 光学特性 (Optical Characteristics) | 10 |
| 8 | 数据输入特性 (Data Input Characteristics) | 12 |
| 9 | 环境/可靠性测试 (Environmental/Reliability Test) | 13 |
| 10 | 检验标准 (Inspection Criteria) | 15 |
| 11 | 使用建议 (Suggestions for Using LCD Modules) | 20 |
| 12 | 包装规格 (Packing Specification) | 29 |
| 13 | 提前商议事项 (Prior Consult Matter) | 30 |

---

## 1. 文档修订历史 (Document Revision History)

| 版本 (Revision) | 日期 | 描述 (Description) | 制定 (Prepared By) | 核准 (Approved By) |
|-----------------|------|--------------------|-------------------|--------------------|
| V00 | 2022-11-25 | First Release (初始版本) | XXX | |

---

## 2. 总体描述 (General Description)

- 3.5" inch, 1920(RGB) x 1080 pixels, 16.7M colors, Transmissive, TFT LCD module
- Viewing Direction: Free (自由视角)
- MIPI-4L interface (MIPI 4 Lane 接口)
- Power Supply voltage: 3.0-3.6V (typ.) (供电电压：3.0-3.6V，典型值)
- Without touch panel (无触摸屏)

---

## 3. 机械规格 (Mechanical Specifications)

机械细节见图 1 及下表 Table 1。

**Table 1: 机械规格参数**

| 参数 (Parameter) | 规格 (Specifications) | 单位 (Unit) |
|------------------|------------------------|-------------|
| 外形尺寸 (Outline dimensions) | 87.1(W) x 56.8(H) x 2.75(D) | mm |
| 显示区域 (Active area) | 77.76(W) x 43.74(H) | |
| 显示格式 (Display format) | 1920(RGB) x 1080 | pixels |
| 颜色排列 (Color configuration) | RGB stripes | - |
| 重量 (Weight) | TBD | grams |

### 外形尺寸图 (Outline Drawing)

**正视图尺寸标注:**
- 整体宽度: 87.1±0.2 mm
- 整体高度: 56.8±0.2 mm
- 厚度: 2.75 mm
- 显示区域宽度: 77.76 mm (AA)
- 显示区域高度: 43.74 mm (AA)
- 底部排线区域: BZ OPEN 46.12±0.2 mm
- 未注公差: ±0.20
- "*" 表示重要尺寸 (Critical dimension)
- "()" 表示参考尺寸

**背视图特征:**
- FPC 连接: 51.0±57.2 mm 排线区域
- PI 补强区域: 30.0±3.0 mm
- 元器件区标注

**FPC 引脚排列 (30 Pin 直排):**

| Pin | Symbol | Pin | Symbol | Pin | Symbol |
|-----|--------|-----|--------|-----|--------|
| 1 | LEDA | 11 | D2N | 21 | ALCD_SDI |
| 2 | LEDK | 12 | GND | 22 | ALCD_SDO |
| 3 | GND | 13 | D1P | 23 | VSN |
| 4 | D3P | 14 | D1N | 24 | VSP |
| 5 | D3N | 15 | GND | 25 | RESET |
| 6 | GND | 16 | D0P | 26 | STBYB |
| 7 | CLKP | 17 | D0N | 27 | MTP |
| 8 | CLKN | 18 | GND | 28 | VCC3.3V |
| 9 | GND | 19 | ALCD_CS | 29 | NC |
| 10 | D2P | 20 | ALCD_SCL | 30 | GND |

---

## 4. 接口信号定义 (Interface Description)

FPC 连接器推荐使用 Hirose 制造的 FH12-30S-0.5SH 型号。

**Table 2: 引脚分配 (Pin Assignment)**

| 序号 (Pin No.) | 符号 (Symbol) | I/O | 描述 (Description) | 不用时处理 (When not in use) |
|----------------|---------------|-----|----------------------|------------------------------|
| 1 | LEDA | / | DUMMY | |
| 2 | LEDK | / | DUMMY | |
| 3 | GND | P | Digital ground (数字地) | |
| 4 | D3P | I | MIPI DSI differential data pair (MIPI 差分数据对) | |
| 5 | D3N | I | MIPI DSI differential data pair | |
| 6 | GND | P | Digital ground | |
| 7 | CLKP | I | MIPI DSI differential clock pair (MIPI 差分时钟对) | |
| 8 | CLKN | I | MIPI DSI differential clock pair | |
| 9 | GND | P | Digital ground | |
| 10 | D2P | I | MIPI DSI differential data pair | |
| 11 | D2N | I | MIPI DSI differential data pair | |
| 12 | GND | P | Digital ground | |
| 13 | D1P | I | MIPI DSI differential data pair | |
| 14 | D1N | I | MIPI DSI differential data pair | |
| 15 | GND | P | Digital ground | |
| 16 | D0P | I | MIPI DSI differential data pair | |
| 17 | D0N | I | MIPI DSI differential data pair | |
| 18 | GND | P | Digital ground | |
| 19 | ALCD_CS | I | Chip select signal for SPI interface (SPI 片选信号) | GND |
| 20 | ALCD_SCL | I | Clock signal for SPI interface (SPI 时钟信号) | GND |
| 21 | ALCD_SDI | I | Serial data input for SPI interface (SPI 串行数据输入) | GND |
| 22 | ALCD_SDO | O | Serial data output for SPI interface (SPI 串行数据输出) | NC |
| 23 | VSN | I | Power supply for source driver and power circuit (源驱动和电源电路供电) | |
| 24 | VSP | I | Power supply for source driver and power circuit | |
| 25 | RESET | I | Reset Pin, Low active. Initialization executed when set to Low. 全局复位引脚，低电平有效。建议连接 RC 复位电路以确保稳定性，正常使用时拉高。 | |
| 26 | STBYB | I | Standby mode: 'H': Normal operation (Default); 'L': TCON, SD, power circuit and temp sensor turned off (待机模式：高电平正常操作(默认)，低电平关闭) | |
| 27 | MTP | P | Power supply for MTP circuit (MTP 电路供电) | |
| 28 | VCC3.3V | P | Power supply for LCD (LCD 供电，3.3V) | |
| 29 | NC | / | DUMMY | |
| 30 | GND | P | Digital ground | |

**注：** I: input, O: output, P: Power

**Note 1:** Global reset pin. Active low to enter reset state. Suggest to connect with an RC reset circuit for stability. Normally pull high.

---

## 5. 绝对最大额定值 (Absolute Maximum Ratings)

### 5.1 电气最大额定值 (Electrical Maximum Ratings)

**Table 3: 电气最大额定值 - 用于 IC (VSS = 0V)**

| 参数 (Parameter) | 符号 (Symbol) | 最小值 (Min.) | 最大值 (Max.) | 单位 (Unit) | 备注 (Note) |
|------------------|---------------|---------------|---------------|-------------|-------------|
| Power supply voltage (电源电压) | VCC | -0.3 | +3.6 | V | GND=0 |
| | VGH | +7.2 | +24 | V | |
| | VGL | -15 | -8.0 | V | |
| | VSP | +5 | +7 | V | AGND=0 |
| | VSN | -7 | -5 | V | |

**注 (Note):**
1. VCC, GND must be maintained.
2. The modules may be destroyed if they are used beyond the absolute maximum ratings.
3. Ta = 25 ± 2°C

---

## 6. 电气规格 (Electrical Specifications)

### 6.1 典型工作条件 (Typical Operation Conditions)

(At Ta = 25°C)

**Table 4: 典型工作条件**

| 项目 (Item) | 符号 (Symbol) | 最小值 (MIN) | 典型值 (TYP) | 最大值 (MAX) | 单位 (UNIT) | 备注 (NOTE) |
|-------------|---------------|--------------|--------------|--------------|-------------|-------------|
| Digital Power Supply Voltage For LCD (LCD 数字电源) | VLCC | 3 | 3.3 | 3.6 | V | - |
| Power supply for source driver and power circuit (源驱动和电源电路供电) | VSP | 5 | 6 | 7 | V | |
| Power supply for source driver and power circuit | VSN | -7 | -6 | -5 | V | |

### 6.2 背光驱动条件 (Backlight Driving Conditions)

**Table 5: 背光驱动参数**

| 参数 (Parameter) | 符号 (Symbol) | 条件 (Condition) | 最小值 (Min.) | 典型值 (Typ.) | 最大值 (Max.) | 单位 (Unit) | 备注 (Note) |
|------------------|---------------|-------------------|---------------|---------------|---------------|-------------|-------------|
| Forward Current (正向电流) | IF | - | 38 | 40 | 50 | mA | |
| Forward voltage (正向电压) | VF | IF=40mA | 22.4 | 24 | 27.2 | V | Note 1 |
| Uniformity (均匀性) | △ | IF=40mA | 75 | 80 | - | % | |
| Luminance (亮度) | LV | IF=40mA | 800 | 900 | - | cd/m² | on the module surface, BM-7 |
| LED lifetime (LED 寿命) | - | IF=40mA | 20,000 | - | - | Hr | Note 2 |

**Note 1:** Constant current driving method. The LED Supply Voltage is defined by the number of LED at Ta=25°C and IF=40mA.

**Note 2:** The "LED life time" is defined as the module brightness decrease to 50% original brightness at Ta=25°C and IF=40mA. The LED lifetime could be decreased if operating IF is larger than 40mA.

### 6.3 上电时序 (Power on Sequence)

(参考原规格书图示)

### 6.4 下电时序 (Power off Sequence)

(参考原规格书图示)

---

## 7. 光学特性 (Optical Characteristics)

**Table 6: 光学规格参数**

| 项目 (Items) | 符号 (Symbol) | 条件 (Condition) | 最小值 (Min.) | 典型值 (Typ.) | 最大值 (Max.) | 单位 (Unit) | 备注 (Note) |
|--------------|---------------|-------------------|---------------|---------------|---------------|-------------|-------------|
| Contrast Ratio (对比度) | CR | | | 1000 | | - | Note 1 |
| Response Time (响应时间) | T (TR+TF) | | | 40 | 45 | ms | Note 2 |
| **Chromaticity (色度)** |
| Red | XR | | | 0.307 | | - | |
| | YR | | | 0.338 | | - | |
| Green | XG | | | 0.596 | | - | |
| | YG | | | 0.316 | | - | |
| Blue | XB | | | 0.319 | | - | |
| | YB | | | 0.539 | | - | |
| White | XW | | | 0.151 | | - | |
| | YW | | | 0.161 | | - | |
| **Viewing Angle (视角)** |
| Horizontal (水平) | Φ1 (3 o'clock) | Center, CR≥10 | 70 | 80 | | deg. | |
| | Φ2 (9 o'clock) | | 70 | 80 | | | |
| Vertical (垂直) | θ2 (12 o'clock) | | 70 | 80 | | | |
| | θ1 (6 o'clock) | | 70 | 80 | | | |
| Cell Transmittance (单元透过率) | TR | | 4.5 | 5.5 | | % | |
| NTSC ratio (NTSC 色域) | | | | 45 | | % | |

**Note 1:** Definition of Contrast Ratio (CR):
The contrast ratio can be calculated by the following expression:
- Contrast Ratio (CR) = L63 / L0
- L63: Luminance of gray level 63
- L0: Luminance of gray level 0
- CR = CR(10)
- CR(X) is corresponding to the Contrast Ratio of the point X.

**Note 2:** Definition of Response Time (TR, TF):
(参考原规格书图示 Figure 2)

**Note 3:** Viewing Angle
(参考原规格书图示 Figure 3)
The above "Viewing Angle" is the measuring position with Largest Contrast Ratio; not for good image quality. View Direction for good image quality is ALL Viewing. Module maker can increase the "Viewing Angle" by applying Wide View Film.

**Note 4:** Measurement Set-Up:
The LCD module should be stabilized at a given temperature for 20 minutes to avoid abrupt temperature change during measuring. In order to stabilize the luminance, the measurement should be executed after lighting Backlight for 20 minutes in a windless room.
(参考原规格书图示 Figure 4)

---

## 8. 数据输入特性 (Data Input Characteristics)

### 8.1 输入信号时序 (Input Signal Timing)

适用于 1920RGB x 1080 panel

**Table 7: 输入信号时序参数**

| 项目 (Item) | 符号 (Symbol) | 最小值 (Min.) | 典型值 (Typ.) | 最大值 (Max.) | 单位 (Unit) | 备注 (Remark) |
|-------------|---------------|---------------|---------------|---------------|-------------|---------------|
| DCLK frequency (DCLK 频率) | Fdclk | 135 | 143 | 152 | MHz | |
| Horizontal period (水平周期) | Th | 2044 | 2128 | 2208 | DCLK | |
| Horizontal Display Area (水平显示区) | Thd | - | 1920 | - | DCLK | |
| Horizontal front porch (水平前肩) | Thfp | 36 | 120 | 200 | DCLK | |
| Horizontal back porch (水平后肩) | Thb | 88 | 88 | 88 | DCLK | |
| Horizontal pulse width (水平脉冲宽度) | Thpw | 2 | 2 | 2 | DCLK | |
| Vertical back porch (垂直后肩) | Tv | 1100 | 1120 | 1150 | Th | |
| Vertical Display Area (垂直显示区) | Tvd | - | 1080 | - | Th | |
| Vertical front porch (垂直前肩) | Tvfp | 10 | 20 | 20 | Th | |
| Vertical blanking time (垂直消隐时间) | Tvb | 10 | 20 | 50 | Th | |
| Vertical pulse width (垂直脉冲宽度) | Tvpw | 2 | 2 | 2 | Th | |
| Frame rate (帧率) | FR | | 60 | | HZ | |

---

## 9. 环境/可靠性测试 (Environmental / Reliability Test)

### 9.1 温度和湿度测试 (Temperature and Humidity)

**Table 8: 温湿度测试条件**

| 测试项目 (Test Item) | 试验条件 (Test Condition) | 测试结果判定要点 (Test Result Determinant Gist) |
|-----------------------|--------------------------|-----------------------------------------------|
| High temperature storage (高温存放) | 80±2°C; 240H | 试验结束后，已测试的 LCD 样品必须在室内正常温湿度环境下放置 2~4 个小时以上才能进行功能和外观检查。样品不允许有以下缺陷： |
| Low temperature storage (低温存放) | -30±2°C; 240H | 1. Air bubble in the LCD (模块中有气泡) |
| High temperature operation (高温运行) | 70±2°C; 240H | 2. Seal leak (封口松脱) |
| Low temperature operation (低温运行) | -20±2°C; 240H | 3. Non-display (不显示) |
| Damp Proof Test (防潮试验) | 60°C±3°C, 90%±3% RH; 240H | 4. Missing segments (漏笔) |
| Temperature Shock (冷热冲击) | -10±2°C, 60min → 60±2°C, 60min; 10 cycle | 5. Glass crack (玻璃破碎) |
| Vibration Test (振动试验) | Frequency: 10Hz~55Hz~10Hz; Amplitude: 1.5mm; X, Y, Z direction for total 0.5 hours (Packing condition) | 6. Current Idd is twice higher than initial value (电流 Idd 大于初时值的 2 倍) |
| | | 7. The surface shall be free from damage (表面无损伤) |
| | | 8. The electrical characteristics requirements shall be satisfied (需要满足模块电气性能) |
| Image Sticking (图像残影) | 25°C±2°C; 2hrs | Note 1 |

**注意 (Note):**
1. Operation with test pattern sustained for 2hrs, then change to gray pattern immediately. After 5 mins, the mura must be disappeared completely. (运行测试模式 2 小时，然后马上切换为灰阶模式。5 分钟后，色差完全消失)
2. The test samples should be applied to only one test item. (每个被测试的模块只能用于其中的一个测试项目)
3. Sample size for each test item is 5~10 pcs. (每个测试项目的样品数量为 5～10 片)
4. For Damp Proof Test, Pure water (Resistance > 10MΩ) should be used. (对于防潮试验，试验箱的用水必须是电阻大于 10MΩ 的纯水)
5. In case of malfunction defect caused by ESD damage, if it would be recovered to normal state after resetting, it would be judged as a good part. (如果由静电引起产品故障，当放置一段时间后能够恢复正常，则不视为产品缺陷)

### 9.2 静电放电测试 (带背光) (Electrostatic Discharge with BL)

| 试验项目 (Test Item) | 试验条件 (Test Condition) | 备注 (Remark) |
|-----------------------|--------------------------|---------------|
| ESD | 150pF, 330Ω, Contact: ±4KV, Air: ±8KV | Class B |
| | 200pF, 0Ω, ±200V contact | Test 2 |

**测试点 (Measure Point):**
1. LCD glass and metal bezel (液晶玻璃和金属边框)
2. IF connector pins (连接拼/连接器引脚)

**ESD class B:** Some performance degradation allowed. Self-recoverable. No data lost, no hardware failures. (ESD B 级：允许一些性能缺陷在自我重启后可恢复。没有数据丢失，没有硬件故障)

---

## 10. 检验标准 (Inspection Criteria)

### 10.1. 范围 (Scope)

本进货检验标准适用于深圳市聚吉鑫科技有限公司提供的 TFT-LCD 模块（以下简称"模块"）。

### 10.2. 进货检验 (Incoming Inspection)

客户应在交货日期起二十个日历日内检验模块（"检验期"），检验（接受或拒绝）的费用由客户承担。检验结果应以书面形式记录，并将该书面记录的副本及时发送给卖方。如果买方未在交货日期起二十个日历日内将检验结果发送给卖方，则视为接受该模块。

### 10.3. 检验抽样方法 (Inspection Sampling Method)

- **10.3.1** Lot size: Quantity per shipment lot per model (批量：每批次每型号的数量)
- **10.3.2** Sampling type: Normal inspection, Single sampling (抽样类型：正常检验，单次抽样)
- **10.3.3** Inspection level: II (检验水平：II)
- **10.3.4** Sampling table: GB/T2828.1-2003 (AQL) (抽样表：GB/T2828.1-2003)
- **10.3.5** Acceptable quality level (AQL) (可接受质量水平):
  - Major defect: AQL = 0.65 (主要缺陷)
  - Minor defect: AQL = 1.00 (次要缺陷)

### 10.4. 检验条件 (Inspection Conditions)

- **10.4.1** 环境条件 (Ambient conditions):
  - a. Temperature: Room temperature 25±5°C (温度：室温 25±5°C)
  - b. Humidity: (60±10)%RH (湿度)
  - c. Illumination: Single fluorescent lamp non-directive (300 to 700 Lux) (照明：单荧光灯非直射)
- **10.4.2** 观察距离 (Viewing distance): 35~40 cm
- **10.4.3** Mura & Light leakage inspection at ND-Filter 5% (使用 ND 滤镜 5% 检查 Mura 和漏光)
- **10.4.4** 视角 (Viewing Angle): U/D: 45°/45°, L/R: 45°/45°

### 10.5. 缺陷分类 (Defects Classification)

| 编号 (No.) | 项目 (Item) | 缺陷判定标准 (Criterion for Defects) | 缺陷类型 (Defect Type) |
|------------|-------------|--------------------------------------|----------------------|
| 1 | Black/white spot (黑白点缺陷) | Φ = (x+y)/2；尺寸和可接受数量按面板尺寸分类 | Minor |
| | | **≤4.0 inch:** Φ≤0.1: ignore; 0.1<Φ≤0.15: 3个; 0.15<Φ≤0.25: 2个; Φ>0.25: 0个 | |
| | | **>4.0 inch:** Φ≤0.15: ignore; 0.15<Φ≤0.25: 2个; 0.25<Φ≤0.35: 1个; Φ>0.35: 0个 | |
| 2 | Black/white line defect (黑白线缺陷) | **All inch:** 10<L, 0.03<W≤0.04: 5个; 5.0<L, 0.04<W≤0.06: 3个; L≤10, W≤0.06: ignore; 1.0<L≤5.0, 0.06<W≤0.07: 2个; L≤1.0, 0.07<W≤0.09: 1个 | Minor |
| 3 | Blemish & foreign matters (污点异物) | **Dot ≤4.0 inch:** Φ≤0.1: ignore; 0.10<Φ≤0.15: 2个; 0.15<Φ≤0.25: 1个; 0.25<Φ: 0个 | Minor |
| | | **Dot >4.0 inch:** Φ≤0.15: ignore; 0.15<Φ≤0.25: 2个; 0.25<Φ≤0.35: 1个; Φ>0.35: 0个 | |
| | | **Blemish ≤4.0 inch:** Φ≤0.1: ignore; 0.10<Φ≤0.15: 1个; 0.15<Φ: 0个 | |
| | | **Blemish >4.0 inch:** Φ≤0.15: ignore; 0.15<Φ≤0.25: 2个; 0.25<Φ≤0.35: 1个; Φ>0.35: 0个 | |
| 4 | Line - All inch (线缺陷) | Ignore, W≤0.02: 5个; L≤3.0, 0.02<W≤0.03: 3个; L≤2.0, 0.03<W≤0.05: 2个; W>0.05: Treat with dot | |
| | Stain on LCD surface (LCD 表面污渍) | Stain which cannot be removed even when wiped LCD panel lightly with a soft cloth or similar cleaning tool are rejectable (用软布轻擦无法去除的污渍为不可接受) | Minor |
| 5 | Rust in bezel (边框生锈) | Rust which is visible in the bezel is rejectable | Minor |
| 6 | Defect of contact land surface (接触焊盘缺陷) | Evident crevices which is visible are rejectable | Minor |
| 7 | Parts mounting (元件装配) | (1) failure to mount parts (无法装配); (2) parts not in the specification are mounted (装配了不符合规格的元件); (3) polarity reversed (极性反) | Major |
| 8 | Parts outline alignment (元件外形对准) | (1) LSI, IC lead width is more than 50% beyond pad outline; (2) Chip component is off center and more than 50% of the leads is off the pad outline | Minor |
| 9 | Conductive foreign matter (导电异物) | (1) On open space (GND, manual solder): solder ball allowed up to Φ0.1mm (1EA); (2) In case of shield space: allowed up to Φ0.2mm (1EA) | Major |
| 10 | Faculty PWB correction (线路板修正) | (1) Due to PWB copper foil pattern burnout, pattern connected using a jumper wire for repair; 2 or more places corrected per PWB; (2) Short circuited part is cut, and no resist coating has been performed | Minor |

### 区域定义 (Area Definition)

| 区域 | 描述 |
|------|------|
| **A** | Active area (活动显示区) |
| **B** | Visible area (可视区) |
| **C** | Outside of visible area (Invisible area after assembling) (可视区外，组装后不可见区域) |

Visible Defect in area C that cannot affect product's quality is allowed. (C 区不影响产品质量的可见缺陷可接受)

---

## 11. 使用建议 (Suggestions for Using LCD Modules)

### 11.1 处理注意事项 (Handling of LCM)

**11.1.1** The LCD screen is made of glass. Don't give excessive external shock, or drop from a high place. (液晶屏是用玻璃做成的，不要给过多的外部冲击，或从高处跌落)

**11.1.2** If the LCD screen is damaged and the liquid crystal leaks out, do not lick and swallow. When the liquid is attached to your hand, skin, clothes etc., wash it off by using soap and water thoroughly and immediately. (如果液晶屏幕损坏，液晶泄漏出去，不要舔和吞咽。当液体附着在手、皮肤、衣服等，请立即用肥皂和水彻底清洗)

**11.1.3** Do not apply excessive force to the display surface or the adjoining areas since this may cause the color tone to vary. Do not touch the display with bare hands. This will stain the display area and degraded insulation between terminals (some cosmetics are determined to the polarizer). (请勿施加过大的压力于显示屏或连接部位，否则会引起色调变化。不要用手接触显示屏，这将弄脏显示区和降低端子之间的绝缘能力)

**11.1.4** The polarizer covering the display surface of the LCD module is soft and easily scratched. Handle this polarizer carefully. Do not touch, push or rub the exposed polarizers with anything harder than an HB pencil lead (glass, tweezers, etc.). Do not put or attach anything on the display area to avoid leaving marks on it. Condensation on the surface and contact with terminals due to cold will damage, stain or dirty the polarizer. After products are tested at low temperature they must be warmed up in a container before coming into contact with room temperature air. (覆盖液晶显示模块显示平面的偏光片是软性且易被擦伤，请小心轻拿。请勿用任何硬度大于 HB 铅笔芯的物品接触、撞压或摩擦裸露偏光片。不要放置或粘附物体在显示区域上以免留下痕迹。冷凝在表面和端子将会损坏或弄脏偏光片。产品在低温下测试之后，与室温空气接触之前必须在容器内升温)

**11.1.5** If the display surface becomes contaminated, breathe on the surface and gently wipe it with a soft dry cloth. If it is heavily contaminated, moisten cloth with one of the following solvents:
- Isopropyl alcohol (异丙醇)
- Ethyl alcohol (乙醇)

Do not scrub hard to avoid damaging the display surface. (如果显示平面受污，可对平面吹热气且轻轻地用软性干布擦除。如果受污严重，用含上述溶剂的湿布擦除。请勿用力擦拭以免损坏显示平面)

**11.1.6** Solvents other than those above-mentioned may damage the polarizer. Especially, do not use the following:
- Water (水)
- Ketone (酮)
- Aromatic solvents (芳烃溶剂)

Wipe off saliva or water drops immediately, contact with water over a long period of time may cause deformation or color fading. Avoid contact with oil and fats. (除以上提到的溶剂外，其他溶剂可能会损坏偏光片，特别要避免使用上述溶剂。立即擦掉唾液或水滴，长时间与水接触会引起变形或褪色。避免接触油和油脂)

**11.1.7** Exercise care to minimize corrosion of the electrode. Corrosion of the electrodes is accelerated by water droplets, moisture condensation or a current flow in a high-humidity environment. (特别注意最小限度地减少电极腐蚀，电极腐蚀会因水滴、湿度冷凝或在高湿环境下通电而加速)

**11.1.8** Install the LCD Module by using the mounting holes. When mounting the LCD module make sure it is free of twisting, warping and distortion. In particular, do not forcibly pull or bend the I/O cable or the backlight cable. (使用安装孔装配液晶显示模块，安装时一定不要弯曲、扭曲和变形。要特别注意不要用力拔或弯曲传输线或背光线)

**11.1.9** Do not attempt to disassemble or process the LCD module. (请勿拆卸液晶显示模块)

**11.1.10** NC terminal should be open. Do not connect anything. (悬空端应断开，不要连接任何器件)

**11.1.11** If the logic circuit power is off, do not apply the input signals. (如果逻辑电路电源是断开的，不要施加输入信号)

**11.1.12** Electro-Static Discharge Control: Since this module uses a CMOS LSI, the same careful attention should be paid to electrostatic discharge as for an ordinary CMOS IC. To prevent destruction of the elements by static electricity, be careful to maintain an optimum work environment.
- Before removing LCM from its packing case or incorporating it into a set, be sure the module and your body have the same electric potential. Be sure to ground the body when handling the LCD modules. (液晶显示模块移出包装盒和安装之前，要保证模块和人体具有相同的电位。处理模块时，可靠接地)
- Tools required for assembling, such as soldering irons, must be properly grounded. Make certain the AC power source for the soldering iron does not leak. When using an electric screwdriver to attach LCM, the screwdriver should be of ground potentiality to minimize as much as possible any transmission of electromagnetic waves produced sparks coming from the commutator of the motor. (使用工具如电烙铁，要可靠接地，并确保烙铁使用交流电，不要漏电。用电批固定模块时，电批应接地，尽可能降低电动换向器火花产生的电磁波)
- To reduce the amount of static electricity generated, do not conduct assembling and other work under dry conditions. To reduce the generation of static electricity be careful that the air in the work is not too dry. A relative humidity of 50%-60% is recommended. As far as possible make the electric potential of your work clothes and that of the workbench the ground potential. (为减少静电产生，不在干燥条件下组装。建议相对湿度为 50%-60%。尽可能使工作服和工作台接地)
- The LCD module is coated with a film to protect the display surface. Exercise care when peeling off this protective film since static electricity may be generated. (液晶显示模块表面有一个保护膜。需要小心操作以减少撕保护膜时静电的产生)

**11.1.13** Since LCM has been assembled and adjusted with a high degree of precision, avoid applying excessive shocks to the module or making any alterations or modifications to it.
- Do not alter, modify or change the shape of the tab on the metal frame. (不要改动金属架上的翼片形状)
- Do not make extra holes on the printed circuit board, modify its shape or change the positions of components to be attached. (不要在印制电路板上钻额外的孔，修改形状或更改元件位置)
- Do not damage or modify the pattern writing on the printed circuit board. (不要更改或损坏印制线路板上的图案)
- Absolutely do not modify the zebra rubber strip (conductive rubber) or heat seal connector. (绝对不要更改斑马条或导电纸连接器)
- Except for soldering the interface, do not make any alterations or modifications with a soldering iron. (除焊接接口外，不要用烙铁做任何更改)
- Do not drop, bend or twist the LCM. (不要扔、弯和扭模块)

### 11.2 模块操作规范 (Handing Precautions for LCM)

**11.2.1** LCM is easy to be damaged. Please note below and be careful for handling. (液晶显示模块很容易被损坏，请注意以下并小心操作)

**11.2.2** Correct handling: As above picture, please handle with anti-static gloves around LCM edges. (正确操作：请戴抗静电手套，并拿模块边缘)

**11.2.3** Incorrect handling: (参考原规格书图示 - 错误操作示例)

### 11.3 储存注意事项 (Storage Precautions)

**11.3.1** When storing the LCD modules, the following precaution are necessary. (液晶显示模块的存储依照以下几点)

**11.3.1.1** Store them in a sealed polyethylene bag. If properly sealed, there is no need for the desiccant. (使用聚乙烯袋密封，如果密封得当，不需要干燥剂)

**11.3.1.2** Store them in a dark place. Do not expose to sunlight or fluorescent light, keep the temperature between 0°C and 35°C, and keep the relative humidity between 40%RH and 60%RH. (避光保存，避免直接暴露在太阳光或黄光灯下，保持温度在 0~35°C 之间，保持相对湿度在 40%RH 和 60%RH 之间)

**11.3.1.3** The polarizer surface should not come in contact with any other objects (We advise you to store them in the anti-static electricity container in which they were shipped). (偏光片表面避免接触其他物质，建议存放在货运防静电包装中)

**11.3.2 Others (其它)**

**11.3.2.1** Liquid crystals solidify under low temperature (below the storage temperature range) leading to defective orientation or the generation of air bubbles (black or white). Air bubbles may also be generated if the module is subject to a low temperature. (液晶在低温会凝固，会导致缺陷或产生气泡。如果模块处于低温下，也会产生气泡)

**11.3.2.2** If the LCD modules have been operating for a long time showing the same display patterns, the display patterns may remain on the screen as ghost images and a slight contrast irregularity may also appear. A normal operating status can be regained by suspending use for some time. It should be noted that this phenomenon does not adversely affect performance reliability. (如果液晶显示模块长时间工作于同一个显示图案，换屏时会出现鬼影，也会出现轻微的对比度不均。停止使用一段时间后可恢复到正常状态。此现象不会严重影响性能可靠性)

**11.3.2.3** To minimize the performance degradation of the LCD modules resulting from destruction caused by static electricity etc., exercise care to avoid holding the following sections when handling the modules.
- Exposed area of the printed circuit board (印制电路板裸露区域)
- Terminal electrode sections (印制电路板引出端子区域)

### 11.4 使用液晶显示模块 (Using LCD Modules)

#### 11.4.1 安装液晶显示模块 (Installing LCD Modules)

**11.4.1.1** Cover the surface with a transparent protective plate to protect the polarizer and LC cell. (贴一层透明保护膜来保护偏光片和液晶盒)

**11.4.1.2** When assembling the LCM into other equipment, the spacer to the bit between the LCM and the fitting plate should have enough height to avoid causing stress to the module surface, refer to the individual specifications for measurements. The measurement tolerance should be ±0.1mm. (将模块安装进入其它设备时，模块和安装板之间间隔应有足够的高度以避免模块表面受压。量度公差应是 ±0.1 毫米)

#### 11.4.2 用板对板连接器安装液晶显示模块注意事项 (Precaution for assemble the module with BTB connector)

Please note the position of the male and female connector position, don't assemble or assemble like the method which the following picture shows. (请注意连接器的公母及连接位置，请勿出现错误连接方式)

#### 11.4.3 焊接模块注意事项 (Precaution for soldering the LCM)

| | 手工焊接 (Manual) | 机器拖焊 (Machine drag) | 压焊 (Machine press) |
|---|---|---|---|
| **非环保产品 (NoRoHS)** | 290°C~350°C, Time: 3-5S | 330°C~350°C, Speed: 4-8mm/s | 300°C~330°C, Time: 3-6S, Press: 0.8~1.2Mpa |
| **环保产品 (RoHS)** | 340°C~370°C, Time: 3-5S | 350°C~370°C, Time: 4-8mm/s | 330°C~360°C, Time: 3-6S, Press: 0.8~1.2Mpa |

**11.4.3.1** If soldering flux is used, be sure to remove any remaining flux after finishing soldering operation (This does not apply in the of a non-halogen type of flux). It is recommended that you protect the LCD surface case with a cover during soldering to prevent any damage due to flux spatter. (如果使用助焊剂，完成焊接后一定要清除剩余的助焊剂。建议焊接时用盖子保护显示屏面以避免因焊剂油溅出造成的任何损坏)

**11.4.3.2** When soldering the electroluminescent panel and PC board, the panel and board should not be detached more than three times. This maximum number is determined by the temperature and time conditions mentioned above, though there may be some variance depending on the temperature of the soldering iron. (焊接背光源和线路板时，不应装卸多于三次)

**11.4.3.3** When remove the electroluminescent panel from the PC board, be sure the solder has completely melted, the soldered pad on the PC board could be damaged. (从线路板上移除背光源时，要保证焊锡已完全熔化，不要损坏线路板上的焊接位)

#### 11.4.4 工作运行注意事项 (Precautions for Operation)

**11.4.4.1** Viewing angle varies with the change of liquid crystal driving voltage (VLCD). Adjust VLCD to show the best contrast. (视角应随液晶驱动电压变化而变化，调整 VLCD 可显示最好的对比度)

**11.4.4.2** It is an indispensable condition to drive LCD's within the specified voltage limit since the higher voltage then the limit causes the shorter LCD life. An electrochemical reaction due to direct current causes LCD's undesirable deterioration, so that the use of direct current drives should be avoided. (在液晶驱动电压内来操作模块是必要的。超过限定电压会缩短液晶寿命。直流电会引起液晶的电化学反应，导致液晶老化，因此要避免直流电驱动液晶)

**11.4.4.3** Response time will be extremely delayed at lower temperature than the operating temperature range and on the other hand at higher temperature LCD's show dark color in them. However those phenomena do not mean malfunction or out of order with LCD's, which will come back in the specified operating temperature. (液晶响应时间在低温时比常温要慢，高温时，液晶底色会深。然而这并不是指液晶显示屏工作异常，显示屏在温度恢复时，效果会恢复正常)

**11.4.4.4** If the display area is pushed hard during operation, the display will become abnormal. However, it will return to normal if it is turned off and then back on. (如果在运行过程中显示区受到挤压，显示将会异常。然而挤压中断，将恢复正常)

**11.4.4.5** A slight dew depositing on terminals is a cause for electro-chemical reaction resulting in terminal open circuit. Usage under the maximum operating temperature, 50%RH or less is required. (接线端冷凝会引起电化学反应而断路。因此必须在最大的操作温度之内，湿度小于 50% 的条件下使用液晶显示模块)

**11.4.4.6** Input logic voltage before apply analog high voltage such as LCD driving voltage when power on. Remove analog high voltage before logic voltage when power off the module. Input each signal after the positive/negative voltage becomes stable. (开机时，先让逻辑电压，再接通模拟高压，如显示屏驱动电压。关机时，先断开模拟高压，再关逻辑电压。正负电源都稳定后再送控制信号)

**11.4.4.7** Please keep the temperature within the specified range for use and storage. Polarization degradation, bubble generation or polarizer peel-off may occur with high temperature and high humidity. (模块在操作和存储规格范围内使用。高温高湿可能会引起偏振退化，起泡，偏光片脱落等问题)

#### 11.4.5 安全 (Safety)

**11.4.5.1** It is recommended to crush damaged or unnecessary LCDs into pieces and wash them off with solvents such as acetone and ethanol, which should later be burned. (建议将损坏的液晶显示屏压成碎片，用溶剂诸如丙酮、乙醇冲洗掉，之后烧掉)

**11.4.5.2** If any liquid leaks out of a damaged glass cell and comes in contact with the hands, wash off thoroughly with soap and water. (如果任何液体从液晶盒泄漏出且与手接触，要用肥皂和水彻底清洗)

#### 11.4.6 有限责任 (Limited Warranty)

Unless agreed between Jujixin Technology and the customer, Jujixin Technology will replace or repair any of its LCD modules which are found to be functionally defective when inspected in accordance with Jujixin Technology LCD acceptance standards (copies available upon request) for a period of one year from date of production. Cosmetic/visual defects must be returned to Jujixin Technology within 90 days of shipment. Confirmation of such dates shall be based on data code on product. The warranty liability of Jujixin Technology limited to repair and/or replace on the terms set forth above. Jujixin Technology will not be responsible for any subsequent or consequential events. (除聚吉鑫科技和客户之间另有协议外，自生产之日起一年内，根据聚吉鑫科技的液晶显示屏品质标准，聚吉鑫科技将对有功能缺陷的液晶显示模块换货或返工。外观/视觉缺陷产品，必须在出货后 90 天内归还聚吉鑫科技。聚吉鑫科技保修责任仅限于对符合上述规定的货品进行返工和/或换货。对此后发生的任何情况，聚吉鑫科技均不承担任何责任)

#### 11.4.7 模块保修 (Return LCM under warranty)

**11.4.7.1** No warranty can be granted if the precautions stated above have been disregarded. The typical examples of violations are:
- Broken LCD glass (断裂的液晶显示屏玻璃)
- PCB eyelet is damaged or modified (印制线路板孔修改或损坏)
- PCB conductors damaged (线路板导体损坏)
- Circuit modified in any way, including addition of components (线路随意变更，包括元件变化)
- PCB tampered with by grinding, engraving or painting varnish (印制电路板已修改，如研磨、雕刻、绘涂等)
- Soldering to or modifying the bezel in any manner (焊接或变动模块)

**11.4.7.2** Module repairs will be invoiced to the customer upon mutual agreement. Modules must be returned with sufficient description of the failures or defects. Any connectors or cable installed by the customer must be removed completely without damaging the PCB eyelet, conductors and terminals. (模块维修清单将按双方协议送呈客户。模块详细缺陷描述须模块一并退回。顾客安装的连接器或电缆必须在不破坏线路板孔、线路和引线端条件下全部移去)

---

## 12. 包装规格 (Packing Specification) - 仅供参考 (Reference Only)

### 12.1 包装方式 (Packing Method)

1. Put module into tray cavity (将模块放入托盘)
2. Tray stacking (托盘堆叠)
3. Put 1 cardboard under the tray stack and 1 cardboard above (在托盘堆底部和顶部各放 1 块纸板)
4. Fix the cardboard to the tray stack with adhesive tape (用胶带将纸板固定到托盘堆上)
5. Put the tray stack into carton (将托盘堆放入纸箱)
6. Carton sealing with adhesive tape (用胶带封箱)

### 12.2 箱子标签 (Box Label)

**标签尺寸:** 105mm (L) x 74.25mm (W)

**标签内容:**
- Model: JJX053FHD05-V9
- Q'ty: Quantity in one box
- Date: Packing Date

---

## 13. 提前商议事项 (Prior Consult Matter)

1. For Jujixin Technology standard products, we keep the right to change material, process ...for improving the product property without prior notice to our customer. (对于聚吉鑫科技的标准产品，我们保留在不通知客户的情况下，为提高产品性能而改变原材料及加工方法等的权利)

2. For OEM products, if any changes are needed which may affect the product property, we will consult with our customer in advance. (对于 OEM 产品，如果需要做任何会影响到产品性能的改变，我们会提前和客户商议)

3. If you have special requirement about reliability condition, please let us know before you start the design on our samples. (如对可靠性条件有特殊要求，请在模块设计开发前通知我们)

---

**深圳市聚吉鑫科技有限公司**  
**Shenzhen Jujixin Technology Co., Ltd.**

E-Mail: sales00@szjujixin.com  
WEB: http://www.szjujixin.com

**地址:** 深圳市聚吉鑫科技有限公司

---

*SPEC-JJX035FHD05-V9*  
*25/11/2022 REV00*
