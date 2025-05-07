class_name BoardUi extends Node2D

@onready var board: Board = $"../../Board"

enum HighlightTile { HOVER, FOCUS, MOVABLE }

var highlight_tile_scene: PackedScene = preload(
	"res://scenes/board/highlight-tile.tscn"
)

var hover_tile: Sprite2D
var focus_tile: Sprite2D
var movable_tiles: Array[Sprite2D] = []


func _ready() -> void:
	__instantiate_highlight_tile(HighlightTile.HOVER)
	__instantiate_highlight_tile(HighlightTile.FOCUS)


func __instantiate_highlight_tile(tile_type: HighlightTile) -> Sprite2D:
	var tile: Sprite2D = highlight_tile_scene.instantiate()

	match (tile_type):
		HighlightTile.HOVER:
			tile.name = "BoardHoverTile"
			tile.modulate = Color("#aabfe6", 0.784)
			tile.z_index = 64
			hover_tile = tile
		HighlightTile.FOCUS:
			tile.name = "BoardFocusTile"
			tile.modulate = Color("#2ed9e6", 0.784)
			tile.z_index = 66
			focus_tile = tile
		HighlightTile.MOVABLE:
			tile.name = "BoardMovableTile%s" % movable_tiles.size()
			tile.modulate = Color("#6dd4d6", 0.584)
			tile.z_index = 65
			movable_tiles.append(tile)

	if tile_type != HighlightTile.MOVABLE:
		tile.hide()

	add_child(tile)

	return tile


func focus_cell(map_index: Vector2i) -> void:
	focus_tile.position = board.map_to_local(map_index)
	focus_tile.show()


func unfocus_cell() -> void:
	focus_tile.hide()


func hover_cell(map_index: Vector2i) -> void:
	if hover_tile.hidden:
		hover_tile.show()
	hover_tile.position = board.map_to_local(map_index)


func render_movable_cells(legal_moves: Array[Vector2i]) -> void:
	for cell in legal_moves:
		var tile = __instantiate_highlight_tile(HighlightTile.MOVABLE)
		tile.position = board.map_to_local(cell)


func unrender_movable_tiles() -> void:
	for cell in movable_tiles:
		remove_child(cell)

	movable_tiles.clear()
