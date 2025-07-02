class_name MeleeUnit extends Unit

@export var melee_attack_range: int


func __get_attack_cells(map_index: Vector2i) -> Array[Vector2i]:
	return board.get_nearest_cells(map_index, melee_attack_range)


func get_attacks() -> Array[Vector2i]:
	if stamina < attack_cost:
		return []
	return __get_attack_cells(map_position)

func get_attack_move(attacked_position: Vector2i) -> Vector2i:
	return __get_attack_to_move_dict()[attacked_position]


func get_attacks_after_move() -> Array[Vector2i]:
	return __get_attack_to_move_dict().keys()


## Maps all unit's possible attack cells to position an unit should be standing 
## on, to perform this attack.
func __get_attack_to_move_dict() -> Dictionary[Vector2i, Vector2i]:
	var attack_to_move: Dictionary[Vector2i, Vector2i] = {}
	var attack_to_cost: Dictionary[Vector2i, int] = {}

	for legal_move in get_legal_moves():
		var current_cost := get_move_cost(legal_move) + attack_cost
		if current_cost > stamina:
			continue

		for attack_cell in __get_attack_cells(legal_move):
			var cost = attack_to_cost.get(attack_cell)
			if cost == null or current_cost < cost:
				attack_to_cost.set(attack_cell, current_cost)
				attack_to_move.set(attack_cell, legal_move)

	if not attack_cost > stamina:
		for attack_cell in __get_attack_cells(map_position):
			attack_to_move.set(attack_cell, map_position)

	return attack_to_move


func is_move_attackable(map_index: Vector2i) -> bool:
	var attack_moves: Array[Vector2i] = get_attacks_after_move()
	for attack_move in attack_moves:
		if map_index == attack_move:
			return true

	return false


func can_attack(map_index: Vector2i) -> bool:
	var attack_moves := get_attacks()
	for attack_move in attack_moves:
		if map_index == attack_move:
			return true

	return false


func attack(attacked_unit: Unit) -> void:
	var to_move := get_attack_move(attacked_unit.map_position)
	if to_move != map_position:
		move(to_move)

	attacked_unit.receive_damage(attack_strength)
	deplete_stamina(attack_cost)

	action_performed.emit(self)


func is_enemy_in_attack_range() -> bool:
	var attack_cells := __get_attack_cells(map_position)
	for cell in attack_cells:
		var unit := board.get_unit(cell)
		if unit != null and unit.player != self.player:
			return true

	return false
