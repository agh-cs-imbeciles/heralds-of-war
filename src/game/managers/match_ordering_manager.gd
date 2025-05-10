class_name MatchOrderingManager extends Object

signal sequence_advanced(player: String)
signal sequence_exhausted

var sequence: Array[String] = []
var sequence_index: int = 0

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
			unit.moved.connect(__on_unit_moved)


func __on_unit_moved(_unit: Unit, _from: Vector2i) -> void:
	advance()


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
