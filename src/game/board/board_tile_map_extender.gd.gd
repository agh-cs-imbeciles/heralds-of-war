@tool
class_name BoardTileMapExtender extends EditorScript

const GRID_SIZE = 5


func _run() -> void:
	var root: Node = get_scene()
	assert(
		root.name == "Match",
		"The script haven't been run on top of a match scene",
	)

	var board_tile_map: TileMapLayer = root \
		.get_node("Board/BoardTileMap")
	var background_tile_map: TileMapLayer = board_tile_map \
		.get_node("BackgroundTileMap")

	__create_background(board_tile_map, background_tile_map)


func __create_background(
	map: TileMapLayer,
	background_tile_map: TileMapLayer,
) -> void:
	background_tile_map.clear()

	if map.get_used_cells().is_empty():
		return

	var map_rect := map.get_used_rect()
	var map_start := map_rect.position
	var map_size := map_rect.size

	# We create a 5x5 grid
	var n: int = GRID_SIZE * map_size.y
	var m: int = GRID_SIZE * map_size.x
	var map_center: Vector2i = map_start + map_size / 2
	for k in range(n * m):
		@warning_ignore("integer_division")
		var i: int = -(n / 2) + k / n + map_center.y
		@warning_ignore("integer_division")
		var j: int = -(m / 2) + k % m + map_center.x
		var cell_coords: Vector2i = Vector2i(j, i)

		if map_rect.has_point(cell_coords):
			continue

		var nearest_i: int \
			= clampi(i, map_start.y, map_start.y + map_size.y - 1)
		var nearest_j: int \
			= clampi(j, map_start.x, map_start.x + map_size.x - 1)
		var nearest_cell_coords: Vector2i = Vector2i(nearest_j, nearest_i)
		var nearest_cell_atlas_coords: Vector2i = map.get_cell_atlas_coords(
			nearest_cell_coords,
		)

		var source_id: int = 0
		background_tile_map.set_cell(
			cell_coords,
			source_id,
			nearest_cell_atlas_coords,
		)
