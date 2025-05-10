class_name PhaseManager extends Node

enum Phase { PLACEMENT, ORDERING, PLAY }

var current_phase: Phase = Phase.PLACEMENT

signal phase_changed(new_phase: int)


func enter_phase(new_phase: Phase) -> void:
	if new_phase != current_phase:
		current_phase = new_phase
		emit_signal("phase_changed", current_phase)
