extends Node

const SCENE_PATHS: Dictionary = {
	"Login": "res://scenes/login_scene/login_scene.tscn",
	"MainMenu": "res://scenes/main_menu_scene/main_menu_scene.tscn",
	"GamePlay": "res://scenes/game_scene/game_scene.tscn",
	"Loading": "",
	"Settings": "res://scenes/settings_scene/settings_scene.tscn",
	"Demo": "res://scenes/demo_scene/demo_scene.tscn",
	"NPCEditor": "res://scenes/npc_editor_scene/npc_editor_scene.tscn",
}

const DEBUG_MODE: bool = true

# 时间系统配置
const GAME_TICK_INTERVAL: float = 0.5  # 每个游戏tick的时间间隔(秒)
const MINUTES_PER_TICK: int = 1        # 每个tick代表的游戏分钟数
const HOURS_PER_SHIFT: int = 8         # 每个班次的小时数
const HOURS_PER_DAY: int = 24          # 每天的小时数
