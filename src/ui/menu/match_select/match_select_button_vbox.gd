extends VBoxContainer

var matches_directory = "res://scenes/matches/"


func __get_matches_paths() -> Array[String]:
	return DirUtils.get_all_scenes_paths_from_folder(matches_directory)


func __load_buttons(matches_paths: Array[String]) -> void:
	var single_match_entry_string = "res://scenes/ui/menu/match_select/single_match_entry.tscn"
	for path in matches_paths:
		var single_match_entry: PackedScene = load(single_match_entry_string)
		var instantiated_entry: SingleMatchEntry = single_match_entry.instantiate()
		instantiated_entry.Text = path
		add_child(instantiated_entry)


func _on_tree_entered() -> void:
	var paths = __get_matches_paths()
	__load_buttons(paths)
	
	
func _on_resized() -> void:
	var viewport_height = get_parent_area_size().y
	for child in get_children():
		if child is SingleMatchEntry:
			var v = child.size
			size.y = viewport_height * 0.1
			child.set_size(size)
