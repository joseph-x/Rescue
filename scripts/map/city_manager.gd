extends Node2D
class_name CityManager

@onready var map: Node2D = $Map

var segments: Array
var buildings: Array

# const Building = preload("res://scripts/map/building.gd")
# const segment_mod = preload("res://scripts/map/segment.gd")
# const Segment = segment_mod.Segment
# const SegmentMetadata = segment_mod.SegmentMetadata

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _draw() -> void:
	for segment in segments:
		var width = 20 if segment.highway else 8
		draw_line(segment.start, segment.end, Color8(93, 102, 114), width, true)

	for building in buildings:
		var corners = (building as MapBuilding).corners
		draw_colored_polygon(corners, Color8(6, 51, 98), [], null)


#region Public Methods
func set_segments(data: Array) -> void:
	for d in data:
		var segment: MapSegment = MapSegment.new()
		segment.highway = d["highway"]
		segment.start = _array_to_vector2(d["start_point"])
		segment.end = _array_to_vector2(d["end_point"])
		
		segments.append(segment)
	
	queue_redraw()


func set_buildings(data: Array) -> void:
	for d in data:
		var building: MapBuilding = MapBuilding.new()
		var corners_data: Array = d["corners"]
		
		var corners: PackedVector2Array
		for c in corners_data:
			corners.append(_array_to_vector2(c))
		building.corners = corners
		
		buildings.append(building)
		
	queue_redraw()
	
#endregion

func _array_to_vector2(data: Array) -> Vector2:
	var v: Vector2 = Vector2(data[0], data[1])
	return v
