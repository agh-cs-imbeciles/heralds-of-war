class_name MatchPhaseManager extends Object

signal phase_changed(new_phase: Match.Phase)

var __match: Match


func _init(m: Match) -> void:
	__match = m


func enter_phase(new_phase: Match.Phase) -> void:
	if new_phase == __match.phase:
		return

	phase_changed.emit(new_phase)
