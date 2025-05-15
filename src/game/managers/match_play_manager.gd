class_name MatchPlayManager extends Object

signal unit_focused(unit: Unit, unit_state: UnitState)
signal unit_unfocused

enum UnitState { SELECTED, ATTACK_SELECTED, NOT_SELECTED }

var __match: Match
var __board: Board
var ordering_manager: MatchOrderingManager

var focused_unit: Unit
var current_unit_state: UnitState = UnitState.NOT_SELECTED


func _init(m: Match) -> void:
	__match = m
	__board = m.board
	ordering_manager = MatchOrderingManager.new(m)

	__match.turn_ended.connect(__on_turn_ended)
	__match.phase_manager.phase_changed.connect(__on_phase_changed)
	ordering_manager.sequence_exhausted.connect(__on_sequence_exhausted)


func __on_turn_ended(_turn: int) -> void:
	ordering_manager.reset()


func __on_phase_changed(phase: Match.Phase) -> void:
	if phase != Match.Phase.PLAY:
		if __board.input_manager.cell_pressed.is_connected(__on_cell_pressed):
			__board.input_manager.cell_pressed.disconnect(__on_cell_pressed)
		return

	__board.input_manager.cell_pressed.connect(__on_cell_pressed)

	print("== Play Phase ==")

	if __match.turn == 1:
		ordering_manager.init_signal_connections()
	ordering_manager.init_sequence()


func __on_cell_pressed(cell_position: Vector2i, button: MouseButton) -> void:
	if button not in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]:
		return

	if current_unit_state != UnitState.NOT_SELECTED and button == MOUSE_BUTTON_RIGHT:
		unfocus_unit()
		current_unit_state = UnitState.NOT_SELECTED
		return

	# We are sure that in states SELECTED and ATTACK_SELECTED only input is MOUSE_BUTTON_LEFT
	match(current_unit_state):
		UnitState.SELECTED:
			if focused_unit.can_move(cell_position):
				focused_unit.move(cell_position)
			unfocus_unit()
			current_unit_state = UnitState.NOT_SELECTED
		UnitState.ATTACK_SELECTED:
			var unit := __board.get_unit(cell_position)
			if unit != null and not __is_current_player_unit(unit):
				perform_unit_attack(focused_unit, unit)
			unfocus_unit()
			current_unit_state = UnitState.NOT_SELECTED
		UnitState.NOT_SELECTED:
			var unit := __board.get_unit(cell_position)
			if unit  and __is_current_player_unit(unit):
				if button == MOUSE_BUTTON_LEFT:
					current_unit_state = UnitState.SELECTED 
				elif button == MOUSE_BUTTON_RIGHT:
					current_unit_state = UnitState.ATTACK_SELECTED
				focus_unit(unit, current_unit_state)


func __on_sequence_exhausted() -> void:
	__match.end_turn()


func __is_current_player_unit(unit: Unit) -> bool:
	if not unit:
		return false
	return unit.player == __match.get_current_player()


func focus_unit(unit: Unit, unit_state: UnitState) -> void:
	focused_unit = unit
	unit_focused.emit(unit, unit_state)


func unfocus_unit() -> void:
	focused_unit = null
	unit_unfocused.emit()


func perform_unit_attack(attacking: Unit, attacked: Unit) -> void:
	var attacked_position = attacked.map_position
	if not is_instance_of(attacking, MeleeUnit):
		return
	if not attacking.is_move_attackable(attacked_position):
		return
	
	var to_move = attacking.get_attack_to_move_dict().get(attacked_position)

	if to_move != attacking.map_position:
		attacking.move(to_move)
	attacking.attack()

	attacked.recieve_damage(attacking.attack_strength)
