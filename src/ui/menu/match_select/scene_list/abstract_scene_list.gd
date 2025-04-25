class_name AbstractSceneList extends Control

@export var scenes_directory: String
@export_group("List element")
@export var scene: PackedScene
@export var height_proportion = 0.1


func __get_scenes_paths() -> Array[String]:
	return Dir.get_all_scenes_paths_from_folder(scenes_directory)


func __load_list_elements(scene_paths: Array[String]) -> void:
	pass


func _on_tree_entered() -> void:
	var paths = __get_scenes_paths()
	__load_list_elements(paths)


func _on_resized() -> void:
	var viewport_height = get_parent_area_size().y
	for child in get_children():
		size.y = viewport_height * height_proportion
		child.set_size(size)
