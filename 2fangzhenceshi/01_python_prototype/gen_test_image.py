import numpy as np
from PIL import Image, ImageDraw
import os

W, H = 100, 100

# 背景白
img = Image.new("RGB", (W, H), (240, 240, 240))
draw = ImageDraw.Draw(img)

# 画一个红色形状（你可切换：rectangle/ellipse/polygon）
# rectangle -> cube-like
# ellipse   -> cylinder-like
# triangle  -> cone-like

shape_type = "ellipse"  # "rectangle" / "ellipse" / "triangle"

if shape_type == "rectangle":
    draw.rectangle([30, 30, 70, 70], fill=(220, 20, 20))
elif shape_type == "ellipse":
    draw.ellipse([28, 28, 72, 72], fill=(220, 20, 20))
elif shape_type == "triangle":
    draw.polygon([(50, 25), (75, 75), (25, 75)], fill=(220, 20, 20))

# 保存测试图片到测试图片目录
img.save(os.path.join("..", "05_test_images", "test.png"))
arr = np.array(img, dtype=np.uint8)

# 导出为 img_data.txt 到仿真目录，供 testbench 读取
sim_dir = os.path.join("..", "02_fpga_verilog", "sim")
os.makedirs(sim_dir, exist_ok=True)
img_data_path = os.path.join(sim_dir, "img_data.txt")

with open(img_data_path, "w") as f:
    for y in range(H):
        for x in range(W):
            r, g, b = arr[y, x]
            f.write(f"{r:02x}\n")
            f.write(f"{g:02x}\n")
            f.write(f"{b:02x}\n")

print("Generated ../05_test_images/test.png and ../02_fpga_verilog/sim/img_data.txt")
