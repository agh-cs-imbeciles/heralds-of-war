class_name BoardInputManager extends Node

@onready var board: Board = $".."
@onready var board_ui: BoardUi = $"../../Ui/BoardUi"

var is_tile_focused: bool = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_map_position = __get_mouse_map_position()

		if board.get_used_rect().has_point(mouse_map_position):
			hover_cell(mouse_map_position)
		else:
			board_ui.hover_tile.hide()

	if event is InputEventMouseButton and event.is_pressed():
		var mouse_map_position = __get_mouse_map_position()

		if event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_map_position == board.swordsman.map_position:
				if not is_tile_focused:
					on_focus_cell(mouse_map_position)
			else:
				if is_tile_focused:
					on_unfocus_cell(mouse_map_position, true)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if is_tile_focused:
				on_unfocus_cell(mouse_map_position, false)


func __get_mouse_map_position() -> Vector2i:
	var mouse_position = board.get_global_mouse_position()
	var map_position = board.local_to_map(mouse_position)
	return map_position


func on_focus_cell(map_index: Vector2i) -> void:
	focus_cell(map_index)
	var moves = board.swordsman.get_legal_moves(map_index)
	board_ui.render_movable_cells(moves)


func focus_cell(map_index: Vector2i) -> void:
	board_ui.focus_cell(map_index)
	is_tile_focused = true


func on_unfocus_cell(map_index: Vector2i, move: bool = false) -> void:
	if move:
		board.move_unit_if_legal(map_index)

	board_ui.unrender_movable_tiles()
	unfocus_cell()


func unfocus_cell() -> void:
	board_ui.unfocus_cell()
	is_tile_focused = false


func hover_cell(map_index: Vector2i) -> void:
	board_ui.hover_cell(map_index)
