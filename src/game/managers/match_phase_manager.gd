class_name MatchPhaseManager extends Object

signal pre_phase_changed(new_phase: Match.Phase)
signal phase_changed(new_phase: Match.Phase)

var __match: Match


func _init(m: Match) -> void:
	__match = m


func enter_phase(new_phase: Match.Phase) -> void:
	if new_phase == __match.phase:
		return

	pre_phase_changed.emit(new_phase)
	phase_changed.emit(new_phase)
