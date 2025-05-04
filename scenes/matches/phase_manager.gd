extends Node
class_name PhaseManager

signal phase_changed(new_phase: int)

enum Phase { PLACEMENT, ORDERING, PLAY }

var current_phase: Phase = Phase.PLACEMENT

func enter_phase(new_phase: Phase) -> void:
	if new_phase != current_phase:
		current_phase = new_phase
		emit_signal("phase_changed", current_phase)

func get_current_phase() -> Phase:
	return current_phase
