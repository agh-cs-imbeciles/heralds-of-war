class_name Match extends Node2D

enum Phase { INIT = 0, PLACEMENT = 1, PLAY = 2 }

signal turn_ended(turn: int)
signal match_ended(victor: String)

@export var match_name: String
@export var unit_count_per_player: int = 3

var players: Array[String] = ["A", "B"]
var phase: Phase = Phase.INIT
var turn: int = 1

@onready var board: Board = $"Board"
@onready var background_tile_map_top: TileMapLayer = $BackgroundTileMapTop
@onready var background_tile_map_bottom: TileMapLayer = $BackgroundTileMapBottom
var phase_manager: MatchPhaseManager
var placement_manager: MatchPlacementManager
var play_manager: MatchPlayManager


func _ready() -> void:
	# Making sure that every match is not paused, for instance the end of the
	# previous match pauses the whole game globally.
	resume()

	phase_manager = MatchPhaseManager.new(self)
	placement_manager = MatchPlacementManager.new(self)
	play_manager = MatchPlayManager.new(self)

	phase_manager.phase_changed.connect(__on_phase_changed)
	play_manager.match_ended.connect(__on_match_ended)

	ready.connect(__on_ready)


func _create_mirrored_pattern(source_pattern: TileMapPattern, map_rect: Rect2i, flip_h: bool, flip_v: bool) -> TileMapPattern:
	var mirrored_pattern := TileMapPattern.new()
	var cells := source_pattern.get_used_cells()

	for cell in cells:
		var mirrored_pos := cell

		# Horizontal reflection
		if flip_h:
			# new_x = (left_side + right_side) - old_x
			mirrored_pos.x = (map_rect.position.x * 2 + map_rect.size.x - 1) - cell.x
		
		# Vertical reflection
		if flip_v:
			# new_y = (upper_side + lower_side) - old_y
			mirrored_pos.y = (map_rect.position.y * 2 + map_rect.size.y - 1) - cell.y

		# Copying tile data
		var source_id = source_pattern.get_cell_source_id(cell)
		var atlas_coords = source_pattern.get_cell_atlas_coords(cell)
		var alternative_tile = source_pattern.get_cell_alternative_tile(cell)

		mirrored_pattern.set_cell(mirrored_pos, source_id, atlas_coords, alternative_tile)
	
	return mirrored_pattern


func _create_background() -> void:
	var source_map := board.tile_map
	var used_cells := source_map.get_used_cells()
	
	if used_cells.is_empty():
		return

	var original_pattern := source_map.get_pattern(used_cells)
	var map_rect := source_map.get_used_rect()
	var map_size := map_rect.size

	# We generate all variants of mirror images once, before the loop
	var pattern_h_flipped = _create_mirrored_pattern(original_pattern, map_rect, true, false)
	var pattern_v_flipped = _create_mirrored_pattern(original_pattern, map_rect, false, true)
	var pattern_hv_flipped = _create_mirrored_pattern(original_pattern, map_rect, true, true)

	# We create a 5x5 grid
	for i in range(-2, 3):
		for j in range(-2, 3):
			if i == 0 and j == 0:
				continue

			var target_pattern: TileMapPattern
			
			# Choose the right pattern based on grid position
			var flip_h = (i != 0)
			var flip_v = (j != 0)
			
			match [flip_h, flip_v]:
				[true, true]:
					target_pattern = pattern_hv_flipped
				[true, false]:
					target_pattern = pattern_h_flipped
				[false, true]:
					target_pattern = pattern_v_flipped
				[false, false]:
					target_pattern = original_pattern

			var paste_position = map_rect.position + Vector2i(i * map_size.x, j * map_size.y)
			
			# We use your logic to select the background layer
			if i + j < 1:
				background_tile_map_top.set_pattern(paste_position, target_pattern)
			else:
				background_tile_map_bottom.set_pattern(paste_position, target_pattern)


func __on_phase_changed(new_phase: Phase) -> void:
	phase = new_phase


func __on_match_ended(victor: String) -> void:
	print("The match has ended")
	print("Player %s is victorious" % victor)
	match_ended.emit(victor)


func __on_ready() -> void:
	_create_background()
	phase_manager.enter_phase(Phase.PLACEMENT)


func get_current_player() -> String:
	return play_manager.ordering_manager.get_current_player()


func end_turn() -> void:
	print("Turn %d has been finished" % turn)
	turn += 1
	turn_ended.emit(turn)


func pause() -> void:
	get_tree().paused = true


func resume() -> void:
	get_tree().paused = false
