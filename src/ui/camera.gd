extends Camera2D

class_name Camera

enum CameraMoveController { KEYBOARD = 0b01, MOUSE = 0b10 }

@export_group("Movement")
@export var move_by_mouse := true
@export var move_by_keyboad := true
@export_range(0, 100, 1) var edge_activation_threshold = 8
@export_range(0, 2000, 10) var move_speed = 200
@export var bound_offset := 16

@export_group("Zoom")
@export var min_zoom_factor := 1.0
@export var max_zoom_factor := 6.0
@export var zoom_step := 0.6
@export var zoom_smooth_factor := 5.0

var zoom_velocity := 0.0
var bound: Rect2i

@onready var board: Board = $"../Board"


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

	zoom = get_camera_zoom(delta)


func get_camera_movement(controller: int) -> Vector2:
	var direction = Vector2.ZERO

	if controller & CameraMoveController.KEYBOARD:
		direction += __get_camera_movement_keyboard()
	if controller & CameraMoveController.MOUSE:
		direction += __get_camera_movement_mouse()

	return direction


func __get_camera_movement_keyboard() -> Vector2:
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


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_velocity += zoom_step
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_velocity -= zoom_step


func get_camera_zoom(delta: float) -> Vector2:
	var new_zoom := zoom

	if abs(zoom_velocity) > 0.001:
		var factor = 1.0 + zoom_velocity * delta
		new_zoom = (zoom * factor).clamp(
			Vector2.ONE * min_zoom_factor,
			Vector2.ONE * max_zoom_factor
		)
		zoom_velocity = lerp(zoom_velocity, 0.0, zoom_smooth_factor * delta)

	return new_zoom
