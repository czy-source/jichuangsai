import subprocess
import os
import sys

# 仿真工作目录
sim_dir = os.path.join("..", "02_fpga_verilog", "sim")
os.makedirs(sim_dir, exist_ok=True)

verilog_files = [
    os.path.join("..", "src", "vision_top.v"),
    os.path.join("..", "src", "rgb_packer_3byte.v"),
    os.path.join("..", "src", "rgb2hsv_simple.v"),
    os.path.join("..", "src", "color_threshold_cfg.v"),
    os.path.join("..", "src", "xy_counter.v"),
    os.path.join("..", "src", "color_stats.v"),
    os.path.join("..", "src", "half_region_counter.v"),
    os.path.join("..", "src", "shape_classify.v"),
    os.path.join("..", "src", "size_classify.v"),
    "tb_vision_top.v",
]

cmd_compile = ["iverilog", "-g2012", "-o", "simv"] + verilog_files
cmd_run = ["vvp", "simv"]

print("Compiling in", os.path.abspath(sim_dir), "...")
ret = subprocess.run(cmd_compile, capture_output=True, text=True, cwd=sim_dir)
if ret.returncode != 0:
    print("Compile failed:")
    print(ret.stdout)
    print(ret.stderr)
    sys.exit(1)

print("Running simulation...")
ret = subprocess.run(cmd_run, capture_output=True, text=True, cwd=sim_dir)
print(ret.stdout)
print(ret.stderr)

result_log = os.path.join(sim_dir, "result_log.txt")
if os.path.exists(result_log):
    print("Simulation done.", result_log, "generated.")
else:
    print("Warning: result_log.txt not found.")
