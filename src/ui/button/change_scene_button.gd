class_name ChangeSceneButton extends StandardButton

@export var scene_to_change: PackedScene


func __change_scene() -> void:
	UiUtils.change_scene(self, scene_to_change)
