extends Node

# 初始金币、Tick速度、季节长度
var game_config

# UI动画、Tips
var ui_config

# 音量
var audio_config

# 快捷键
var input_config
var debug_config

var config_data: Dictionary = {}

func to_save_data() -> Dictionary:
	return config_data
	
func from_save_data(data: Dictionary) -> void:
	var new_data = data.duplicate(true)
	config_data = new_data
