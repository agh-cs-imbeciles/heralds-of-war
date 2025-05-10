class_name MatchPlayManager extends Object

signal unit_focused(unit: Unit)
signal unit_unfocused

var __match: Match
var __board: Board

var focused_unit: Unit


func _init(m: Match) -> void:
	__match = m
	__board = m.board

	__match.phase_manager.phase_changed.connect(__on_phase_changed)
	__board.input_manager.cell_pressed.connect(__on_cell_pressed)


func __on_phase_changed(phase: Match.Phase) -> void:
	if phase != Match.Phase.PLAY:
		if __board.input_manager.cell_pressed.is_connected(__on_cell_pressed):
			__board.input_manager.cell_pressed.disconnect(__on_cell_pressed)
		return

	__board.input_manager.cell_pressed.connect(__on_cell_pressed)

	print("== Play Phase ==")


func __on_cell_pressed(cell_position: Vector2i, button: MouseButton) -> void:
	if button == MOUSE_BUTTON_RIGHT:
		if focused_unit:
			unfocus_unit()
		return

	if button != MOUSE_BUTTON_LEFT:
		return

	var unit := __board.get_unit(cell_position)
	if unit and not focused_unit:
		focus_unit(unit)
		return

	if not focused_unit:
		return

	if focused_unit.can_move(cell_position):
		focused_unit.move(cell_position)

	unfocus_unit()


func focus_unit(unit: Unit) -> void:
	focused_unit = unit
	unit_focused.emit(unit)


func unfocus_unit() -> void:
	focused_unit = null
	unit_unfocused.emit()
