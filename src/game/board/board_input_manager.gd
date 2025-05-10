class_name BoardInputManager extends Node

signal cell_pressed(cell_position: Vector2i, button: MouseButton)
signal mouse_entered_cell(cell_position: Vector2i)
signal mouse_left_board

@onready var board: Board = $".."

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
		if mouse_map_position == mouse_entered_cell_position:
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


func __handle_mouse_button_pressed(event: InputEventMouseButton) -> void:
	var mouse_map_position := __get_mouse_map_position()
	var button := event.button_index

	var is_valid_button_pressed := button == MOUSE_BUTTON_LEFT \
		or button == MOUSE_BUTTON_RIGHT
	var is_cell_pressed := board.get_used_rect().has_point(mouse_map_position)
	if not (is_valid_button_pressed and is_cell_pressed):
		return

	cell_pressed.emit(mouse_map_position, button)
