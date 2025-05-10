class_name PlacementManager extends Object

var match_: Match
var phase_manager: PhaseManager
var players: Array[String]

@export var units_per_player: int = 3

var current_player_index: int = 0
var placed_units: Dictionary = {}


func _init(m: Match) -> void:
	match_ = m
	phase_manager = m.phase_manager
	players = m.players

	for p in players:
		placed_units[p] = []

	phase_manager.connect("phase_changed", Callable(self, "_on_phase_changed"))
	phase_manager.enter_phase(PhaseManager.Phase.PLACEMENT)


func start_placement_phase() -> void:
	current_player_index = 0

	print("== Placement Phase ==")
	print("Player %s to place %d units." % [
		players[current_player_index],
		units_per_player,
	])


func put_unit(map_pos: Vector2i) -> void:
	var player := players[current_player_index]
	if placed_units[player].size() >= units_per_player:
		return

	var swordsman = match_.board.swordsman_scene.instantiate()
	swordsman.board = match_.board
	swordsman.stamina = 60
	swordsman.offset = Vector2(8, -20)
	swordsman.set_position_from_map(map_pos)
	swordsman.player_id = player
	swordsman.scale = Vector2(0.5, 0.5)
	swordsman.z_index = 256
	swordsman.modulate = Color(1, 0.8, 0.8) \
		if player == "A" \
		else Color(0.8, 0.8, 1)

	match_.add_child(swordsman)
	placed_units[player].append(swordsman)

	print("Player %s placed unit at %s" % [player, map_pos])

	match_.board.unrender_movable_tiles()

	if placed_units[player].size() >= units_per_player:
		current_player_index = (current_player_index + 1) % players.size()

	if _is_placement_finished():
		phase_manager.enter_phase(PhaseManager.Phase.ORDERING)
	else:
		print("Player %s to place remaining units." % players[current_player_index])


func _is_placement_finished() -> bool:
	for p in players:
		if placed_units[p].size() < units_per_player:
			return false
	return true
