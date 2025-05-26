class_name MatchOrderingManager extends Object

signal sequence_advanced(player: String)
signal sequence_exhausted
signal unit_committed(unit: Unit)
signal unit_uncomitted(unit: Unit)

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
	var total_unit_count := 0
	var player_slot_count_to_fill: Dictionary[String, int] = {}
	for player in __players:
		total_unit_count += __board.units[player].size()
		player_slot_count_to_fill[player] = __board.units[player].size()

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


func uncommit_unit() -> void:
	var uncommitted_unit := committed_unit
	committed_unit = null
	unit_uncomitted.emit(uncommitted_unit)
	

func __on_unit_performed_action(unit: Unit) -> void:
	if committed_unit == null:
		committed_unit = unit
		unit_sequence.append(unit)
		unit_committed.emit(committed_unit)


func get_current_player() -> String:
	return sequence[sequence_index]


func advance() -> void:
	sequence_index += 1

	if sequence_index >= sequence.size():
		sequence_exhausted.emit()
		return

	var player := get_current_player()

	print("Sequence %d: Player %s to act" % [sequence_index + 1, player])

	sequence_advanced.emit(player)

	for unit in __board.units[player]:
		if not __was_unit_slot_already_utilised(unit):
			return
	advance()


func can_unit_use_slot(unit: Unit) -> bool:
	return (committed_unit == null or committed_unit == unit) \
		and not __was_unit_slot_already_utilised(unit)


func __was_unit_slot_already_utilised(unit: Unit) -> bool:
	return unit_sequence.slice(0, unit_sequence.size() - 1).has(unit)
