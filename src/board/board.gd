extends TileMapLayer

enum HighlightTile { HOVER, FOCUS }

var is_tile_focused: bool = false

var swordsman_scene: PackedScene = preload("res://scenes/units/swordsman.tscn")
var highlight_tile: PackedScene = preload(
	"res://scenes/board/highlight-tile.tscn"
)
var hover_tile: Sprite2D
var focus_tile: Sprite2D
@onready var swordsman: Unit = $"../Swordsman"


func _ready() -> void:
	instantiate_swordsman()
	instantiate_highlight_tile(HighlightTile.HOVER)
	instantiate_highlight_tile(HighlightTile.FOCUS)


func instantiate_swordsman() -> Unit:
	swordsman = swordsman_scene.instantiate()

	swordsman.stamina = 6
	swordsman.offset = Vector2(8, -20)
	swordsman.offset_position = map_to_local(get_used_rect().size / 2)
	swordsman.position = swordsman.offset_position + swordsman.offset
	swordsman.scale = Vector2(0.5, 0.5)
	swordsman.z_index = 256

	add_sibling.call_deferred(swordsman)

	return swordsman


func instantiate_highlight_tile(tile_type: HighlightTile) -> void:
	var tile: Sprite2D = highlight_tile.instantiate()

	match (tile_type):
		HighlightTile.HOVER:
			tile.name = "BoardHoverTile"
			tile.modulate = Color("#aabfe6", 0.784)
			tile.z_index = 64
			hover_tile = tile
		HighlightTile.FOCUS:
			tile.name = "BoardFocusTile"
			tile.modulate = Color("#2ed9e6", 0.784)
			tile.z_index = 65
			focus_tile = tile

	tile.hide()
	add_sibling.call_deferred(tile)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_map_position = get_mouse_map_position()

		if get_used_rect().has_point(mouse_map_position):
			hover_cell(mouse_map_position)
		else:
			hover_tile.hide()

	if event is InputEventMouseButton and event.is_pressed():
		var mouse_map_position = get_mouse_map_position()
		var swordsman_map_position = local_to_map(swordsman.offset_position)

		if event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_map_position == swordsman_map_position:
				if not is_tile_focused:
					focus_cell(map_to_local(mouse_map_position))
			else:
				if is_tile_focused:
					swordsman.move(map_to_local(mouse_map_position))
				unfocus_cell()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if is_tile_focused:
				unfocus_cell()


func get_mouse_map_position() -> Vector2i:
	var mouse_position = get_local_mouse_position()
	var map_position = local_to_map(mouse_position)
	return map_position


func focus_cell(map_index: Vector2i) -> void:
	focus_tile.position = map_index
	focus_tile.show()
	is_tile_focused = true


func unfocus_cell() -> void:
	focus_tile.hide()
	is_tile_focused = false


func hover_cell(map_index: Vector2i) -> void:
	if hover_tile.hidden:
		hover_tile.show()
	hover_tile.position = map_to_local(map_index)
