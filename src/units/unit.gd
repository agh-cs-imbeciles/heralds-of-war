extends CharacterBody2D

class_name Unit

@export_range(1, 1024) var stamina: int
@export var offset: Vector2

var map_position: Vector2i
var board: Board


func set_position_from_map(map: Vector2i) -> void:
	map_position = map
	position = board.map_to_local(map_position) + offset


func move(to: Vector2i) -> void:
	set_position_from_map(to)
