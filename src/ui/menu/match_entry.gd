class_name MatchEntry extends Control

@onready var __button: ChangeSceneButton = $Button
@export var text: String = ""
@export var scene_to_switch: PackedScene


func __set_button_properties(button_text: String, scene: PackedScene) -> void:
	__button.text = button_text
	__button.scene_to_change = scene


func _on_property_list_changed() -> void:
	if __button:
		__set_button_properties(text, scene_to_switch)


func _on_ready() -> void:
	__set_button_properties(text, scene_to_switch)
