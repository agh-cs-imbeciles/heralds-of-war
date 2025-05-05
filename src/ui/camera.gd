extends Camera2D

class_name Camera

enum CameraMoveController { KEYBOARD = 0b01, MOUSE = 0b10 }

@export_group("Movement")
@export var move_by_mouse := true
@export var move_by_keyboad := true
@export_range(0, 100, 1) var edge_activation_threshold = 8
@export_range(0, 2000, 10) var move_speed = 200
@export var bound_offset := 16

var bound: Rect2i

@onready var board: Board = $"../TerrainTileMap"


func _ready() -> void:
	var board_rect := board.get_used_rect()
	var board_start_local := __to_local(board_rect.position)
	var board_end_local := __to_local(board_rect.end - Vector2i.ONE)
	var board_start_sec_diag_local := __to_local(
		Vector2(board_rect.position.x, board_rect.end.y - 1)
	)
	var board_end_sec_diag_local := __to_local(
		Vector2(board_rect.end.x - 1, board_rect.position.y)
	)

	var bound_start := Vector2i(
			board_start_sec_diag_local.x,
			board_start_local.y
		) - bound_offset * Vector2i.ONE
	var bound_end := Vector2i(
			board_end_sec_diag_local.x,
			board_end_local.y
		) + bound_offset * Vector2i.ONE

	bound = Rect2i(bound_start, bound_end - bound_start)


func __to_local(pos: Vector2i) -> Vector2i:
	return Vector2i(board.map_to_local(pos))

func _process(delta: float) -> void:
	var controller = 0
	if move_by_mouse:
		controller |= CameraMoveController.MOUSE
	if move_by_keyboad:
		controller |= CameraMoveController.KEYBOARD

	var direction = get_camera_movement(controller)

	# Normalise and move
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		global_position = (global_position + direction * move_speed * delta) \
			.clamp(bound.position, bound.end)


func get_camera_movement(controller: int) -> Vector2:
	const keyboard_mask = 0b01
	const mouse_mask = 0b10

	var direction = Vector2.ZERO

	if controller & keyboard_mask == CameraMoveController.KEYBOARD:
		direction += __get_camera_movement_keyboard()
	if controller & mouse_mask == CameraMoveController.MOUSE:
		direction += __get_camera_movement_mouse()

	return direction


func __get_camera_movement_keyboard() -> Vector2:
	var screen_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var center = screen_size * 0.5

	var direction = Vector2.ZERO

	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		direction.y += -1
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		direction.x += -1
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		direction.x += 1

	return direction


func __get_camera_movement_mouse() -> Vector2:
	var screen_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var center = screen_size * 0.5

	var direction = Vector2.ZERO

	# Top edge
	if mouse_pos.y <= edge_activation_threshold:
		var dx = (mouse_pos.x - center.x) / center.x
		direction.y += -1
		direction.x += dx

	# Bottom edge
	elif mouse_pos.y >= screen_size.y - edge_activation_threshold:
		var dx = (mouse_pos.x - center.x) / center.x
		direction.y += 1
		direction.x += dx

	# Left edge
	if mouse_pos.x <= edge_activation_threshold:
		var dy = (mouse_pos.y - center.y) / center.y
		direction.x += -1
		direction.y += dy

	# Right edge
	elif mouse_pos.x >= screen_size.x - edge_activation_threshold:
		var dy = (mouse_pos.y - center.y) / center.y
		direction.x += 1
		direction.y += dy

	return direction
