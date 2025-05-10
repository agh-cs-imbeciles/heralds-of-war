class_name BoardUi extends Node2D

@onready var __match: Match = $"../.."
@onready var __board: Board = $"../../Board"

enum HighlightTile { HOVER, FOCUS, MOVABLE }

var highlight_tile_scene: PackedScene = preload(
	"res://scenes/board/highlight-tile.tscn"
)

var __hover_tile: Sprite2D
var __focus_tile: Sprite2D
var __movable_tiles: Array[Sprite2D] = []


func _ready() -> void:
	__match.ready.connect(__on_match_ready)
	__board.ready.connect(__on_board_ready)

	__instantiate_highlight_tile(HighlightTile.HOVER)
	__instantiate_highlight_tile(HighlightTile.FOCUS)


func __on_match_ready() -> void:
	__match.play_manager.unit_focused.connect(__on_unit_focused)
	__match.play_manager.unit_unfocused.connect(__on_unit_unfocused)


func __on_board_ready() -> void:
	__board.input_manager.mouse_entered_cell.connect(__on_mouse_entered_cell)
	__board.input_manager.mouse_left_board.connect(__on_mouse_left_board)


func __on_mouse_entered_cell(cell_position: Vector2i) -> void:
	render_hover(__board.map_to_local(cell_position))


func __on_mouse_left_board() -> void:
	unrender_hover()


func __on_unit_focused(unit: Unit) -> void:
	render_focus(__board.map_to_local(unit.map_position))

	var moves_local: Array[Vector2]
	moves_local.assign(unit.get_legal_moves().map(__board.map_to_local))
	render_movable_cells(moves_local)


func __on_unit_unfocused() -> void:
	unrender_focus()
	unrender_movable_cells()


func __instantiate_highlight_tile(tile_type: HighlightTile) -> Sprite2D:
	var tile: Sprite2D = highlight_tile_scene.instantiate()

	match (tile_type):
		HighlightTile.HOVER:
			tile.name = "BoardHoverTile"
			tile.modulate = Color("#aabfe6", 0.784)
			tile.z_index = 64
			__hover_tile = tile
		HighlightTile.FOCUS:
			tile.name = "BoardFocusTile"
			tile.modulate = Color("#2ed9e6", 0.784)
			tile.z_index = 66
			__focus_tile = tile
		HighlightTile.MOVABLE:
			tile.name = "BoardMovableTile%s" % __movable_tiles.size()
			tile.modulate = Color("#6dd4d6", 0.584)
			tile.z_index = 65
			__movable_tiles.append(tile)

	if tile_type != HighlightTile.MOVABLE:
		tile.hide()

	add_child(tile)

	return tile


func render_hover(hover_position: Vector2) -> void:
	if __hover_tile.hidden:
		__hover_tile.show()
	__hover_tile.position = hover_position


func unrender_hover() -> void:
	__hover_tile.hide()


func render_focus(focus_position: Vector2) -> void:
	__focus_tile.position = focus_position
	__focus_tile.show()


func unrender_focus() -> void:
	__focus_tile.hide()


func render_movable_cells(moves: Array[Vector2]) -> void:
	for cell in moves:
		var tile = __instantiate_highlight_tile(HighlightTile.MOVABLE)
		tile.position = cell


func unrender_movable_cells() -> void:
	for cell in __movable_tiles:
		remove_child(cell)

	__movable_tiles.clear()
