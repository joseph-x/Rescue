shader_type canvas_item;

uniform float progress  : hint_range(0.0, 1.0) = 0.0;
uniform vec3  bar_color  = vec3(1.0, 0.12, 0.12); // 红色直线
uniform float bar_half  = 0.06;                  // 直线在 UV 里的半高

void fragment() {
    float yc = 0.5;
    // 竖直方向限制在中间 -> 直线
    float line = 1.0 - smoothstep(bar_half, bar_half + 0.02, abs(UV.y - yc));

    // 已填充的直线部分
    float filled = step(UV.x, progress) * line;

    // 头部距离与辉光
    float dist = UV.x - progress;
    // float glow = exp(-abs(dist) * 40.0) * line;      // 红晕
    // float core = exp(-abs(dist) * 140.0) * line;     // 亮核

    // 呼吸脉动
    // float pulse = 0.8 + 0.2 * sin(TIME * 6.0);

    vec3 col = bar_color * filled;
    // col += vec3(1.0, 0.35, 0.35) * glow * 0.9 * pulse; // 外晕
    // col += vec3(1.0, 0.85, 0.85) * core * 1.6;         // 白亮核

    // float alpha = max(filled, max(glow * pulse, core));
    // COLOR = vec4(col, alpha);
	COLOR = vec4(col, filled);
}
