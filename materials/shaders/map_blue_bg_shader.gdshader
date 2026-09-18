shader_type canvas_item;

// 顶部颜色
uniform vec4 top_color : source_color = vec4(0.1, 0.3, 0.8, 1.0);

// 底部颜色
uniform vec4 bottom_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// 整体透明度
uniform float alpha : hint_range(0.0, 1.0) = 0.3;

void fragment()
{
    // UV.y:
    // 0.0 = 顶部
    // 1.0 = 底部

    vec4 gradient_color = mix(
        top_color,
        bottom_color,
        UV.y
    );

    // 使用独立透明度控制
    gradient_color.a *= alpha;

    COLOR = gradient_color;
}