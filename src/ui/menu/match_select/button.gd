extends Button


func _on_resized() -> void:
	UiUtils.resize_font(self)


func _on_pressed() -> void:
	get_tree().change_scene_to_file(get_parent_control().Text)
