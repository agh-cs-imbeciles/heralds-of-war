extends Node2D
class_name Match

@export var match_name: String = "New Match"
@export var units_per_player: int = 3

enum Phase { PLACEMENT, ORDERING, PLAY }
var phase: Phase = Phase.PLACEMENT

# Players A and B
var players := ["A", "B"]
var current_player_index: int = 0

# Tracking placed units: { "A": [], "B": [] }
var placed_units := {}

# Turn management
var turn_number: int = 0
var sequence: Array = []
var sequence_index: int = 0

# References to board
@onready var board: Board = $TerrainTileMap

func _ready():
	# Initialize tracking
	placed_units.clear()
	for p in players:
		placed_units[p] = []

	start_placement_phase()

func start_placement_phase() -> void:
	phase = Phase.PLACEMENT
	current_player_index = 0
	print("== Placement Phase ==")
	print("Player %s to place %d units." % [players[current_player_index], units_per_player])
	board.connect("cell_clicked", Callable(self, "_on_board_cell_clicked"))

func _on_board_cell_clicked(map_pos: Vector2i) -> void:
	match phase:
		Phase.PLACEMENT:
			_handle_placement(map_pos)
		Phase.ORDERING:
			# ignore clicks in ordering
			pass
		Phase.PLAY:
			# forward to board/game logic
			pass

func _handle_placement(map_pos: Vector2i) -> void:
	var player = players[current_player_index]
	if placed_units[player].size() >= units_per_player:
		return # already placed all

	# Instantiate unit from board
	var swordsman = board.swordsman_scene.instantiate()
	swordsman.board = board
	swordsman.stamina = 6
	swordsman.offset = Vector2(8, -20)
	swordsman.set_position_from_map(map_pos)
	swordsman.player_id = player
	swordsman.scale = Vector2(0.5, 0.5)
	swordsman.z_index = 256
	# Color-code units by player
	swordsman.modulate = Color(1, 0.8, 0.8) if player == "A" else Color(0.8, 0.8, 1)
	add_child(swordsman)
	placed_units[player].append(swordsman)

	print("Player %s placed unit at %s" % [player, map_pos])

	board.unrender_movable_tiles()  # 🔧 usuwa stare podświetlenia

	# Advance turn or switch player
	if placed_units[player].size() < units_per_player:
		# same player places next unit
		pass
	else:
		# next player's turn
		current_player_index = (current_player_index + 1) % players.size()

	# Check if both done
	var done = true
	for p in players:
		if placed_units[p].size() < units_per_player:
			done = false
	if done:
		board.disconnect("cell_clicked", Callable(self, "_on_board_cell_clicked"))
		start_ordering_phase()
	else:
		print("Player %s to place remaining units." % players[current_player_index])


func start_ordering_phase() -> void:
	phase = Phase.ORDERING
	print("== Ordering Phase ==")
	# Simple alternating algorithm: ABAABB...
	var total = 0
	for p in players:
		total += placed_units[p].size()
	sequence.clear()
	# Build sequence up to total actions
	while sequence.size() < total:
		for p in players:
			if sequence.size() < total:
				sequence.append(p)
	turn_number += 1
	print("Turn %d order: %s" % [turn_number, sequence])
	# After logging, move to play
	start_play_phase()

func start_play_phase() -> void:
	phase = Phase.PLAY
	sequence_index = 0
	print("== Play Phase ==")
	_advance_sequence()

func _advance_sequence() -> void:
	if sequence_index >= sequence.size():
		# Next turn
		start_ordering_phase()
		return
	var player = sequence[sequence_index]
	print("Sequence %d: Player %s to act" % [sequence_index + 1, player])
	# Signal board or UI to highlight this player's units
	_highlight_player_units(player)
	sequence_index += 1

func _highlight_player_units(player_id: String) -> void:
	# Dim all units, then highlight current player's
	for child in get_children():
		if child is Unit:
			child.modulate = Color(1,1,1) if child.player_id == player_id else Color(0.4,0.4,0.4)

# Call this when a move is completed by unit
func on_unit_moved():
	# Advance to next sequence
	_advance_sequence()
	

func _get_current_player() -> String:
	if phase == Phase.PLAY and sequence_index > 0:
		return sequence[sequence_index - 1]  # bo już inkrementowaliśmy
	return players[current_player_index]
