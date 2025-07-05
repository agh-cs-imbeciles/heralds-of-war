@tool
extends EditorScript


func _run():
	var dir: DirAccess = DirAccess.open("res://scenes/matches")
	var match_scene_paths: Array[String] = []
	var match_regex: RegEx = RegEx.create_from_string("match_\\d+\\.tscn$")

	dir.list_dir_begin()

	var path: String = dir.get_next()
	while path != "":
		if not dir.current_is_dir() and match_regex.search(path):
			match_scene_paths.append(path)
		path = dir.get_next()

	var output_file: FileAccess = FileAccess.open(
		"res://assets/resources/match_manifest.json",
		FileAccess.WRITE,
	)
	var indent: String = " ".repeat(2)
	output_file.store_string(JSON.stringify(match_scene_paths, indent))
	output_file.close()
