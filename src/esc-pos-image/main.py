#!/usr/bin/env python3
import sys
import argparse
from PIL import Image, ImageOps

def to_escpos_raster(img: Image.Image, paper_width_px: int = 512) -> bytes:
    """
    Convert PIL image to a single GS v 0 raster graphic command.
    - img is any mode; we convert to 1-bit
    - paper_width_px: 384 (58mm) or 512 (80mm) typical
    """
    # --- 1) Convert to 1-bit BW (with Floyd–Steinberg dithering)
    # convert to L first for consistent results
    g = img.convert("L")
    bw = g.convert("1")

    # --- 2) Resize to fit paper width (maintain aspect)
    if bw.width > paper_width_px:
        h = int(bw.height * (paper_width_px / bw.width))
        bw = bw.resize((paper_width_px, h))

    # --- 3) Pack bits MSB->LSB per 8 pixels
    w, h = bw.size
    width_bytes = (w + 7) // 8
    pixels = bw.load()

    data = bytearray()
    # ESC/POS: GS v 0 m xL xH yL yH [data]
    # m = 0 (normal)
    data += b"\x1d\x76\x30\x00"
    data += bytes([width_bytes & 0xFF, (width_bytes >> 8) & 0xFF])
    data += bytes([h & 0xFF, (h >> 8) & 0xFF])

    for y in range(h):
        for x_byte in range(width_bytes):
            b = 0
            for bit in range(8):
                x = x_byte * 8 + bit
                if x < w:
                    # In 1-bit mode: 0 = black, 255 = white
                    # ESC/POS wants 1 bit per pixel, 1=black. Invert logic.
                    is_black = (pixels[x, y] == 0)
                    if is_black:
                        b |= (1 << (7 - bit))
            data.append(b)

    return bytes(data)

def main():
    ap = argparse.ArgumentParser(description="Print an image to an ESC/POS thermal printer via CUPS (raw).")
    ap.add_argument("image", help="Path to image (PNG/JPG/BMP, etc.)")
    ap.add_argument("-w", "--width", type=int, default=512, help="Paper width in pixels (512 for 80mm, 384 for 58mm)")
    args = ap.parse_args()

    img = Image.open(args.image)
    payload = to_escpos_raster(
        img,
        paper_width_px=args.width,
    )

    # Send raw output to stdout
    sys.stdout.buffer.write(payload)

if __name__ == "__main__":
    main()
