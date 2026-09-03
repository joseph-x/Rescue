shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float gray_fade : hint_range(0.0, 1.0) = 0.5; // 越大越淡（越接近白）

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    // 计算亮度（灰度），用标准亮度权重
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 gray_color = vec3(gray);

	// 从黑色剪影开始到上色
	float dark = mix(0.7, 0.0, progress); // 进度越大越不黑
	gray_color = mix(vec3(gray), vec3(0.0), dark);

    // 根据进度在灰度与彩色之间插值
    color.rgb = mix(gray_color, color.rgb, progress);

	// 让彩色像"扫描"一样从左往右出现
	// float reveal = step(UV.x, progress); 
	// color.rgb = mix(gray_color, color.rgb, reveal);

    COLOR = color;
}
