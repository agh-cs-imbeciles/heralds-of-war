class_name AbstractChangeSceneButton extends AbstractResizableFontButton

@export var scene_to_change: PackedScene


func __change_scene() -> void:
	UiUtils.change_scene(self, scene_to_change)
