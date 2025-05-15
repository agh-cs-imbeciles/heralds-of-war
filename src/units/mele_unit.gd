class_name MeleeUnit extends Unit

@export var melee_attack_range: int


func get_attack_fields(map_index: Vector2i) -> Array[Vector2i]:
	return board.get_square(map_index, melee_attack_range)


func get_attack_to_move_dict() -> Dictionary[Vector2i, Vector2i]:
	var attack_to_move: Dictionary[Vector2i, Vector2i] = {}
	var attack_to_cost: Dictionary[Vector2i, int] = {}

	for move in get_legal_moves():
		var current_cost = get_move_cost(move) + attack_cost
		if current_cost > stamina:
			continue
		for attack_field in get_attack_fields(move):
			var cost = attack_to_cost.get(attack_field)
			if cost == null or current_cost < cost:
				attack_to_cost.set(attack_field, current_cost)
				attack_to_move.set(attack_field, move)

	for attack_field in get_attack_fields(map_position):
		attack_to_move.set(attack_field, map_position)
		pass

	return attack_to_move


func is_move_attackable(map_index: Vector2i) -> bool:
	var attack_moves: Array[Vector2i] = get_attack_to_move_dict().keys()
	for move in attack_moves:
		if map_index == move:
			return true

	return false


func is_attackable(map_index: Vector2i) -> bool:
	var attack_moves = get_attack_fields(map_position)
	for move in attack_moves:
		if map_index == move:
			return true

	return false
