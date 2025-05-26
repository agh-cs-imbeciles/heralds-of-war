class_name BoardUi extends Node2D

@onready var __match: Match = $"../.."
@onready var __board: Board = $"../../Board"

enum HighlightTile { HOVER, FOCUS, MOVE, ATTACK, ATTACK_MOVE, COMMITTED_UNIT }
var UnitState = MatchPlayManager.UnitState

var highlight_tile_scene: PackedScene = preload(
	"res://scenes/board/highlight-tile.tscn"
)

var __hover_tile: Sprite2D
var __focus_tile: Sprite2D
var __commit_tile: Sprite2D
var __marked_tiles: Array[Sprite2D] = []


func _ready() -> void:
	__match.ready.connect(__on_match_ready)
	__board.ready.connect(__on_board_ready)

	__instantiate_highlight_tile(HighlightTile.HOVER)
	__instantiate_highlight_tile(HighlightTile.FOCUS)
	__instantiate_highlight_tile(HighlightTile.COMMITTED_UNIT)


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


func __on_board_ready() -> void:
	__board.input_manager.mouse_entered_cell.connect(__on_mouse_entered_cell)
	__board.input_manager.mouse_left_board.connect(__on_mouse_left_board)


func __on_mouse_entered_cell(cell_position: Vector2i) -> void:
	render_hover(__board.map_to_local(cell_position))


func __on_mouse_left_board() -> void:
	unrender_hover()


func __on_turn_ended(_turn: int) -> void:
	highlight_player_units(__match.get_current_player())


func __on_phase_changed(phase: Match.Phase) -> void:
	if phase != Match.Phase.PLAY:
		return

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
			tile.z_index = 65
			__marked_tiles.append(tile)
		HighlightTile.ATTACK_MOVE:
			tile.name = "BoardMoveAttackableTile%s" % __marked_tiles.size()
			tile.modulate = Color("#611aa3", 0.584)
			tile.z_index = 65
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
