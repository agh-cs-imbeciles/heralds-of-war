class_name BoardInputManager extends Node

signal unit_focused(cell_position: Vector2i, moves: Array[Vector2i])
signal unit_unfocused(cell_position: Vector2i, cancelled: bool)
signal mouse_entered_cell(cell_position: Vector2i)
signal mouse_left_board

@onready var board: Board = $".."

var is_unit_focused: bool = false
var mouse_entered_cell_position: Vector2i = Vector2i(-1, -1)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		__handle_mouse_motion()
	if event is InputEventMouseButton and event.is_pressed():
		__handle_mouse_button_pressed(event)


func __get_mouse_map_position() -> Vector2i:
	var mouse_position := board.get_global_mouse_position()
	var map_position := board.local_to_map(mouse_position)
	return map_position


func __handle_mouse_motion() -> void:
	var mouse_map_position := __get_mouse_map_position()

	if board.get_used_rect().has_point(mouse_map_position):
		if mouse_map_position != mouse_entered_cell_position:
			return
		__on_mouse_entered_cell(mouse_map_position)
	else:
		__on_mouse_left_board()


func __on_mouse_entered_cell(mouse_map_position: Vector2i) -> void:
	mouse_entered_cell_position = mouse_map_position
	mouse_entered_cell.emit(mouse_entered_cell_position)


func __on_mouse_left_board() -> void:
	mouse_entered_cell_position = Vector2i(-1, -1)
	mouse_left_board.emit()


func __handle_mouse_button_pressed(event: InputEvent) -> void:
	var mouse_map_position = __get_mouse_map_position()

	if event.button_index == MOUSE_BUTTON_LEFT:
		__on_left_mouse_button_pressed(mouse_map_position)
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		__on_right_mouse_button_pressed(mouse_map_position)


func __on_unit_focused(mouse_map_position: Vector2i) -> void:
	is_unit_focused = true
	var moves := board.swordsman.get_legal_moves(mouse_map_position)
	unit_focused.emit(board.swordsman.map_position, moves)


func __on_unit_unfocused(mouse_map_position: Vector2i, cancelled: bool) -> void:
	is_unit_focused = false
	unit_unfocused.emit(mouse_map_position, cancelled)


func __on_left_mouse_button_pressed(mouse_map_position: Vector2i) -> void:
	var is_unit_cell_pressed \
		:= mouse_map_position == board.swordsman.map_position
	var has_unit_been_focused := is_unit_cell_pressed and not is_unit_focused

	if has_unit_been_focused:
		__on_unit_focused(mouse_map_position)
		return
	if not is_unit_focused:
		return

	var cancelled: bool
	if is_unit_cell_pressed:
		cancelled = true
	else:
		cancelled = false
	__on_unit_unfocused(mouse_map_position, cancelled)


func __on_right_mouse_button_pressed(mouse_map_position: Vector2i) -> void:
	var cancelled := true
	__on_unit_unfocused(mouse_map_position, cancelled)
