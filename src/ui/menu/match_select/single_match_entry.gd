class_name SingleMatchEntry extends Control

@onready var __button = $Button
@export var Text = ""


func _on_property_list_changed() -> void:
	if __button:
		__button.text = Text


func _on_ready() -> void:
	__button.text = Text
