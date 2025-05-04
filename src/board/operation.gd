class_name Operation extends Object

enum Command { HOVER, UNIT_MOVE_CLICK, UNIT_ATTACK_CLICK, FIELD_CLICK, ATTACK_FIELD_CLICK, NONE }

var command: Command
var unit: Unit
var position: Vector2i


func _init(
	command: Command = Command.NONE,
	unit: Unit = null, 
	position: Vector2i = Vector2i.ZERO) -> void:
		
	self.command = command
	self.unit = unit
	self.position = position
