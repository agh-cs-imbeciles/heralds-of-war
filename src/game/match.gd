extends Node2D
class_name Match

@export var match_name: String = "New Match"
@export var units_per_player: int = 3

var players := ["A", "B"]
var current_player_index: int = 0
var placed_units := {}

var turn_number: int = 0
var sequence: Array = []
var sequence_index: int = 0

@onready var board: Board = $TerrainTileMap
@onready var phase_manager: PhaseManager = $PhaseManager

func _ready():
	placed_units.clear()
	for p in players:
		placed_units[p] = []

	phase_manager.connect("phase_changed", Callable(self, "_on_phase_changed"))
	phase_manager.enter_phase(PhaseManager.Phase.PLACEMENT)

func _on_phase_changed(new_phase: int) -> void:
	match new_phase:
		PhaseManager.Phase.PLACEMENT:
			start_placement_phase()
		PhaseManager.Phase.ORDERING:
			start_ordering_phase()
		PhaseManager.Phase.PLAY:
			start_play_phase()

func start_placement_phase() -> void:
	current_player_index = 0
	print("== Placement Phase ==")
	print("Player %s to place %d units." % [players[current_player_index], units_per_player])

func _on_board_cell_clicked(map_pos: Vector2i) -> void:
	match phase_manager.get_current_phase():
		PhaseManager.Phase.PLACEMENT:
			_handle_placement(map_pos)
		_: pass

func _handle_placement(map_pos: Vector2i) -> void:
	var player = players[current_player_index]
	if placed_units[player].size() >= units_per_player:
		return

	var swordsman = board.swordsman_scene.instantiate()
	swordsman.board = board
	swordsman.stamina = 60
	swordsman.offset = Vector2(8, -20)
	swordsman.set_position_from_map(map_pos)
	swordsman.player_id = player
	swordsman.scale = Vector2(0.5, 0.5)
	swordsman.z_index = 256
	swordsman.modulate = Color(1, 0.8, 0.8) if player == "A" else Color(0.8, 0.8, 1)
	add_child(swordsman)
	placed_units[player].append(swordsman)

	print("Player %s placed unit at %s" % [player, map_pos])

	board.unrender_movable_tiles()

	if placed_units[player].size() < units_per_player:
		pass
	else:
		current_player_index = (current_player_index + 1) % players.size()

	var done = true
	for p in players:
		if placed_units[p].size() < units_per_player:
			done = false
	if done:
		phase_manager.enter_phase(PhaseManager.Phase.ORDERING)
	else:
		print("Player %s to place remaining units." % players[current_player_index])

func start_ordering_phase() -> void:
	print("== Ordering Phase ==")
	var total = 0
	for p in players:
		total += placed_units[p].size()
	sequence.clear()
	while sequence.size() < total:
		for p in players:
			if sequence.size() < total:
				sequence.append(p)
	turn_number += 1
	print("Turn %d order: %s" % [turn_number, sequence])
	phase_manager.enter_phase(PhaseManager.Phase.PLAY)

func start_play_phase() -> void:
	sequence_index = 0
	print("== Play Phase ==")
	_advance_sequence()

func _advance_sequence() -> void:
	if sequence_index >= sequence.size():
		phase_manager.enter_phase(PhaseManager.Phase.ORDERING)
		return
	var player = sequence[sequence_index]
	print("Sequence %d: Player %s to act" % [sequence_index + 1, player])
	_highlight_player_units(player)
	sequence_index += 1

func _highlight_player_units(player_id: String) -> void:
	for child in get_children():
		if child is Unit:
			child.modulate = Color(1,1,1) if child.player_id == player_id else Color(0.4,0.4,0.4)

func on_unit_moved():
	_advance_sequence()

func _get_current_player() -> String:
	if phase_manager.get_current_phase() == PhaseManager.Phase.PLAY and sequence_index > 0:
		return sequence[sequence_index - 1]
	return players[current_player_index]
