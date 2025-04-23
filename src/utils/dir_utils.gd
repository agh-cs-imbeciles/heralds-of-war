class_name DirUtils extends Node


static func get_all_scenes_paths_from_folder(path: String) -> Array[String]:
	var paths: Array[String] = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				var scene_path = path + "/" + file_name
				paths.append(scene_path)
			file_name = dir.get_next()
		dir.list_dir_end()
	
	return paths
