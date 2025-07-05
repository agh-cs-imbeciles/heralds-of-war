@tool
class_name SceneList extends VBoxContainer

@export var item: PackedScene
@export var handler: Script  ## `SceneListHandler`
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

	__instiantiate_matches()


func __instiantiate_matches() -> void:
	var file = FileAccess.open(
		"res://assets/resources/match_manifest.json",
		FileAccess.READ,
	)
	var paths: Array[String]
	paths.assign(JSON.parse_string(file.get_as_text()).map(
		func(path: String): return "res://scenes/matches/" + path
	))
	file.close()

	for path in paths:
		add_child(__handler.instiantiate(item, load(path)))
