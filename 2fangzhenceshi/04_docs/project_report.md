<div align="center">

# 🔬 FPGA 视觉处理仿真系统
## 项目技术汇报

**项目状态** 🟢 仿真闭环已跑通 | **测试覆盖** 5 色 × 3 形 = 15 组全通过  
**核心能力** 颜色识别 → ROI 统计 → 形状判别 → 尺寸分级

---

</div>

## 📋 目录

- [一、项目概述](#一项目概述)
- [二、参考开源项目与技术来源](#二参考开源项目与技术来源)
- [三、系统架构](#三系统架构)
- [四、模块详解](#四模块详解)
- [五、测试方案与结果](#五测试方案与结果)
- [六、关键调试记录](#六关键调试记录)
- [七、仿真日志解读](#七仿真日志解读)
- [八、项目文件结构](#八项目文件结构)
- [九、后续工作](#九后续工作)
- [十、快速开始](#十快速开始)

---

## 一、项目概述

### 1.1 项目目标

在 FPGA 仿真环境（**Icarus Verilog**）下，搭建一条完整的**实时图像处理流水线**。系统接收 100×100 的 RGB 字节流，经过 8 级 Verilog 模块串行处理后，输出目标的：

| 输出项 | 说明 |
|:---:|:---|
| 🎨 `color_id` | 颜色类别（红 / 蓝 / 黄 / 黑 / 白） |
| 📐 `area` | 目标像素面积 |
| 📍 `centroid` | 目标质心坐标 `(cx, cy)` |
| 🔲 `bbox` | 边界框 `(xmin, xmax, ymin, ymax)` |
| 🔷 `shape_id` | 形状类别（Cube / Cylinder / Cone） |
| 📏 `size_id` | 尺寸分级（2.0cm / 2.5cm / 3.0cm） |

### 1.2 自动化验证流程

整个验证流程已实现 **100% 自动化**，一键完成：

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Python 生成    │ → │  iverilog 编译  │ → │   vvp 运行仿真   │
│  测试图 + 数据  │    │  Verilog 源码   │    │  生成日志 + 波形 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         ↓                                              ↓
┌─────────────────┐                         ┌─────────────────┐
│  OpenCV 可视化  │ ←────────────────────── │  result_log.txt │
│  汇总图 + 报告  │    Python 解析日志       │  + wave_vision  │
└─────────────────┘                         └─────────────────┘
```

---

## 二、参考开源项目与技术来源

本项目在以下高质量开源工程基础上进行二次开发与适配，充分借鉴其架构设计与算法思想，并结合赛题要求进行裁剪与优化。

### 2.1 lauchinyuan/Verilog_IMG_PROC

- **项目地址**：https://github.com/lauchinyuan/Verilog_IMG_PROC
- **核心功能**：纯 Verilog 图像处理流水线库（RGB2HSV、Sobel 边缘检测、形态学滤波、直方图统计）
- **本项目借鉴**：
  - 像素级串行流水线架构（`vsync/hsync/de/data` 标准视频流时序）
  - RGB → HSV 颜色空间转换的数学实现思路
- **我们的修改**：将完整 rgb2hsv 简化为轻量组合逻辑版（`rgb2hsv_simple.v`），去除查表 ROM 与复杂状态机，降低 LUT 资源占用，适配小型 FPGA

### 2.2 kaangursoy1/Real-Time-Image-Processing-on-Zynq-FPGA

- **项目地址**：https://github.com/kaangursoy1/Real-Time-Image-Processing-on-Zynq-FPGA-PES-DHL-Project-
- **核心功能**：基于 Zynq 的工业分拣视觉系统（HSV 阈值过滤 → 质心计算 → 边界框提取 → 形状/尺寸识别）
- **本项目借鉴**：
  - ROI 帧级统计方法（面积累加器、质心坐标公式 `Σx/area`、BBox 极值更新）
  - 形状判别策略（**面积占比 + 宽高比**区分 Cube/Cylinder/Cone）
  - 尺寸分级思路（面积阈值法映射真实物理尺寸）
- **我们的修改**：将 Zynq 平台的 PS+PL 软硬协同逻辑迁移为**纯 Verilog 流水线**；新增 `half_region_counter` 模块，引入**上下半区像素比例**特征，增强 Cone 判别的鲁棒性

### 2.3 Efinix-Inc/evsoc（Edge Vision SoC）

- **项目地址**：https://github.com/Efinix-Inc/evsoc
- **核心功能**：Efinix 官方异构 SoC 框架（RISC-V Sapphire 硬核、MIPI CSI 摄像头、DDR 缓存、DMA、HDMI/OSD 显示）
- **本项目借鉴**：
  - **RISC-V + FPGA 异构架构设计思想**（硬件加速像素流水线 + 软件控制算法参数）
  - AXI4-Stream / AXI-Lite 总线互联方案，为后续软硬协同预留接口
- **当前状态**：本项目处于**纯仿真验证阶段**（Icarus Verilog + Python 驱动），已验证算法正确性；后续计划将视觉流水线封装为 AXI-Stream IP 核，挂载至 evsoc 的 RISC-V 总线，完成从仿真到真实硬件的迁移

---

## 三、系统架构

### 3.1 顶层数据流

```
in_data (R,G,B 字节流)
    │
    ▼
┌─────────────────────┐
│ rgb_packer_3byte    │  字节流 → 像素包 (r,g,b) + 同步信号
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ rgb2hsv_simple      │  RGB → HSV 颜色空间转换
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ color_threshold_cfg │  HSV 阈值分类 → color_id (0~5)
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ xy_counter          │  生成像素坐标 (x, y)
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ color_stats         │  ROI 统计: area / centroid / bbox
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ half_region_counter │  上下半区像素计数 upper_cnt / lower_cnt
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ shape_classify      │  几何特征法 → shape_id (1~3)
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ size_classify       │  面积阈值法 → size_id (1~3)
└─────────────────────┘
    │
    ▼
out_valid, shape_id, size_id, area, centroid, bbox
```

### 2.2 关键技术点

| 技术 | 说明 |
|:---|:---|
| **流水线架构** | 像素级串行处理，每来一个像素推进一步，一帧结束即出结果 |
| **HSV 颜色空间** | 相比 RGB，H（色相）对光照变化不敏感，更适合阈值分割 |
| **几何特征法** | 不依赖神经网络，纯组合逻辑 + 计数器，FPGA 资源占用极低 |
| **参数化设计** | `TARGET_COLOR` 为 Verilog parameter，编译时可切换目标颜色 |

---

## 四、模块详解

### 3.1 前端：像素预处理

| 模块 | 核心功能 | 算法/原理 |
|:---|:---|:---|
| `rgb_packer_3byte` | 3 字节打包成 1 像素 | 状态机计数 `byte_cnt`，R→G→B 顺序缓存 |
| `rgb2hsv_simple` | RGB → HSV 转换 | `maxv/minv/delta` 求极值，查表公式算 H/S/V |
| `color_threshold_cfg` | 像素颜色分类 | 多级 if-else 阈值判断，**全部参数可配置** |

**颜色分类规则（当前阈值）：**

```
IF   V < 50                    → Black  (id=4)
ELIF S < 50 AND V > 200        → White  (id=5)
ELIF H 在红色范围 AND S>80      → Red    (id=1)
ELIF H 在蓝色范围 AND S>80      → Blue   (id=2)
ELIF H 在黄色范围 AND S>80      → Yellow (id=3)
ELSE                            → Unknown(id=0)
```

### 3.2 中端：ROI 统计

| 模块 | 核心功能 | 算法/原理 |
|:---|:---|:---|
| `xy_counter` | 像素坐标生成 | `vsync` 清零，`hsync` 换行，`en` 自增 |
| `color_stats` | 帧级目标统计 | 面积=计数器累加；质心=Σx/area, Σy/area；BBox=实时极值 |
| `half_region_counter` | 上下半区统计 | `y_mid = (ymin + ymax) / 2`，按中线分割计数 |

### 3.3 后端：判别输出

| 模块 | 核心功能 | 判别依据 |
|:---|:---|:---|
| `shape_classify` | 形状识别 | **面积占比** + **宽高比** + **上下半区比例** |
| `size_classify` | 尺寸分级 | 纯面积阈值三段划分 |

**形状判别逻辑：**

| 形状 | 面积 / BBox 占比 | 宽高比 | 上下半区特征 |
|:---:|:---:|:---:|:---|
| **Cube** (id=1) | > 88% | ≈ 1:1 | 无特殊要求 |
| **Cylinder** (id=2) | 68% ~ 88% | ≈ 1:1 | 无特殊要求 |
| **Cone** (id=3) | 35% ~ 65% | — | `lower_cnt` 明显多于 `upper_cnt` |

> 💡 **原理**：三角形/圆锥下半截更宽，像素更多；椭圆比矩形少四个角，面积占比略低。

---

## 五、测试方案与结果

### 4.1 测试矩阵

为验证系统对**颜色**和**形状**的联合识别能力，设计 **5 × 3 = 15 组**全组合测试：

| 颜色 ⬇️ 形状 ➡️ | Rectangle（矩形） | Ellipse（椭圆） | Triangle（三角） |
|:---:|:---:|:---:|:---:|
| **🔴 Red** | ✅ Cube | ✅ Cylinder | ✅ Cone |
| **🔵 Blue** | ✅ Cube | ✅ Cylinder | ✅ Cone |
| **🟡 Yellow** | ✅ Cube | ✅ Cylinder | ✅ Cone |
| **⚫ Black** | ✅ Cube | ✅ Cylinder | ✅ Cone |
| **⚪ White** | ✅ Cube | ✅ Cylinder | ✅ Cone |

> **预期规则**：矩形 → Cube | 椭圆 → Cylinder | 三角形 → Cone

### 4.2 自动化测试脚本

**运行指令：**

```bash
cd 01_python_prototype
python run_visual_test.py
```

**脚本自动完成：**
1. 生成 15 张测试图（`test_red_rectangle.png` ... `test_white_triangle.png`）
2. 自动修改 Verilog `TARGET_COLOR` 参数切换目标颜色
3. 编译运行 15 次仿真（`iverilog` + `vvp`）
4. 解析 `result_log.txt` 提取识别结果
5. 弹出 **5×3 可视化汇总窗口**
6. 命令行输出 **PASS/FAIL 报告**

### 4.3 典型测试输出

以 **Red + Ellipse** 为例：

```text
[FRAME] area=1581 c=(49,51) bbox=(27,71,29,73)
[SHAPE] id=2
[SIZE ] id=2
```

| 字段 | 值 | 含义 |
|:---|:---:|:---|
| `area` | 1581 | 红色目标像素面积 |
| `centroid` | (49, 51) | 质心坐标（图像中心偏右下） |
| `bbox` | (27,71,29,73) | 边界框：左27 右71 上29 下73 |
| `shape_id` | 2 | **Cylinder（圆柱/椭圆）** ✅ |
| `size_id` | 2 | **2.5 cm** |

---

## 六、关键调试记录

### 5.1 Bug 描述

在 15 组全测试中，**`Black + Triangle`** 组合被错误识别为 `Unknown`。

### 5.2 根因分析

这是一个 **跨模块时序死锁** 问题：

```
half_region_counter              shape_classify
       │                              │
       │  frame_done 上升沿           │
       │  更新 upper_cnt/lower_cnt    │  同一拍读取 upper_cnt/lower_cnt
       │         (<= 非阻塞赋值)       │  读到的是旧值！
       ▼                              ▼
```

| 颜色 | 空帧 dummy 像素 | 是否被 target_color 统计 | 第一帧输出 | 第二帧读到 | 三角形判断 `lower*10 >= upper*12` |
|:---:|:---:|:---:|:---:|:---:|:---:|
| Red/Blue/Yellow/White | V=1 → 判为 Black | ❌ 不等于 target_color | `0, 0` | `0, 0` | `0 >= 0` ✅（蒙混过关） |
| **Black** | V=1 → 判为 Black | ✅ 等于 target_color | `3, 0` | `3, 0` | `0 >= 36` ❌ **失败** |

### 5.3 修复方案

在 `shape_classify.v` 中加入 **1 拍延迟寄存器 `in_valid_d`**：

```verilog
always @(posedge clk) begin
    in_valid_d <= in_valid;      // 延迟 1 拍
end

always @(posedge clk) begin
    if (in_valid_d) begin         // 用延迟后的信号触发判别
        // 此时 upper_cnt/lower_cnt 已稳定更新
        shape_id <= ...;
    end
end
```

**修复后 15 组全部 PASS。**

---

## 七、仿真日志解读

### 6.1 日志来源

`result_log.txt` 由 `tb_vision_top.v` 在仿真运行时实时写入：

```verilog
initial begin
    fout = $fopen("result_log.txt", "w");   // 创建日志文件
end

always @(posedge clk) begin
    if (color_en)  $fdisplay(fout, "CID %0d", color_id);       // 逐像素颜色
    if (frame_done) $fdisplay(fout, "[FRAME] area=%0d ...");   // 帧级统计
    if (shape_valid) $fdisplay(fout, "[SHAPE] id=%0d", shape_id); // 形状
    if (size_valid)  $fdisplay(fout, "[SIZE ] id=%0d", size_id);  // 尺寸
end
```

### 6.2 日志格式速查

| 前缀 | 示例 | 含义 |
|:---:|:---|:---|
| `CID X` | `CID 1` | 单个像素的颜色分类。`X`: 0未知/1红/2蓝/3黄/4黑/5白 |
| `[FRAME]` | `[FRAME] area=1581 c=(49,51) bbox=(27,71,29,73)` | 一帧结束后的 ROI 统计 |
| `[SHAPE]` | `[SHAPE] id=2` | 形状判别结果：`1=Cube`/`2=Cylinder`/`3=Cone` |
| `[SIZE ]` | `[SIZE ] id=2` | 尺寸分级结果：`1=2.0cm`/`2=2.5cm`/`3=3.0cm` |

### 6.3 VCD 波形文件

Testbench 同时生成 `wave_vision.vcd`，可用 **GTKWave** 打开查看时序波形：

```bash
cd 02_fpga_verilog/sim
gtkwave wave_vision.vcd
```

| 文件类型 | 用途 | 查看工具 |
|:---:|:---:|:---:|
| `result_log.txt` | 算法结果（文本） | Python / 文本编辑器 |
| `wave_vision.vcd` | 时序波形（二进制） | GTKWave |

---

## 八、项目文件结构

```
2fangzhenceshi/
├── 📁 01_python_prototype/          # Python 仿真驱动脚本
│   ├── gen_test_image.py           # 单图生成（手动调参）
│   ├── run_sim.py                  # 单轮仿真驱动
│   ├── parse_result.py             # 单日志解析
│   └── ⭐ run_visual_test.py       # 15组全自动化批量测试 + 可视化
│
├── 📁 02_fpga_verilog/
│   ├── 📁 src/                      # Verilog 设计源码（9个模块）
│   │   ├── vision_top.v            # 顶层模块（含 TARGET_COLOR 参数）
│   │   ├── rgb_packer_3byte.v      # RGB 字节打包
│   │   ├── rgb2hsv_simple.v        # RGB→HSV 转换
│   │   ├── color_threshold_cfg.v   # 颜色分类（可配置阈值）
│   │   ├── xy_counter.v            # 像素坐标计数器
│   │   ├── color_stats.v           # ROI 统计（面积/质心/BBox）
│   │   ├── half_region_counter.v   # 上下半区像素统计
│   │   ├── shape_classify.v        # 几何特征法形状判别
│   │   └── size_classify.v         # 面积阈值法尺寸分级
│   │
│   └── 📁 sim/
│       └── tb_vision_top.v         # Testbench（生成日志 + VCD波形）
│
├── 📁 03_riscv_software/            # 预留（RISC-V 软件层）
│
├── 📁 04_docs/
│   └── project_report.md           # 📄 本文件
│
└── 📁 05_test_images/               # 测试图像输出
    └── test_*.png                  # 生成的 15 张测试图
```

---

## 九、后续工作

### 🔴 高优先级（比赛前必须完成）

| 任务 | 说明 | 方法建议 |
|:---|:---|:---|
| **HSV 阈值标定** | 当前阈值是经验值，必须根据现场光照重新调 | 用 OpenCV trackbar 对着实拍图调参，数值写回 `vision_top.v` |
| **Size 面积阈值标定** | 当前基于 100×100 仿真图，真实分辨率/物距不同 | 用尺子量实物，在真实拍摄距离下统计各尺寸的像素面积 |

### 🟡 中优先级（功能增强）

| 任务 | 说明 |
|:---|:---|
| **多目标同时跟踪** | 当前只能跟踪一种 `TARGET_COLOR`。如需同时识别红蓝黄，需多例化或轮询 |
| **AXI-Stream 接口** | 当前为自定义字节流接口，若接 DDR/RISC-V 建议改为标准 AXI-Stream |

### 🟢 低优先级（工程优化）

| 任务 | 说明 |
|:---|:---|
| **接入真实摄像头** | 仿真验证通过后，替换为 CMOS 摄像头实时像素流 |
| **时序优化** | 当前 rgb2hsv 含除法器，综合后可能成为关键路径，可换查表法或流水线除法 |

---

## 十、快速开始

### 环境准备

```bash
# 安装 Python 依赖
pip install opencv-python matplotlib numpy pillow

# 安装 Verilog 仿真器（Icarus Verilog）
# Windows: 下载安装包 或 pacman -S iverilog
# Linux:   sudo apt-get install iverilog
```

### 一键运行 15 组全测试

```bash
cd 01_python_prototype
python run_visual_test.py
```

**预期输出：**
- 命令行打印 15 轮仿真进度
- 自动生成 `simulation_summary.png`
- **弹出 5×3 可视化窗口**
- 命令行输出 `ALL PASS` 报告

---

<div align="center">

**汇报人**：陈振宇 
**日期**：2026-04-17  
**版本**：v1.0 — 仿真闭环已通，算法验证完毕，待现场标定

</div>
