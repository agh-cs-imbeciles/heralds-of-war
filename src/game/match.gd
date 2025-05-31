class_name Match extends Node2D

enum Phase { INIT = 0, PLACEMENT = 1, PLAY = 2 }

signal turn_ended(turn: int)
signal ended(victor: String)

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
	# Making sure that every match is not paused, for instance the end of the
	# previous match pauses the whole game globally.
	resume()

	phase_manager = MatchPhaseManager.new(self)
	placement_manager = MatchPlacementManager.new(self)
	play_manager = MatchPlayManager.new(self)

	phase_manager.phase_changed.connect(__on_phase_changed)
	play_manager.ended.connect(__on_match_ended)

	phase_manager.enter_phase(Phase.PLACEMENT)


func __on_phase_changed(new_phase: Phase) -> void:
	phase = new_phase


func __on_match_ended(victor: String) -> void:
	print("The match has ended")
	print("Player %s is victorious" % victor)
	ended.emit(victor)


func get_current_player() -> String:
	return play_manager.ordering_manager.get_current_player()


func end_turn() -> void:
	print("Turn %d has been finished" % turn)
	turn += 1
	turn_ended.emit(turn)


func pause() -> void:
	get_tree().paused = true


func resume() -> void:
	get_tree().paused = false
