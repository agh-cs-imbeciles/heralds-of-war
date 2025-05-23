class_name MatchOrderingManager extends Object

signal sequence_advanced(player: String)
signal sequence_exhausted

var sequence: Array[String] = []
var sequence_index: int = 0
var unit_sequence: Array[Unit] = []
var current_unit: Unit
var potential_unit: Unit

var __match: Match
var __board: Board
var __players: Array[String]


func _init(m: Match) -> void:
	__match = m
	__board = m.board
	__players = m.players


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
	current_unit = null
	potential_unit = null

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
			unit.stamina_depleted.connect(__on_unit_slot_finished)


func __on_unit_slot_finished(_unit: Unit) -> void:
	advance()


func __on_unit_performed_action(_unit: Unit) -> void:
	if potential_unit != null:
		commit_potential_unit()


func get_current_player() -> String:
	return sequence[sequence_index]


func __on_unit_selected(unit: Unit, __) -> void:
	if unit.player != get_current_player():
		return
	if unit in unit_sequence:
		return

	potential_unit = unit


func commit_potential_unit() -> void:
	current_unit = potential_unit
	unit_sequence.append(potential_unit)
	potential_unit = null
	SignalBus.unit_committed.emit(current_unit)


func advance() -> void:
	sequence_index += 1

	current_unit = null
	potential_unit = null
	SignalBus.unit_uncomitted.emit()

	if sequence_index >= sequence.size():
		sequence_exhausted.emit()
		return

	var player := get_current_player()

	print("Sequence %d: Player %s to act" % [sequence_index + 1, player])

	sequence_advanced.emit(player)


func __was_unit_slot_finished(unit: Unit) -> bool:
	return unit_sequence.slice(0, unit_sequence.size()-1).has(unit)


func can_unit_perform_action(unit: Unit) -> bool:
	return (current_unit == null or current_unit == unit) and !__was_unit_slot_finished(unit)
