import math
import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_gradient_background(width, height):
    base = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    top_color = (49, 46, 129)      # #312E81 deep indigo
    bottom_color = (15, 23, 42)    # #0F172A slate dark

    # 2D gradient
    for y in range(height):
        t_y = y / float(height - 1)
        for x in range(width):
            t_x = x / float(width - 1)
            t = (t_x * 0.3 + t_y * 0.7)
            r = int(top_color[0] * (1 - t) + bottom_color[0] * t)
            g = int(top_color[1] * (1 - t) + bottom_color[1] * t)
            b = int(top_color[2] * (1 - t) + bottom_color[2] * t)
            base.putpixel((x, y), (r, g, b, 255))

    # Center glow
    glow = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    cx, cy = int(width * 0.5), int(height * 0.45)
    max_r = int(width * 0.55)
    for r in range(max_r, 0, -4):
        alpha = int(50 * (1.0 - r / max_r) ** 2)
        glow_draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(99, 102, 241, alpha))

    return Image.alpha_composite(base, glow)

def generate_full_icon():
    canvas_size = 1024
    bg = create_gradient_background(canvas_size, canvas_size)

    # Fonts
    font_num = ImageFont.truetype('segoeuib.ttf', 115)
    font_small = ImageFont.truetype('segoeuib.ttf', 42)

    # Board shadow
    shadow = Image.new('RGBA', (canvas_size, canvas_size), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(shadow)

    board_size = 660
    bx = (canvas_size - board_size) // 2 # 182
    by = (canvas_size - board_size) // 2 # 182
    radius = 56

    s_box = [bx - 6, by + 20, bx + board_size + 6, by + board_size + 36]
    s_draw.rounded_rectangle(s_box, radius=radius, fill=(0, 0, 0, 110))
    shadow = shadow.filter(ImageFilter.GaussianBlur(28))

    canvas = Image.alpha_composite(bg, shadow)

    # Layer for board and pencil
    board_layer = Image.new('RGBA', (canvas_size, canvas_size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(board_layer)

    # Board Card
    card_box = [bx, by, bx + board_size, by + board_size]
    draw.rounded_rectangle(card_box, radius=radius, fill=(248, 250, 252, 255))
    draw.rounded_rectangle(card_box, radius=radius, outline=(203, 213, 225, 255), width=6)

    # Grid
    padding = 24
    gx = bx + padding
    gy = by + padding
    gsize = board_size - (2 * padding) # 612
    cell_size = gsize / 3 # 204

    # Cell highlights
    # Highlight (1, 1) center cell
    c1_x = gx + 1 * cell_size
    c1_y = gy + 1 * cell_size
    draw.rounded_rectangle(
        [c1_x + 4, c1_y + 4, c1_x + cell_size - 4, c1_y + cell_size - 4],
        radius=16,
        fill=(224, 231, 255, 255) # #E0E7FF soft indigo
    )

    # Highlight (0, 1) top middle cell
    c01_x = gx + 1 * cell_size
    c01_y = gy + 0 * cell_size
    draw.rounded_rectangle(
        [c01_x + 4, c01_y + 4, c01_x + cell_size - 4, c01_y + cell_size - 4],
        radius=16,
        fill=(254, 243, 199, 255) # #FEF3C7 soft amber
    )

    # Grid lines
    line_color = (51, 65, 85, 255) # slate 700
    line_width = 8

    draw.rounded_rectangle([gx, gy, gx + gsize, gy + gsize], radius=20, outline=line_color, width=line_width)
    for i in range(1, 3):
        x = gx + i * cell_size
        draw.line([(x, gy), (x, gy + gsize)], fill=line_color, width=line_width)
        y = gy + i * cell_size
        draw.line([(gx, y), (gx + gsize, y)], fill=line_color, width=line_width)

    # Numbers
    grid_data = [
        (0, 0, '5', 'given'),
        (0, 1, '3', 'user'),
        (1, 0, '6', 'given'),
        (1, 1, '7', 'user'),
        (1, 2, '1', 'given'),
        (2, 0, '8', 'given'),
        (2, 1, '9', 'given'),
        (2, 2, '4', 'user'),
    ]

    color_given = (15, 23, 42, 255)  # slate 900
    color_user = (79, 70, 229, 255)   # indigo 600

    for r, c, val, num_type in grid_data:
        cx = gx + c * cell_size + cell_size / 2
        cy = gy + r * cell_size + cell_size / 2
        color = color_given if num_type == 'given' else color_user

        bbox = font_num.getbbox(val)
        w = bbox[2] - bbox[0]
        h = bbox[3] - bbox[1]

        draw.text((cx - w / 2 - bbox[0], cy - h / 2 - bbox[1]), val, font=font_num, fill=color)

    # Pencil marks in Cell (0, 2)
    c02_x = gx + 2 * cell_size
    c02_y = gy + 0 * cell_size
    color_pencil = (100, 116, 139, 255)

    draw.text((c02_x + 36, c02_y + 28), '2', font=font_small, fill=color_pencil)
    draw.text((c02_x + 120, c02_y + 28), '4', font=font_small, fill=color_pencil)
    draw.text((c02_x + 36, c02_y + 112), '8', font=font_small, fill=color_pencil)

    # Pencil Badge
    px = bx + board_size - 20
    py = by + board_size - 20
    pr = 76

    # Badge shadow
    badge_shadow = Image.new('RGBA', (canvas_size, canvas_size), (0, 0, 0, 0))
    bs_draw = ImageDraw.Draw(badge_shadow)
    bs_draw.ellipse([px - pr - 4, py - pr + 10, px + pr + 4, py + pr + 18], fill=(0, 0, 0, 90))
    badge_shadow = badge_shadow.filter(ImageFilter.GaussianBlur(14))

    canvas = Image.alpha_composite(canvas, board_layer)
    canvas = Image.alpha_composite(canvas, badge_shadow)

    # Draw Badge
    badge_layer = Image.new('RGBA', (canvas_size, canvas_size), (0, 0, 0, 0))
    bl_draw = ImageDraw.Draw(badge_layer)
    bl_draw.ellipse([px - pr, py - pr, px + pr, py + pr], fill=(245, 158, 11, 255), outline=(255, 255, 255, 255), width=8)

    # Rotated Pencil inside Badge
    pencil_img = Image.new('RGBA', (160, 160), (0, 0, 0, 0))
    p_draw = ImageDraw.Draw(pencil_img)
    p_draw.rounded_rectangle([52, 40, 108, 90], radius=4, fill=(255, 255, 255, 255))
    p_draw.rounded_rectangle([52, 40, 108, 54], radius=4, fill=(239, 68, 68, 255)) # Eraser
    p_draw.rectangle([52, 52, 108, 58], fill=(203, 213, 225, 255)) # Eraser band
    p_draw.polygon([(52, 90), (108, 90), (80, 130)], fill=(254, 202, 202, 255)) # Tip wood
    p_draw.polygon([(72, 118), (88, 118), (80, 130)], fill=(30, 41, 59, 255)) # Lead

    pencil_rotated = pencil_img.rotate(-45, resample=Image.BICUBIC, expand=False)
    badge_layer.paste(pencil_rotated, (px - 80, py - 80), pencil_rotated)

    final_icon = Image.alpha_composite(canvas, badge_layer)
    return final_icon, bg, board_layer, badge_layer

if __name__ == '__main__':
    os.makedirs('assets/icon', exist_ok=True)
    full_icon, bg, board_layer, badge_layer = generate_full_icon()

    full_icon.save('assets/icon/app_icon.png', 'PNG')
    bg.save('assets/icon/app_icon_background.png', 'PNG')

    # Foreground image (board + badge transparent bg)
    foreground = Image.alpha_composite(board_layer, badge_layer)
    foreground.save('assets/icon/app_icon_foreground.png', 'PNG')
    print('Generated app_icon.png, app_icon_background.png, app_icon_foreground.png successfully!')
