class_name PlayManager extends Object

var match_: Match
var phase_manager: PhaseManager
var players: Array[String]

var current_player_index: int = 0

var turn: int = 1


func _init(m: Match) -> void:
	match_ = m
	phase_manager = m.phase_manager
	players = m.players


func end_turn() -> void:
	print("Turn %s has ended" % turn)
	turn += 1


func start_phase() -> void:
	print("== Play Phase ==")
	match_.ordering_manager.advance()


func highlight_player_units(player_id: String) -> void:
	for child in match_.get_children():
		if child is Unit:
			child.modulate = Color(1,1,1) if child.player_id == player_id else Color(0.4,0.4,0.4)


func on_unit_moved():
	ordering_manager.advance()


func _get_current_player() -> String:
	if phase_manager.current_phase == PhaseManager.Phase.PLAY and ordering_manager.sequence_index > 0:
		return ordering_manager.sequence[ordering_manager.sequence_index - 1]
	return players[current_player_index]
