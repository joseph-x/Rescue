extends Node
class_name ConfigManager

const settings_path: String = "user://settings.cfg"

@export var config: Dictionary = {}

var default_config: Dictionary = {}
var audio_cfg: Dictionary = {}
var graphic_cfg: Dictionary = {}
var controls_cfg: Dictionary = {}
var gameplay_cfg: Dictionary = {}


func init_default_config() -> void:
	audio_cfg = {
		"muted": false,
		"master_volume": 0.8,
		"music_volume": 0.8,
	}
	graphic_cfg = {
		"resolution": Vector2i(1920, 1080),
		"fullscreen": true,
	}
	controls_cfg = {}
	gameplay_cfg = {}
	
	default_config = {
		"audio": audio_cfg,
		"graphic": graphic_cfg,
		"controls": controls_cfg,
		"gameplay": gameplay_cfg
	}

func reset_to_default() -> void:
	config = default_config.duplicate(true)


func save() -> void:
	var cfg := ConfigFile.new()
	
	var keys = config.keys()
	for t1_key in keys:
		var dict: Dictionary = config[t1_key] as Dictionary
		for t2_key in dict.keys():
			cfg.set_value(t1_key, t2_key, dict[t2_key])
	
	cfg.save(settings_path)
	print("config saved")


func load() -> void:
	# 读取（启动时）
	var cfg := ConfigFile.new()
	var data: Dictionary = {}
	
	if cfg.load(settings_path) == OK:
		var sections := cfg.get_sections()
		for s in sections:
			data[s] = {}
			for k in cfg.get_section_keys(s):
				data[s][k] = cfg.get_value(s,k,default_config[s][k])
		
		config = data


func _print_all() -> void:
	print(config)
