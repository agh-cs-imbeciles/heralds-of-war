class_name BoardUi extends Node2D

@onready var __match: Match = $"../.."
@onready var __board: Board = $"../../Board"

enum HighlightTile { HOVER, FOCUS, MOVE, ATTACK, ATTACK_MOVE, COMMITTED_UNIT }
var UnitState = MatchPlayManager.UnitState

var highlight_tile_scene: PackedScene = preload(
	"res://scenes/ui/board/highlight-tile.tscn"
)
var player_unit_tile: PackedScene = preload(
	"res://scenes/ui/board/player_unit_tile.tscn"
)

var __hover_tile: Sprite2D
var __focus_tile: Sprite2D
var __commit_tile: Sprite2D
var __marked_tiles: Array[Sprite2D] = []
var __player_unit_tiles: Dictionary[String, Sprite2D] = {}


func _ready() -> void:
	__match.ready.connect(__on_match_ready)
	__board.ready.connect(__on_board_ready)
	__match.pre_phase_changed.connect(
		__match_pre_phase_changed
	)
	__instantiate_highlight_tile(HighlightTile.HOVER)
	__instantiate_highlight_tile(HighlightTile.FOCUS)
	__instantiate_highlight_tile(HighlightTile.COMMITTED_UNIT)


func __match_pre_phase_changed(_phase: Match.Phase) -> void:
	__match.placement_manager.changed_user_placement.connect(
		__on_changed_user_placement
	)


func __on_match_ready() -> void:
	__match.turn_ended.connect(__on_turn_ended)
	__match.phase_manager.phase_changed.connect(__on_phase_changed)
	__match.play_manager.unit_focused.connect(__on_unit_focused)
	__match.play_manager.unit_unfocused.connect(__on_unit_unfocused)
	__match.play_manager.ordering_manager.sequence_advanced.connect(
		__on_sequence_advanced
	)
	__match.play_manager.ordering_manager.unit_committed.connect(
		__on_unit_committed
	)
	__match.play_manager.ordering_manager.unit_uncommitted.connect(
		__on_unit_uncommitted
	)

	for tile_map in __board.team_tiles:
		tile_map.hide()


func __on_changed_user_placement(player: String) -> void:
	for tile in __board.get_used_cells():
		__board.update_tile(tile, func(_x): return null)

	if player == "null":
		return

	var darkened_cells: Array[Vector2i] = []
	var selected_tile_map: TileMapLayer = null
	for tile_map in __board.team_tiles:
		if tile_map.get_meta("Team") == player:
			selected_tile_map = tile_map
			break

	var current_team_cells := selected_tile_map.get_used_cells()
	for cell in __board.get_used_cells():
		if cell not in current_team_cells:
			darkened_cells.append(cell)

	for cell in darkened_cells:
		__board.update_tile(cell, func(x): x.modulate = Color("#7d7d7d"))


func __on_board_ready() -> void:
	__board.unit_added.connect(__on_unit_added)
	__board.input_manager.mouse_entered_cell.connect(__on_mouse_entered_cell_placement_phase)
	__board.input_manager.mouse_left_board.connect(__on_mouse_left_board)


func __on_unit_added(unit: Unit) -> void:
	unit.moved.connect(__on_unit_moved)
	unit.died.connect(__on_unit_died)

	add_player_unit_tile(unit)


func __on_unit_moved(unit: Unit, from: Vector2i) -> void:
	update_player_unit_tile(unit, from)


func __on_unit_died(unit: Unit) -> void:
	remove_player_unit_tile(unit)


func __on_mouse_entered_cell_placement_phase(cell_position: Vector2i) -> void:
	if __board.get_tile_team_affiliation(cell_position) != __match.placement_manager.get_current_player():
		unrender_hover()
		return
	render_hover(__board.map_to_local(cell_position))


func __on_mouse_entered_cell_play_phase(cell_position: Vector2i) -> void:
	render_hover(__board.map_to_local(cell_position))


func __on_mouse_left_board() -> void:
	unrender_hover()


func __on_turn_ended(_turn: int) -> void:
	highlight_player_units(__match.get_current_player())


func __on_phase_changed(phase: Match.Phase) -> void:
	if phase != Match.Phase.PLAY:
		return

	__board.input_manager.mouse_entered_cell.connect(
		__on_mouse_entered_cell_placement_phase
	)
	__board.input_manager.mouse_entered_cell.connect(
		__on_mouse_entered_cell_play_phase
	)
	highlight_player_units(__match.get_current_player())


func __on_sequence_advanced(player: String) -> void:
	highlight_player_units(player)


func __on_unit_focused(unit: Unit, unit_state: MatchPlayManager.UnitState) -> void:
	render_focus(__board.map_to_local(unit.map_position))

	var marked_cells: Array[Vector2]
	if unit_state == UnitState.SELECTED:
		marked_cells.assign(unit.get_legal_moves().map(__board.map_to_local))
		render_marked_cells(marked_cells)
	elif unit_state == UnitState.ATTACK_SELECTED:
		var attackable_cells = unit.get_attacks()
		marked_cells.assign(attackable_cells.map(__board.map_to_local))
		render_marked_cells(marked_cells, HighlightTile.ATTACK)

		if is_instance_of(unit, MeleeUnit):
			var move_attackable_cells: Array[Vector2i] = unit.get_attacks_after_move()
			move_attackable_cells = move_attackable_cells.filter(func(x): return not attackable_cells.has(x))
			marked_cells.assign(move_attackable_cells.map(__board.map_to_local))
			render_marked_cells(marked_cells, HighlightTile.ATTACK_MOVE)


func __on_unit_unfocused() -> void:
	unrender_focus()
	unrender_movable_cells()


func __on_unit_committed(unit: Unit) -> void:
	unit.moved.connect(__on_committed_unit_moved)
	__commit_tile.position = __board.map_to_local(unit.map_position)
	__commit_tile.show()


func __on_committed_unit_moved(unit: Unit, _from: Vector2i) -> void:
	__commit_tile.position = __board.map_to_local(unit.map_position)


func __on_unit_uncommitted(unit: Unit) -> void:
	if unit != null:
		unit.moved.disconnect(__on_committed_unit_moved)
	__commit_tile.hide()


func __instantiate_highlight_tile(tile_type: HighlightTile) -> Sprite2D:
	var tile: Sprite2D = highlight_tile_scene.instantiate()

	match (tile_type):
		HighlightTile.HOVER:
			tile.name = "BoardHoverTile"
			tile.modulate = Color("#aabfe6", 0.784)
			tile.z_index = 64
			__hover_tile = tile
		HighlightTile.FOCUS:
			tile.name = "BoardFocusTile"
			tile.modulate = Color("#2ed9e6", 0.784)
			tile.z_index = 66
			__focus_tile = tile
		HighlightTile.MOVE:
			tile.name = "BoardMovableTile%s" % __marked_tiles.size()
			tile.modulate = Color("#6dd4d6", 0.584)
			tile.z_index = 65
			__marked_tiles.append(tile)
		HighlightTile.ATTACK:
			tile.name = "BoardAttackableTile%s" % __marked_tiles.size()
			tile.modulate = Color("8f31e8", 0.584)
			tile.z_index = 62
			__marked_tiles.append(tile)
		HighlightTile.ATTACK_MOVE:
			tile.name = "BoardMoveAttackableTile%s" % __marked_tiles.size()
			tile.modulate = Color("#611aa3", 0.584)
			tile.z_index = 62
			__marked_tiles.append(tile)
		HighlightTile.COMMITTED_UNIT:
			tile.name = "BoardComittedUnit"
			tile.modulate = Color("#eb0909", 0.584)
			tile.z_index = 65
			__commit_tile = tile

	if tile_type not in [
		HighlightTile.MOVE,
		HighlightTile.ATTACK,
		HighlightTile.ATTACK_MOVE,
	]:
		tile.hide()

	add_child(tile)

	return tile


func render_hover(hover_position: Vector2) -> void:
	if __hover_tile.hidden:
		__hover_tile.show()
	__hover_tile.position = hover_position


func unrender_hover() -> void:
	__hover_tile.hide()


func render_focus(focus_position: Vector2) -> void:
	__focus_tile.position = focus_position
	__focus_tile.show()


func unrender_focus() -> void:
	__focus_tile.hide()


func render_marked_cells(
	moves: Array[Vector2],
	tile_type: HighlightTile = HighlightTile.MOVE
) -> void:
	for cell in moves:
		var tile := __instantiate_highlight_tile(tile_type)
		tile.position = cell


func unrender_movable_cells() -> void:
	for cell in __marked_tiles:
		remove_child(cell)

	__marked_tiles.clear()


func highlight_player_units(player: String) -> void:
	var unit_container_children: Array[Unit]
	unit_container_children.assign(__board.unit_node_container.get_children())

	for unit in unit_container_children:
		unit.modulate = Color(1, 1, 1) if unit.player == player \
			else Color(0.4, 0.4, 0.4)


func add_player_unit_tile(unit: Unit) -> Sprite2D:
	var tile: Sprite2D = player_unit_tile.instantiate()
	tile.name = "PlayerUnitTile%s" % __player_unit_tiles.size()
	tile.position = __board.map_to_local(unit.map_position)
	tile.modulate = Color("#1ad9ff") if unit.player == "A" else Color("#ff1a57")
	tile.z_index = 63

	var map_position_key := VectorUtils.vector2i_to_string(unit.map_position)
	__player_unit_tiles.set(map_position_key, tile)

	add_child(tile)

	return tile


func update_player_unit_tile(unit: Unit, previous_position: Vector2i) -> void:
	var map_position_key := VectorUtils.vector2i_to_string(unit.map_position)
	var old_map_position_key := VectorUtils.vector2i_to_string(
		previous_position
	)
	var tile: Sprite2D = __player_unit_tiles.get(old_map_position_key)

	__player_unit_tiles.erase(old_map_position_key)
	tile.position = __board.map_to_local(unit.map_position)
	__player_unit_tiles.set(map_position_key, tile)


func remove_player_unit_tile(unit: Unit) -> void:
	var map_position_key := VectorUtils.vector2i_to_string(unit.map_position)
	var tile: Sprite2D = __player_unit_tiles.get(map_position_key)

	remove_child(tile)
	__player_unit_tiles.erase(map_position_key)
