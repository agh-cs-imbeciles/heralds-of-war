extends CharacterBody2D

class_name Unit

@export var offset: Vector2
@export var start_map_position: Vector2i
@export_range(1, 1024) var start_stamina: int
@export_range(1, 1024) var start_health: int
@export_range(1, 1024) var start_attack_strength: int
@export_range(1, 1024) var start_attack_cost: int
@export_range(0, 100) var start_defense_percent: int
@export var team_id: int
var map_position = start_map_position
var stamina = start_stamina
var health = start_health
var attack_strength = start_attack_strength
var attack_cost = start_attack_cost
var defense_percent = start_defense_percent

var board: Board


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
	var start = board.get_cell_id(map_position)
	var end = board.get_cell_id(to)
	var path = board.path_finder.get_point_path(start, end)
	set_position_from_map(to)
	deplete_stamina(path.size()-1)


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


func reset_intitial_state() -> void:
	set_position_from_map(start_map_position)
	stamina = start_stamina
	health = start_health
	attack_strength = start_attack_strength
	attack_cost = start_attack_cost
	defense_percent = start_defense_percent
