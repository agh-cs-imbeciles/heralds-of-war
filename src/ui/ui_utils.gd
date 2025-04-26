class_name UiUtils


static func resize_font(object: Control, height_divider: float = 4) -> void:
	var height = object.get_parent_area_size().y
	object.add_theme_font_size_override("font_size", height / height_divider)


static func change_scene(object: Node, packed_scene: PackedScene) -> void:
	object.get_tree().change_scene_to_packed(packed_scene)


static func exit_game(object: Node) -> void:
	object.get_tree().quit()
