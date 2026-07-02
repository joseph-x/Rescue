extends VBoxContainer
class_name CrisisBar

@onready var bar_label: Label = $CrisisiLabel
@onready var bar_indcator: Dictionary = {
	"i_1": $CrisisBarIndicator/CrisisBar_1,
	"i_2": $CrisisBarIndicator/CrisisBar_2,
	"i_3": $CrisisBarIndicator/CrisisBar_3,
	"i_4": $CrisisBarIndicator/CrisisBar_4,
	"i_5": $CrisisBarIndicator/CrisisBar_5
}

const texture_pos: Dictionary = {
	"i_green": Vector2i(0, 0),
	"i_blue": Vector2i(40, 0),
	"i_orange": Vector2i(80, 0),
	"i_red": Vector2i(120, 0),
	"i_grey": Vector2i(160, 0)
}

var current_level: EnumGlobal.CRISIS_LEVEL = EnumGlobal.CRISIS_LEVEL.LOW

func _ready() -> void:
	set_level(EnumGlobal.CRISIS_LEVEL.IDLE)


func set_level(level: EnumGlobal.CRISIS_LEVEL) -> void:
	current_level = level
	
	match current_level:
		EnumGlobal.CRISIS_LEVEL.IDLE:
			_set_level_slice(bar_indcator["i_1"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_2"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_3"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_4"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_5"], texture_pos["i_grey"])
			bar_label.text = ""
			
		EnumGlobal.CRISIS_LEVEL.LOW:
			_set_level_slice(bar_indcator["i_1"], texture_pos["i_green"])
			_set_level_slice(bar_indcator["i_2"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_3"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_4"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_5"], texture_pos["i_grey"])
			bar_label.text = "LOW"

		EnumGlobal.CRISIS_LEVEL.MEDIUM:
			_set_level_slice(bar_indcator["i_1"], texture_pos["i_blue"])
			_set_level_slice(bar_indcator["i_2"], texture_pos["i_blue"])
			_set_level_slice(bar_indcator["i_3"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_4"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_5"], texture_pos["i_grey"])
			bar_label.text = "MEDIUM"
			
		EnumGlobal.CRISIS_LEVEL.HIGH:
			_set_level_slice(bar_indcator["i_1"], texture_pos["i_orange"])
			_set_level_slice(bar_indcator["i_2"], texture_pos["i_orange"])
			_set_level_slice(bar_indcator["i_3"], texture_pos["i_orange"])
			_set_level_slice(bar_indcator["i_4"], texture_pos["i_grey"])
			_set_level_slice(bar_indcator["i_5"], texture_pos["i_grey"])
			bar_label.text = "HIGH"
			
		EnumGlobal.CRISIS_LEVEL.CRITICAL:
			_set_level_slice(bar_indcator["i_1"], texture_pos["i_red"])
			_set_level_slice(bar_indcator["i_2"], texture_pos["i_red"])
			_set_level_slice(bar_indcator["i_3"], texture_pos["i_red"])
			_set_level_slice(bar_indcator["i_4"], texture_pos["i_red"])
			_set_level_slice(bar_indcator["i_5"], texture_pos["i_grey"])
			bar_label.text = "CRITICAL"

func _set_level_slice(texture_rect: TextureRect, texture_p: Vector2i) -> void:
	var atlas_texture: AtlasTexture = texture_rect.texture
	var region = Rect2(texture_p, Vector2i(40, 12))
	atlas_texture.region = region
