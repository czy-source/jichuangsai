import os

sim_dir = os.path.join("..", "02_fpga_verilog", "sim")
result_log = os.path.join(sim_dir, "result_log.txt")

if not os.path.exists(result_log):
    print("result_log.txt not found at", result_log)
    exit(0)

cnt = 0
with open(result_log, "r") as f:
    lines = f.readlines()

# 过滤掉 area=0 的空帧结果，只保留有效帧
valid_frames = []
i = 0
while i < len(lines):
    if lines[i].startswith("[FRAME]"):
        # 提取 area
        parts = lines[i].split()
        area_val = 0
        for p in parts:
            if p.startswith("area="):
                area_val = int(p.split("=")[1])
                break
        # 收集当前帧的三行（FRAME/SHAPE/SIZE）
        frame_lines = [lines[i]]
        if i + 1 < len(lines) and lines[i+1].startswith("[SHAPE]"):
            frame_lines.append(lines[i+1])
        if i + 2 < len(lines) and lines[i+2].startswith("[SIZE ]"):
            frame_lines.append(lines[i+2])
        if area_val > 0:
            valid_frames.extend(frame_lines)
        i += len(frame_lines)
    elif lines[i].startswith("CID"):
        cnt += 1
        i += 1
    else:
        i += 1

for line in valid_frames:
    print(line.strip())

print(f"\nColor output count: {cnt} pixels")

if not valid_frames:
    print("Warning: No valid FRAME/SHAPE/SIZE results found in log.")
    print("If you just regenerated img_data.txt, please re-run: python run_sim.py")
