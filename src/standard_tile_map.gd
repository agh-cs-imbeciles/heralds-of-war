class_name StandardTileMap extends TileMapLayer

var __tile_update_functions: Dictionary[Vector2i, Callable] = {}


func set_cell_color(coords: Vector2i, color: Color, update = false) -> void:
	__tile_update_functions.set(coords, func(tile: TileData) -> TileData:
		tile.modulate = color
		return tile
	)

	if update:
		notify_runtime_tile_data_update()


func set_cell_z_index(
	coords: Vector2i,
	tile_z_index: int,
	update = false,
) -> void:
	__tile_update_functions.set(coords, func(tile: TileData) -> TileData:
		tile.z_index = tile_z_index
		return tile
	)

	if update:
		notify_runtime_tile_data_update()


func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return __tile_update_functions.has(coords)


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	var update_fn: Callable = __tile_update_functions[coords]
	update_fn.call(tile_data)
	__tile_update_functions.erase(coords)
