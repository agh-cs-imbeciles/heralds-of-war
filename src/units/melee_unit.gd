class_name MeleeUnit extends Unit

@export var melee_attack_range: int


func get_attack_fields(map_index: Vector2i) -> Array[Vector2i]:
	return board.get_square(map_index, melee_attack_range)


func is_attackable(map_index: Vector2i) -> bool:
	var attack_moves = get_attack_fields(map_position)
	for move in attack_moves:
		if map_index == move:
			return true
			
	return false
