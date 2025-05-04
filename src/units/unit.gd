extends CharacterBody2D

class_name Unit

@export_range(1, 1024) var stamina: int
@export var offset: Vector2

var map_position: Vector2i
var board: Board

@export var player_id: String = ""  # np. \"A\" lub \"B\"

func can_move(map_index: Vector2i) -> bool:
	var legal_moves = get_legal_moves(map_position)

	for move in legal_moves:
		if map_index == move:
			return true

	return false


func get_legal_moves(map_index: Vector2i) -> Array[Vector2i]:
	var legal_moves: Array[Vector2i] = []

	for cell in board.get_used_cells():
		var s = board.get_cell_id(map_index)
		var t = board.get_cell_id(cell)
		var path = board.path_finder.get_point_path(s, t)

		if 1 < path.size() and path.size() <= stamina:
			legal_moves.append(cell)

	return legal_moves


func set_position_from_map(map: Vector2i) -> void:
	map_position = map
	position = board.map_to_local(map_position) + offset


func move(to: Vector2i) -> void:
	set_position_from_map(to)
	get_parent().on_unit_moved()  # wymaga istnienia tej funkcji w Match
