extends CharacterBody2D

class_name Unit

signal moved(unit: Unit, from: Vector2i)
signal died(unit: Unit)
signal action_performed(unit: Unit)
signal health_changed(unit: Unit, health: int, health_before: int)

@export var offset: Vector2
@export var initial_position: Vector2i
@export_range(1, 1024) var initial_stamina: int
@export_range(1, 1024) var initial_health: int
@export_range(1, 1024) var initial_attack_strength: int
@export_range(1, 1024) var initial_attack_cost: int
@export_range(0, 100) var initial_defense: int
var stamina: int
var health: int
var attack_strength: int
var attack_cost: int
var defense: int

var player: String
var map_position: Vector2i
var board: Board


func can_move(map_index: Vector2i) -> bool:
	var legal_moves = get_legal_moves()

	for legal_move in legal_moves:
		if map_index == legal_move:
			return true

	return false


func get_move_cost(to: Vector2i) -> int:
	var s := board.get_cell_id(map_position)
	var t := board.get_cell_id(to)
	var path := board.path_finder.get_point_path(s, t)

	var path_cost := -Global.CELL_COST_INFINITY
	for path_cell in path:
		var u := board.get_cell_id(path_cell)
		path_cost += board.path_finder.get_point_weight_scale(u) as int

	return path_cost


func get_legal_moves() -> Array[Vector2i]:
	var legal_moves: Array[Vector2i] = []

	for cell in board.tile_map.get_used_cells():
		var path_cost := get_move_cost(cell)

		if path_cost > 0.0 and path_cost <= stamina:
			legal_moves.append(cell)

	return legal_moves


func set_position_from_map(map: Vector2i) -> void:
	map_position = map
	position = board.tile_map.map_to_local(map_position) + offset


func move(to: Vector2i) -> void:
	var cost := get_move_cost(to)

	var map_position_before_move := map_position
	set_position_from_map(to)

	moved.emit(self, map_position_before_move)

	deplete_stamina(cost)

	action_performed.emit(self)


func receive_damage(enemy_attack_strength: int) -> void:
	var health_before := health
	health -= enemy_attack_strength * (100 - defense) / 100.0 as int

	print("Unit at position %s has received damage" % map_position)

	if health <= 0:
		__on_died()
	else:
		print("Current health: %s" % health)

	health_changed.emit(self, health, health_before)


func __on_died() -> void:
	print("Died")
	died.emit(self)


func deplete_stamina(stamina_to_deplete: int) -> void:
	stamina -= stamina_to_deplete


func restore_stamina() -> void:
	stamina = initial_stamina


## @abstract
func __get_attack_cells(_map_index: Vector2i) -> Array[Vector2i]:
	return []


## @abstract
func can_attack(_map_index: Vector2i) -> bool:
	return false


## @abstract
func is_enemy_in_attack_range() -> bool:
	return false


func is_stamina_exhausted() -> bool:
	return (stamina < attack_cost or not is_enemy_in_attack_range()) \
		and get_legal_moves().size() == 0


func init() -> void:
	set_position_from_map(initial_position)
	stamina = initial_stamina
	health = initial_health
	attack_strength = initial_attack_strength
	attack_cost = initial_attack_cost
	defense = initial_defense
