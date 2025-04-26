class_name MatchSceneList extends AbstractSceneList


func __load_list_elements(matches_paths: Array[String]) -> void:
	for path in matches_paths:
		var instantiated_entry: MatchEntry = scene.instantiate()
		var match_scene: PackedScene = load(path)
		var instantiated_match: Match = match_scene.instantiate()
		instantiated_entry.text = instantiated_match.match_name
		instantiated_entry.scene_to_switch = match_scene
		add_child(instantiated_entry)
