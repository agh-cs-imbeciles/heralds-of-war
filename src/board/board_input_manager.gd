class_name BoardInputManager extends Object

const Command = Operation.Command
var board: Board


func _init(board: Board) -> void:
	self.board = board


func __handle_mouse_motion() -> Operation:
	var mouse_map_position = board.get_mouse_map_position()
	if board.get_used_rect().has_point(mouse_map_position):
		return Operation.new(Command.HOVER, null, mouse_map_position)
	return Operation.new(Command.NONE, null, Vector2i.ZERO)


func __handle_mouse_click(event: InputEventMouseButton) -> Operation:
	var mouse_map_position = board.get_mouse_map_position()
	var current_unit = board.get_unit_on_positon(mouse_map_position)
	var command: Command = Command.FIELD_CLICK
	if current_unit != null:
		if event.button_index == MOUSE_BUTTON_LEFT:
			command = Command.UNIT_MOVE_CLICK
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			command = Command.UNIT_ATTACK_CLICK
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		command = Command.ATTACK_FIELD_CLICK
	return Operation.new(command, current_unit, mouse_map_position)
		
		
func process(event: InputEvent) -> Operation:
	if event is InputEventMouseMotion:
		return __handle_mouse_motion()

	if event is InputEventMouseButton and event.is_pressed() and \
	(event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT):
		return __handle_mouse_click(event)
	
	return Operation.new(Command.NONE, null, Vector2i.ZERO)
