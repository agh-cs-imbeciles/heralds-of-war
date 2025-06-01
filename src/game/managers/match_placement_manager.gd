class_name MatchPlacementManager extends Object

signal player_placement_started(player: String)

var __current_player_index: int = 0

var __match: Match
var __phase_manager: MatchPhaseManager
var __players: Array[String]
var __board: Board

var swordsman_scene: PackedScene = preload("res://scenes/units/swordsman.tscn")


func _init(m: Match) -> void:
	__match = m
	__phase_manager = m.phase_manager
	__players = m.players
	__board = m.board

	for player in __players:
		__board.units[player] = []

	__phase_manager.phase_changed.connect(__on_phase_changed)


func __on_phase_changed(phase: Match.Phase) -> void:
	if phase != Match.Phase.PLACEMENT:
		if __board.input_manager.cell_pressed.is_connected(__on_cell_pressed):
			__board.input_manager.cell_pressed.disconnect(__on_cell_pressed)
		return

	__board.input_manager.cell_pressed.connect(__on_cell_pressed)

	print("== Placement Phase ==")
	print("Player %s to place %d units." % [
		__players[__current_player_index],
		__match.unit_count_per_player
	])
	player_placement_started.emit(__players[__current_player_index])


func __on_cell_pressed(cell_position: Vector2i, button: MouseButton) -> void:
	if button != MOUSE_BUTTON_LEFT:
		return

	var unit := __board.get_unit(cell_position)
	if unit is Unit:
		return

	var player := __players[__current_player_index]

	if get_cell_team_affiliation(cell_position) != player:
		print("Player %s cannot place a unit at %s." % [player, cell_position])
		return

	place_unit(player, cell_position)

	if __is_placement_finished():
		__phase_manager.enter_phase(Match.Phase.PLAY)
		return

	if __board.units[player].size() >= __match.unit_count_per_player:
		__current_player_index = (__current_player_index + 1) % __players.size()
		player_placement_started.emit(__players[__current_player_index])

	print("Player %s has to place %s remaining units." % [
		player,
		__match.unit_count_per_player - __board.units[player].size()
	])


func place_unit(player: String, map_position: Vector2i) -> void:
	if __board.units[player].size() >= __match.unit_count_per_player:
		return

	var swordsman := __instantiate_swordsman(player, map_position)
	__board.add_unit(swordsman)

	print("Player %s has placed unit at %s" % [player, map_position])


func __instantiate_swordsman(player: String, map_position: Vector2i) -> Unit:
	var swordsman: Unit = swordsman_scene.instantiate()
	swordsman.board = __match.board
	swordsman.board_tile_map = __match.board.tile_map
	swordsman.initial_stamina = 60
	swordsman.initial_health = 100
	swordsman.initial_attack_strength = 50
	swordsman.initial_attack_cost = 20
	swordsman.initial_defense = 0
	swordsman.player = player
	swordsman.offset = Vector2(8, -20)
	swordsman.initial_position = map_position
	swordsman.scale = Vector2(0.5, 0.5)
	swordsman.z_index = 256
	swordsman.modulate = Color(1, 0.8, 0.8) \
		if player == "A" \
		else Color(0.8, 0.8, 1)

	swordsman.init()

	__board.unit_node_container.add_child(swordsman)

	return swordsman


func __is_placement_finished() -> bool:
	for player in __players:
		if __board.units[player].size() < __match.unit_count_per_player:
			return false
	return true


func get_current_player() -> String:
	return __players[__current_player_index]


func get_cell_team_affiliation(map_index: Vector2i) -> String:
	for tile_map in __board.tile_map.team_tiles:
		var tile := tile_map.get_cell_tile_data(map_index)
		if tile == null:
			continue

		var tile_data: String = tile_map.get_meta("Team")
		if tile_data == null:
			return "null"

		return tile_data

	return "null"
