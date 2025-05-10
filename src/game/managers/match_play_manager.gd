class_name MatchPlayManager extends Object

signal unit_focused(unit: Unit)
signal unit_unfocused

var __match: Match
var __board: Board
var ordering_manager: MatchOrderingManager

var focused_unit: Unit


func _init(m: Match) -> void:
	__match = m
	__board = m.board
	ordering_manager = MatchOrderingManager.new(m)

	__match.turn_ended.connect(__on_turn_ended)
	__match.phase_manager.phase_changed.connect(__on_phase_changed)
	ordering_manager.sequence_exhausted.connect(__on_sequence_exhausted)


func __on_turn_ended(_turn: int) -> void:
	ordering_manager.reset()


func __on_phase_changed(phase: Match.Phase) -> void:
	if phase != Match.Phase.PLAY:
		if __board.input_manager.cell_pressed.is_connected(__on_cell_pressed):
			__board.input_manager.cell_pressed.disconnect(__on_cell_pressed)
		return

	__board.input_manager.cell_pressed.connect(__on_cell_pressed)

	print("== Play Phase ==")

	if __match.turn == 1:
		ordering_manager.init_signal_connections()
	ordering_manager.init_sequence()


func __on_cell_pressed(cell_position: Vector2i, button: MouseButton) -> void:
	if button == MOUSE_BUTTON_RIGHT:
		if focused_unit:
			unfocus_unit()
		return

	if button != MOUSE_BUTTON_LEFT:
		return

	var unit := __board.get_unit(cell_position)
	if unit and not focused_unit and __is_current_player_unit(unit):
		focus_unit(unit)
		return

	if not focused_unit:
		return

	if focused_unit.can_move(cell_position):
		focused_unit.move(cell_position)

	unfocus_unit()


func __on_sequence_exhausted() -> void:
	__match.end_turn()


func __is_current_player_unit(unit: Unit) -> bool:
	if not unit:
		return false
	return unit.player == __match.get_current_player()


func focus_unit(unit: Unit) -> void:
	focused_unit = unit
	unit_focused.emit(unit)


func unfocus_unit() -> void:
	focused_unit = null
	unit_unfocused.emit()
