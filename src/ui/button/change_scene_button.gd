class_name ChangeSceneButton extends Button

@export var scene_to_change: PackedScene


func _pressed() -> void:
	UiUtils.change_scene(self, scene_to_change)
