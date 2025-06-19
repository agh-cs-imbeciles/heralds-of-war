@tool
class_name BoardTileMapExtender extends EditorScript


func _run() -> void:
	var root: Node = get_scene()
	var board_tile_map: TileMapLayer = root \
		.get_node("Board/BoardTileMap")
	var background_tile_map_top: TileMapLayer = root \
		.get_node("BackgroundTileMapTop")
	var background_tile_map_bottom: TileMapLayer = root \
		.get_node("BackgroundTileMapBottom")

	__create_background(
		board_tile_map,
		background_tile_map_top,
		background_tile_map_bottom,
	)


func __create_background(
	board: TileMapLayer,
	background_tile_map_top: TileMapLayer,
	background_tile_map_bottom: TileMapLayer
) -> void:
	background_tile_map_top.clear()
	background_tile_map_bottom.clear()

	var used_cells := board.get_used_cells()

	if used_cells.is_empty():
		return

	var original_pattern := board.get_pattern(used_cells)
	var map_rect := board.get_used_rect()
	var map_size := map_rect.size

	# We generate all variants of mirror images once, before the loop
	var pattern_h_flipped := __create_mirrored_pattern(
		original_pattern,
		map_rect,
		true,
		false,
	)
	var pattern_v_flipped := __create_mirrored_pattern(
		original_pattern,
		map_rect,
		false,
		true,
	)
	var pattern_hv_flipped := __create_mirrored_pattern(
		original_pattern,
		map_rect,
		true,
		true,
	)

	# We create a 5x5 grid
	for i in range(-2, 3):
		for j in range(-2, 3):
			if i == 0 and j == 0:
				continue

			var target_pattern: TileMapPattern

			# Choose the right pattern based on grid position
			var flip_h = (i % 2 != 0)
			var flip_v = (j % 2 != 0)

			match [flip_h, flip_v]:
				[true, true]:
					target_pattern = pattern_hv_flipped
				[true, false]:
					target_pattern = pattern_h_flipped
				[false, true]:
					target_pattern = pattern_v_flipped
				[false, false]:
					target_pattern = original_pattern

			var paste_position = map_rect.position \
				+ Vector2i(i * map_size.x, j * map_size.y)

			# We use your logic to select the background layer
			if i + j < 1:
				background_tile_map_top.set_pattern(
					paste_position,
					target_pattern,
				)
			else:
				background_tile_map_bottom.set_pattern(
					paste_position,
					target_pattern,
				)


func __create_mirrored_pattern(
	source_pattern: TileMapPattern,
	map_rect: Rect2i,
	flip_h: bool,
	flip_v: bool,
) -> TileMapPattern:
	var mirrored_pattern := TileMapPattern.new()
	var cells := source_pattern.get_used_cells()

	for cell in cells:
		var mirrored_pos := cell

		# Horizontal reflection
		if flip_h:
			# new_x = (left_side + right_side) - old_x
			mirrored_pos.x = (map_rect.position.x + map_rect.size.x - 1) \
				- cell.x

		# Vertical reflection
		if flip_v:
			# new_y = (upper_side + lower_side) - old_y
			mirrored_pos.y = (map_rect.position.y + map_rect.size.y - 1) \
				- cell.y

		# Copying tile data
		var source_id = source_pattern.get_cell_source_id(cell)
		var atlas_coords = source_pattern.get_cell_atlas_coords(cell)
		var alternative_tile = source_pattern.get_cell_alternative_tile(cell)

		mirrored_pattern.set_cell(
			mirrored_pos,
			source_id,
			atlas_coords,
			alternative_tile,
		)

	return mirrored_pattern
