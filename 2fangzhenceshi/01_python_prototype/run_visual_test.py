import os
import subprocess
import re
import cv2
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image, ImageDraw

# 配置路径
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
IMG_DIR = os.path.join(BASE_DIR, "..", "05_test_images")
VERILOG_SRC_DIR = os.path.join(BASE_DIR, "..", "02_fpga_verilog", "src")
VERILOG_SIM_DIR = os.path.join(BASE_DIR, "..", "02_fpga_verilog", "sim")
TB_FILE = os.path.join(VERILOG_SIM_DIR, "tb_vision_top.v")
SIM_EXE = "vision_sim.vvp"
IMG_DATA_TXT = os.path.join(VERILOG_SIM_DIR, "img_data.txt")
LOG_FILE = os.path.join(VERILOG_SIM_DIR, "result_log.txt")

SHAPE_MAP = {0: "Unknown", 1: "Cube", 2: "Cylinder", 3: "Cone"}
SIZE_MAP = {0: "Unknown", 1: "2.0cm", 2: "2.5cm", 3: "3.0cm"}

# 五色配置
COLORS = [
    {"name": "red",    "id": 1, "rgb": (220, 20, 20),  "bg": (240, 240, 240)},
    {"name": "blue",   "id": 2, "rgb": (20, 20, 220),  "bg": (240, 240, 240)},
    {"name": "yellow", "id": 3, "rgb": (220, 220, 20), "bg": (240, 240, 240)},
    {"name": "black",  "id": 4, "rgb": (20, 20, 20),   "bg": (200, 200, 200)},
    {"name": "white",  "id": 5, "rgb": (255, 255, 255), "bg": (100, 100, 100)},
]

SHAPES = ["rectangle", "ellipse", "triangle"]
EXPECTED_SHAPE = {"rectangle": 1, "ellipse": 2, "triangle": 3}


def draw_shape(draw, shape_type, bbox, fill_color):
    """在 PIL Draw 对象上绘制指定形状"""
    if shape_type == "rectangle":
        draw.rectangle(bbox, fill=fill_color)
    elif shape_type == "ellipse":
        draw.ellipse(bbox, fill=fill_color)
    elif shape_type == "triangle":
        cx = (bbox[0] + bbox[2]) // 2
        top = bbox[1]
        left = bbox[0]
        right = bbox[2]
        bottom = bbox[3]
        draw.polygon([(cx, top), (left, bottom), (right, bottom)], fill=fill_color)


def generate_test_image(color_cfg, shape_type, filename):
    """生成测试图并导出 RGB hex 给 Verilog TB"""
    os.makedirs(IMG_DIR, exist_ok=True)
    os.makedirs(VERILOG_SIM_DIR, exist_ok=True)

    W, H = 100, 100
    bg = color_cfg["bg"]
    fg = color_cfg["rgb"]

    img = Image.new('RGB', (W, H), color=bg)
    draw = ImageDraw.Draw(img)
    draw_shape(draw, shape_type, [28, 28, 72, 72], fg)

    img_path = os.path.join(IMG_DIR, filename)
    img.save(img_path)

    with open(IMG_DATA_TXT, 'w') as f:
        for y in range(H):
            for x in range(W):
                r, g, b = img.getpixel((x, y))
                f.write(f"{r:02x}\n")
                f.write(f"{g:02x}\n")
                f.write(f"{b:02x}\n")
    return img_path


def patch_tb(target_color_id):
    """直接修改 TB 里的 TARGET_COLOR 默认值，避免 iverilog -P 兼容性问题"""
    with open(TB_FILE, 'r', encoding='utf-8') as f:
        content = f.read()
    content = re.sub(
        r"parameter \[2:0\] TARGET_COLOR = 3'd\d+;",
        f"parameter [2:0] TARGET_COLOR = 3'd{target_color_id};",
        content
    )
    with open(TB_FILE, 'w', encoding='utf-8') as f:
        f.write(content)


def run_simulation():
    """编译并运行 Verilog 仿真"""
    v_files = [os.path.abspath(os.path.join(VERILOG_SRC_DIR, f))
               for f in os.listdir(VERILOG_SRC_DIR) if f.endswith('.v')]
    tb_file = os.path.abspath(TB_FILE)
    sim_exe_path = os.path.join(VERILOG_SIM_DIR, SIM_EXE)

    compile_cmd = ["iverilog", "-g2012", "-o", sim_exe_path, tb_file] + v_files
    subprocess.run(compile_cmd, check=True, cwd=VERILOG_SIM_DIR)

    run_cmd = ["vvp", SIM_EXE]
    subprocess.run(run_cmd, check=True, cwd=VERILOG_SIM_DIR)


def parse_simulation_log():
    """解析 result_log.txt，提取非零帧的统计信息"""
    result = {}
    if not os.path.exists(LOG_FILE):
        return result

    with open(LOG_FILE, 'r') as f:
        content = f.read()

    frame_matches = list(re.finditer(
        r'\[FRAME\] area=(\d+) c=\((\d+),(\d+)\) bbox=\((\d+),(\d+),(\d+),(\d+)\)', content))
    for m in frame_matches:
        area = int(m.group(1))
        if area > 0:
            result['area'] = area
            result['centroid'] = (int(m.group(2)), int(m.group(3)))
            result['bbox'] = (int(m.group(4)), int(m.group(5)),
                              int(m.group(6)), int(m.group(7)))

    shape_match = re.findall(r'\[SHAPE\] id=(\d+)', content)
    if shape_match:
        result['shape_id'] = int(shape_match[-1])

    size_match = re.findall(r'\[SIZE \] id=(\d+)', content)
    if size_match:
        result['size_id'] = int(size_match[-1])

    return result


def main():
    fig, axes = plt.subplots(5, 3, figsize=(16, 24))
    fig.suptitle("FPGA Vision Pipeline: 5 Colors × 3 Shapes Full Test", fontsize=18)

    summary_table = []

    for row_idx, color_cfg in enumerate(COLORS):
        for col_idx, shape_type in enumerate(SHAPES):
            print(f"--- Testing {color_cfg['name'].upper()} + {shape_type.upper()} ---")

            # 1. 生成图
            filename = f"test_{color_cfg['name']}_{shape_type}.png"
            img_path = generate_test_image(color_cfg, shape_type, filename)

            # 2. 修改 TB 目标颜色并跑仿真
            patch_tb(color_cfg["id"])
            run_simulation()

            # 3. 解析结果
            res = parse_simulation_log()
            actual_shape = res.get('shape_id', 0)
            area = res.get('area', 0)
            summary_table.append({
                'color': color_cfg['name'].capitalize(),
                'color_id': color_cfg['id'],
                'shape': shape_type.capitalize(),
                'expected': EXPECTED_SHAPE[shape_type],
                'actual': actual_shape,
                'detected': SHAPE_MAP.get(actual_shape, "Unknown"),
                'area': area,
            })

            # 4. 读取并标注
            img_bgr = cv2.imread(img_path)
            img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)

            if 'bbox' in res:
                xmin, xmax, ymin, ymax = res['bbox']
                cv2.rectangle(img_rgb, (xmin, ymin), (xmax, ymax), (0, 255, 0), 1)
            if 'centroid' in res:
                cx, cy = res['centroid']
                cv2.circle(img_rgb, (cx, cy), 2, (255, 0, 0), -1)

            ax = axes[row_idx, col_idx]
            ax.imshow(img_rgb)
            title = (f"{color_cfg['name'].capitalize()} + {shape_type.capitalize()}  |  "
                     f"Area:{area}  Shape:{SHAPE_MAP.get(actual_shape, 'Unk')}  "
                     f"Size:{SIZE_MAP.get(res.get('size_id', 0), 'Unk')}")
            ax.set_title(title, fontsize=10)
            ax.axis('off')

    plt.tight_layout()
    plt.subplots_adjust(top=0.95, hspace=0.35, wspace=0.15)
    save_path = os.path.join(BASE_DIR, "simulation_summary.png")
    plt.savefig(save_path, dpi=150)
    print(f"\nVisualization saved to '{save_path}'.")
    plt.show()

    # 5. 打印比对表
    print("\n================== 5×3 FULL TEST SUMMARY ==================")
    print(f"{'Color':<8} | {'Shape':<10} | {'Exp':<4} | {'Act':<4} | {'Detected':<10} | {'Area':<6} | Status")
    print("-" * 65)
    all_pass = True
    for r in summary_table:
        ok = (r['expected'] == r['actual']) and (r['area'] > 0)
        status = "PASS" if ok else "FAIL"
        if not ok:
            all_pass = False
        print(f"{r['color']:<8} | {r['shape']:<10} | {r['expected']:<4} | {r['actual']:<4} | "
              f"{r['detected']:<10} | {r['area']:<6} | {status}")
    print("-" * 65)
    print(f"Overall: {'ALL PASS' if all_pass else 'SOME FAILED'}")
    print("===========================================================\n")


if __name__ == "__main__":
    main()
