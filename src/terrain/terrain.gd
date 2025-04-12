extends TileMapLayer

var is_tile_focused: bool = false

@onready var swordsman: Unit = $"../Swordsman"
@onready var hovered_tile: Sprite2D = $"../TerrainHoveredTile"
@onready var focused_tile: Sprite2D = $"../TerrainFocusedTile"


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_map_position = get_mouse_map_position()

		if get_used_rect().has_point(mouse_map_position):
			hover_cell(mouse_map_position)
		else:
			hovered_tile.hide()

	if event is InputEventMouseButton and event.is_pressed():
		var mouse_map_position = get_mouse_map_position()
		var swordsman_map_position = local_to_map(swordsman.offset_position)

		if mouse_map_position == swordsman_map_position:
			if not is_tile_focused:
				focus_cell(map_to_local(mouse_map_position))
		else:
			if is_tile_focused:
				swordsman.move(map_to_local(mouse_map_position))
			unfocus_cell()


func get_mouse_map_position() -> Vector2i:
	var mouse_position = get_local_mouse_position()
	var map_position = local_to_map(mouse_position)
	return map_position


func focus_cell(map_index: Vector2i) -> void:
	focused_tile.position = map_index
	focused_tile.show()
	is_tile_focused = true


func unfocus_cell() -> void:
	focused_tile.hide()
	is_tile_focused = false


func hover_cell(map_index: Vector2i) -> void:
	if hovered_tile.hidden:
		hovered_tile.show()
	hovered_tile.position = map_to_local(map_index)
