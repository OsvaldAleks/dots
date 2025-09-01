import subprocess
import re

PREFIX = "~/Pictures/wallpapers/"
paths = ["wallpaper0.png", "wallpaper1.png","wallpaper2.png","wallpaper3.png","wallpaper4.png", "wallpaper5.png","wallpaper6.png","wallpaper7.png","wallpaper8.png","wallpaper9.png","wallpaper10.png"]

current = subprocess.check_output(["hyprctl","hyprpaper","listloaded"]).decode("utf-8")

pattern = re.compile(r"(\d+)(?=\.[^.]+$)")
ix = int(pattern.search(current).group(1))

print(ix)

ix = (ix+1) % len(paths)

print(ix)

subprocess.run(["hyprctl","hyprpaper","preload",PREFIX+paths[ix]])
subprocess.run(["hyprctl","hyprpaper","wallpaper","eDP-1,"+PREFIX+paths[ix]])
subprocess.run(["hyprctl","hyprpaper","wallpaper","HDMI-A-1,"+PREFIX+paths[ix]])
subprocess.run(["hyprctl","hyprpaper","unload","unused"])
