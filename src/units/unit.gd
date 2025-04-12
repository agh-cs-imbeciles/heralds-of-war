extends CharacterBody2D

class_name Unit

@export var offset: Vector2
var offset_position: Vector2


func _ready() -> void:
	offset_position = position - offset


func move(offset: Vector2) -> void:
	offset_position = offset
	position = offset_position + self.offset
