import sys
# pyrefly: ignore [missing-import]
from PIL import Image
import os

# Source logo path (the user's uploaded image)
src = sys.argv[1]
project = sys.argv[2]

img = Image.open(src).convert("RGBA")

# Android mipmap sizes
sizes = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

res_dir = os.path.join(project, "android", "app", "src", "main", "res")

for folder, size in sizes.items():
    out_dir = os.path.join(res_dir, folder)
    os.makedirs(out_dir, exist_ok=True)
    
    # Regular icon
    resized = img.resize((size, size), Image.LANCZOS)
    resized.save(os.path.join(out_dir, "ic_launcher.png"), "PNG")
    
    # Round icon (same image for now)
    resized.save(os.path.join(out_dir, "ic_launcher_round.png"), "PNG")
    
    print(f"Created {folder}: {size}x{size}")

# Also create web icons
web_dir = os.path.join(project, "web", "icons")
os.makedirs(web_dir, exist_ok=True)

for web_size in [192, 512]:
    resized = img.resize((web_size, web_size), Image.LANCZOS)
    resized.save(os.path.join(web_dir, f"Icon-{web_size}.png"), "PNG")
    resized.save(os.path.join(web_dir, f"Icon-maskable-{web_size}.png"), "PNG")
    print(f"Created web icon: {web_size}x{web_size}")

# Create favicon
favicon = img.resize((32, 32), Image.LANCZOS)
favicon.save(os.path.join(project, "web", "favicon.png"), "PNG")
print("Created favicon: 32x32")

print("All icons generated successfully!")
