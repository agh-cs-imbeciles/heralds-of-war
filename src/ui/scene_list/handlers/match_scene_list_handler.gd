class_name MatchSceneListHandler extends SceneListHandler


func instiantiate(item: PackedScene, match_scene: PackedScene) -> Node:
	var match_instance: Match = match_scene.instantiate()
	var match_entry: MatchEntry = item.instantiate()

	match_entry.text = match_instance.match_name
	match_entry.scene_to_switch = match_scene

	return match_entry
