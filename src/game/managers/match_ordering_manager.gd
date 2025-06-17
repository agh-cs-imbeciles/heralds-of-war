class_name MatchOrderingManager extends Object

signal sequence_advanced(
	sequence: Array[String],
	sequence_index: int,
	player: String,
)
signal sequence_exhausted
signal unit_committed(unit: Unit)
signal unit_uncommitted(unit: Unit)

var player_unit_count_at_last_readjustment: Dictionary[String, int] = {}
var sequence: Array[String] = []
var sequence_index: int = 0
var unit_sequence: Array[Unit] = []
var committed_unit: Unit

var __match: Match
var __board: Board
var __players: Array[String]


func _init(m: Match) -> void:
	__match = m
	__board = m.board
	__players = m.players
	__match.ready.connect(__on_match_ready)


func __on_match_ready() -> void:
	__match.play_manager.unit_slot_finished.connect(__on_unit_slot_finished)


func init_sequence() -> void:
	var total_unit_count := __board.get_total_unit_count()
	var player_slot_count_to_fill := __board.get_player_unit_count()
	player_unit_count_at_last_readjustment = player_slot_count_to_fill \
		.duplicate()

	sequence.clear()
	while sequence.size() < total_unit_count:
		for player in __players:
			if player_slot_count_to_fill[player] > 0:
				sequence.append(player)
				player_slot_count_to_fill[player] -= 1

	sequence_index = 0
	unit_sequence.clear()
	committed_unit = null

	print("Turn %d order: %s" % [__match.turn, sequence])
	print("Sequence %d: Player %s to act" % [
		sequence_index + 1,
		get_current_player()
	])


func reset() -> void:
	init_sequence()


func init_signal_connections() -> void:
	for player in __players:
		for unit in __board.units[player]:
			unit.action_performed.connect(__on_unit_performed_action)


func __on_unit_slot_finished(_unit: Unit) -> void:
	advance()
	uncommit_unit()


func commit_unit(unit: Unit) -> void:
	committed_unit = unit
	unit_sequence.append(unit)
	unit_committed.emit(committed_unit)


func uncommit_unit() -> void:
	var uncommitted_unit := committed_unit
	committed_unit = null
	unit_uncommitted.emit(uncommitted_unit)


func readjust_sequence() -> void:
	var current_player_unit_count := __board.get_player_unit_count()
	var player_slot_count_to_remove: Dictionary[String, int] = {}
	for player in __players:
		var current_ucnt := current_player_unit_count[player]
		var last_readjust_ucnt := player_unit_count_at_last_readjustment[player]
		player_slot_count_to_remove[player] = last_readjust_ucnt - current_ucnt

	for player in __players:
		while player_slot_count_to_remove[player] > 0:
			var i := sequence.rfind(player)
			sequence.remove_at(i)
			player_slot_count_to_remove[player] -= 1

	player_unit_count_at_last_readjustment = current_player_unit_count


func __on_unit_performed_action(unit: Unit) -> void:
	if committed_unit == null:
		commit_unit(unit)
	if unit.is_stamina_exhausted():
		__match.play_manager.unit_slot_finished.emit(unit)


func get_current_player() -> String:
	return sequence[sequence_index]


func advance() -> void:
	sequence_index += 1

	if sequence_index >= sequence.size():
		sequence_exhausted.emit()
		return

	var player := get_current_player()

	print("Sequence %d: Player %s to act" % [sequence_index + 1, player])

	sequence_advanced.emit(sequence, sequence_index, player)


func can_unit_use_slot(unit: Unit) -> bool:
	return (committed_unit == null or committed_unit == unit) \
		and not __was_unit_slot_already_utilised(unit)


func __was_unit_slot_already_utilised(unit: Unit) -> bool:
	return unit_sequence.slice(0, unit_sequence.size() - 1).has(unit)
