class_name AbstractSceneList extends Control

@export var scenes_directory: String
@export_group("List element")
@export var scene: PackedScene
@export var height_proportion = 0.1


func __load_list_elements(_scene_paths: Array[String]) -> void:
	pass


func _on_tree_entered() -> void:
	var file = FileAccess.open(
		"res://assets/resources/match_manifest.json",
		FileAccess.READ,
	)
	var paths: Array[String]
	paths.assign(JSON.parse_string(file.get_as_text()).map(
		func(path: String): return "res://scenes/matches/" + path
	))
	file.close()

	__load_list_elements(paths)


func _on_resized() -> void:
	var viewport_height = get_parent_area_size().y
	for child in get_children():
		size.y = viewport_height * height_proportion
		child.set_size(size)
