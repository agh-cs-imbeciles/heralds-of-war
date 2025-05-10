class_name Match extends Node2D

@export var match_name: String
@export var units_per_player: int = 3

var players: Array[String] = ["A", "B"]
var current_player_index: int = 0
#var placed_units: Dictionary = {}

var turn: int = 1

@onready var board: Board = $TerrainTileMap
@onready var phase_manager: PhaseManager = $PhaseManager
var placement_manager: PlacementManager
var ordering_manager: OrderingManager


func _ready():
	placement_manager = PlacementManager.new(self)
	ordering_manager = OrderingManager.new(self)

	phase_manager.connect("phase_changed", Callable(self, "_on_phase_changed"))
	phase_manager.enter_phase(PhaseManager.Phase.PLACEMENT)


func _on_phase_changed(new_phase: int) -> void:
	match new_phase:
		PhaseManager.Phase.PLACEMENT:
			placement_manager.start_placement_phase()
		PhaseManager.Phase.ORDERING:
			ordering_manager.start_phase()
		PhaseManager.Phase.PLAY:
			start_play_phase()


func end_turn() -> void:
	print("Turn %s has ended" % turn)
	turn += 1


func _on_board_cell_clicked(map_pos: Vector2i) -> void:
	if phase_manager.current_phase == PhaseManager.Phase.PLACEMENT:
		placement_manager.put_unit(map_pos)


func start_play_phase() -> void:
	ordering_manager.sequence_index = 0
	print("== Play Phase ==")
	ordering_manager.advance()


func highlight_player_units(player_id: String) -> void:
	for child in get_children():
		if child is Unit:
			child.modulate = Color(1,1,1) if child.player_id == player_id else Color(0.4,0.4,0.4)


func on_unit_moved():
	ordering_manager.advance()


func _get_current_player() -> String:
	if phase_manager.current_phase == PhaseManager.Phase.PLAY and ordering_manager.sequence_index > 0:
		return ordering_manager.sequence[ordering_manager.sequence_index - 1]
	return players[current_player_index]
