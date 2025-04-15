extends VBoxContainer


func _on_resized() -> void:
	var height = get_parent_area_size()[1]
	for child: Control in get_children():
		child.add_theme_font_size_override("font_size", height/4)
