extends CharacterBody2D

class_name Unit

signal moved(unit: Unit, from: Vector2i)
signal action_performed(unit: Unit)

@export var offset: Vector2
@export var start_map_position: Vector2i
@export_range(1, 1024) var start_stamina: int
@export_range(1, 1024) var start_health: int
@export_range(1, 1024) var start_attack_strength: int
@export_range(1, 1024) var start_attack_cost: int
@export_range(0, 100) var start_defense_percent: int
var stamina: int
var health: int
var attack_strength: int
var attack_cost: int
var defense_percent: int

var player: String
var map_position: Vector2i
var board: Board


func can_move(map_index: Vector2i) -> bool:
	var legal_moves = get_legal_moves()

	for move in legal_moves:
		if map_index == move:
			return true

	return false


func get_move_cost(to: Vector2i) -> int:
	var s = board.get_cell_id(map_position)
	var t = board.get_cell_id(to)
	var path = board.path_finder.get_point_path(s, t)

	var path_cost = -9007199254740991
	for path_cell in path:
		var u = board.get_cell_id(path_cell)
		path_cost += board.path_finder.get_point_weight_scale(u)

	return path_cost


func get_legal_moves() -> Array[Vector2i]:
	var legal_moves: Array[Vector2i] = []

	for cell in board.get_used_cells():
		var path_cost = get_move_cost(cell)

		if path_cost > 1 and path_cost <= stamina:
			legal_moves.append(cell)

	return legal_moves


func set_position_from_map(map: Vector2i) -> void:
	map_position = map
	position = board.map_to_local(map_position) + offset


func move(to: Vector2i) -> void:
	var map_position_before_move := map_position
	var cost = get_move_cost(to)
	set_position_from_map(to)
	moved.emit(self, map_position_before_move)
	action_performed.emit()
	deplete_stamina(cost)


func attack() -> void:
	deplete_stamina(attack_cost)
	action_performed.emit()



func recieve_damage(enemy_attack_strength: int) -> void:
	health -= attack_strength * (100 - defense_percent) / 100
	print("current_health: " + str(health))


func deplete_stamina(stamina_to_deplete: int) -> void:
	stamina -= stamina_to_deplete


func reset_stamina() -> void:
	stamina = start_stamina


func remove_unit() -> void:
	get_parent().remove_child.call_deferred(self)


func get_attack_fields(map_index: Vector2i) -> Array[Vector2i]:
	return []


func is_attackable(map_index: Vector2i) -> bool:
	return FAILED


func reset_to_intitial_state() -> void:
	set_position_from_map(start_map_position)
	stamina = start_stamina
	health = start_health
	attack_strength = start_attack_strength
	attack_cost = start_attack_cost
	defense_percent = start_defense_percent
