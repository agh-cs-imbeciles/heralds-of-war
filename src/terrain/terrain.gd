extends TileMapLayer

@onready var highlight_tile: Sprite2D = $"../TerrainHighlightTile"


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_position = get_local_mouse_position()
		var map_index_vector = local_to_map(mouse_position)

		if get_used_rect().has_point(map_index_vector):
			highlight_cell(map_index_vector)
		else:
			highlight_tile.hide()


func highlight_cell(index_vector: Vector2i):
	if highlight_tile.hidden:
		highlight_tile.show()
	highlight_tile.position = map_to_local(index_vector)
