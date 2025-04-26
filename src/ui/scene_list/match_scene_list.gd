class_name MatchSceneList extends AbstractSceneList


func __load_list_elements(matches_paths: Array[String]) -> void:
	for path in matches_paths:
		var match_scene: PackedScene = load(path)
		var match_instance: Match = match_scene.instantiate()

		var match_entry: MatchEntry = scene.instantiate()
		match_entry.text = match_instance.match_name
		match_entry.scene_to_switch = match_scene

		add_child(match_entry)
