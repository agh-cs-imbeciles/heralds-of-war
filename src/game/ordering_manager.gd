class_name OrderingManager extends Object

var sequence: Array[String] = []
var sequence_index: int = 0

var match_: Match
var phase_manager: PhaseManager
var players: Array[String]

func _init(m: Match) -> void:
	match_ = m
	phase_manager = m.phase_manager
	players = m.players


func start_phase() -> void:
	print("== Ordering Phase ==")

	var total = 0
	for p in players:
		total += match_.placement_manager.placed_units[p].size()

	sequence.clear()
	while sequence.size() < total:
		for p in players:
			if sequence.size() < total:
				sequence.append(p)

	match_.end_turn()
	print("Turn %d order: %s" % [match_.turn, sequence])
	phase_manager.enter_phase(PhaseManager.Phase.PLAY)


func advance() -> void:
	if sequence_index >= sequence.size():
		phase_manager.enter_phase(PhaseManager.Phase.ORDERING)
		return
	var player = sequence[sequence_index]
	print("Sequence %d: Player %s to act" % [sequence_index + 1, player])
	match_.highlight_player_units(player)
	sequence_index += 1
