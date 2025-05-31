class_name Match extends Node2D

enum Phase { INIT = 0, PLACEMENT = 1, PLAY = 2 }

signal turn_ended(turn: int)
signal pre_phase_changed(phase: Phase)

@export var match_name: String
@export var unit_count_per_player: int = 3

var players: Array[String] = ["A", "B"]
var phase: Phase = Phase.INIT
var turn: int = 1

@onready var board: Board = $"Board"
var phase_manager: MatchPhaseManager
var placement_manager: MatchPlacementManager
var play_manager: MatchPlayManager


func _ready() -> void:
	phase_manager = MatchPhaseManager.new(self)
	phase_manager.phase_changed.connect(__on_phase_changed)

	placement_manager = MatchPlacementManager.new(self)
	play_manager = MatchPlayManager.new(self)

	var new_phase := Phase.PLACEMENT
	pre_phase_changed.emit(new_phase)
	phase_manager.enter_phase(new_phase)


func __on_phase_changed(new_phase: Phase) -> void:
	phase = new_phase


func get_current_player() -> String:
	return play_manager.ordering_manager.get_current_player()


func end_turn() -> void:
	print("Turn %d has been finished" % turn)
	turn += 1
	turn_ended.emit(turn)
