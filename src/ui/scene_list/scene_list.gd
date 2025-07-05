@tool
class_name SceneList extends VBoxContainer

@export var item: PackedScene
@export var scene_directory: String
@export var ignore_scenes: Array[String]
@export var handler: Script  # SceneListHandler
@export var width: float = 0.5

var __handler: SceneListHandler


func _process(_delta: float) -> void:
	var new_width: float = int(width * get_viewport().get_visible_rect().size.x)
	size = Vector2(new_width, size.y)
	var new_position_x: float = int(
		get_viewport().get_visible_rect().size.x / 2.0 - new_width / 2.0
	)
	position = Vector2(new_position_x, position.y)


func _ready() -> void:
	if not handler:
		return

	__handler = handler.new()
	assert(
		__handler is SceneListHandler,
		"Handler must be a subclass of SceneListHandler.",
	)

	var all_paths: Array[String] = Dir.get_all_scene_paths(scene_directory)
	var paths: Array[String] = all_paths.filter(
		func(path: String): return not ignore_scenes.has(path.split("/")[-1])
	)

	for path in paths:
		add_child(__handler.instiantiate(item, load(path)))
