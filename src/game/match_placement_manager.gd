class_name MatchPlacementManager extends Object

var player: String = "A"

var __match: Match
var __phase_manager: MatchPhaseManager
var __board: Board

var swordsman_scene: PackedScene = preload("res://scenes/units/swordsman.tscn")


func _init(m: Match) -> void:
	__match = m
	__phase_manager = m.phase_manager
	__board = m.board

	__board.units[player] = []

	__phase_manager.phase_changed.connect(__on_phase_changed)


func __on_phase_changed(phase: Match.Phase) -> void:
	if phase != Match.Phase.PLACEMENT:
		if __board.input_manager.cell_pressed.is_connected(__on_cell_pressed):
			__board.input_manager.cell_pressed.disconnect(__on_cell_pressed)
		return

	__board.input_manager.cell_pressed.connect(__on_cell_pressed)

	print("== Placement Phase ==")
	print("Player to place %d units." % [__match.unit_count])


func __on_cell_pressed(cell_position: Vector2i, button: MouseButton) -> void:
	if button != MOUSE_BUTTON_LEFT:
		return

	var unit := __board.get_unit(cell_position)
	if unit is Unit:
		return

	place_unit(cell_position)


func place_unit(map_position: Vector2i) -> void:
	if __board.units[player].size() >= __match.unit_count:
		return

	var swordsman := __instantiate_swordsman(map_position)
	__board.add_unit(swordsman)

	print("Player has placed unit at %s" % [map_position])

	if __is_placement_finished():
		__phase_manager.enter_phase(Match.Phase.PLAY)
	else:
		print("Player has to place %s remaining units." % [
			__match.unit_count - __board.units[player].size()
		])


func __instantiate_swordsman(map_position: Vector2i) -> Unit:
	var swordsman: Unit = swordsman_scene.instantiate()
	swordsman.board = __match.board
	swordsman.stamina = 60
	swordsman.offset = Vector2(8, -20)
	swordsman.set_position_from_map(map_position)
	swordsman.scale = Vector2(0.5, 0.5)
	swordsman.z_index = 256

	__board.unit_node_container.add_child(swordsman)

	return swordsman


func __is_placement_finished() -> bool:
	return __board.units[player].size() >= __match.unit_count
