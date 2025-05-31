class_name Match extends Node2D

enum Phase { INIT = 0, PLACEMENT = 1, PLAY = 2 }

signal turn_ended(turn: int)

@export var match_name: String
@export var unit_count_per_player: int = 3

var players: Array[String] = ["A", "B"]
var phase: Phase = Phase.INIT
var turn: int = 1

@onready var board: Board = $"Board"
@onready var board_ui: BoardUi = $Ui/BoardUi
var phase_manager: MatchPhaseManager
var placement_manager: MatchPlacementManager
var play_manager: MatchPlayManager


func _ready() -> void:
	phase_manager = MatchPhaseManager.new(self)
	phase_manager.phase_changed.connect(__on_phase_changed)

	placement_manager = MatchPlacementManager.new(self)
	play_manager = MatchPlayManager.new(self)
	placement_manager.user_placement_started.connect(board_ui.__on_changed_user_placement)
	phase_manager.enter_phase(Phase.PLACEMENT)


func __on_phase_changed(new_phase: Phase) -> void:
	phase = new_phase


func get_current_player() -> String:
	return play_manager.ordering_manager.get_current_player()


func end_turn() -> void:
	print("Turn %d has been finished" % turn)
	turn += 1
	turn_ended.emit(turn)
