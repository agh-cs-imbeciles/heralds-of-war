class_name Match extends Node2D

enum Phase { INIT = 0, PLACEMENT = 1, PLAY = 2 }

@export var match_name: String
@export var unit_count: int = 5

var phase: Phase = Phase.INIT

@onready var board: Board = $"Board"
var phase_manager: MatchPhaseManager
var placement_manager: MatchPlacementManager
var play_manager: MatchPlayManager


func _ready() -> void:
	phase_manager = MatchPhaseManager.new(self)
	placement_manager = MatchPlacementManager.new(self)
	play_manager = MatchPlayManager.new(self)

	phase_manager.enter_phase(Phase.PLACEMENT)
