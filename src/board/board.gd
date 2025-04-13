extends TileMapLayer

class_name Board

enum HighlightTile { HOVER, FOCUS, MOVABLE }

var is_tile_focused: bool = false
var moves: Array[Vector2i] = []

var path_finder: AStar2D = AStar2D.new()

var swordsman_scene: PackedScene = preload("res://scenes/units/swordsman.tscn")
var highlight_tile: PackedScene = preload(
	"res://scenes/board/highlight-tile.tscn"
)

var hover_tile: Sprite2D
var focus_tile: Sprite2D
var movable_tiles: Array[Sprite2D] = []
var swordsman: Unit


func _ready() -> void:
	init_path_finder()

	instantiate_swordsman()
	instantiate_highlight_tile(HighlightTile.HOVER)
	instantiate_highlight_tile(HighlightTile.FOCUS)


func init_path_finder() -> void:
	for cell in get_used_cells():
		var i = get_cell_id(cell)
		path_finder.add_point(i, cell)

	for cell in get_used_cells():
		var i = get_cell_id(cell)
		for surrounding_cell in get_surrounding_cells(cell):
			if not get_used_rect().has_point(surrounding_cell):
				continue
			var j = get_cell_id(surrounding_cell)
			path_finder.connect_points(i, j)


func instantiate_swordsman() -> Unit:
	swordsman = swordsman_scene.instantiate()

	swordsman.stamina = 6
	swordsman.offset = Vector2(8, -20)
	swordsman.board = self
	swordsman.set_position_from_map(get_used_rect().size / 2)
	swordsman.scale = Vector2(0.5, 0.5)
	swordsman.z_index = 256

	add_sibling.call_deferred(swordsman)

	return swordsman


func instantiate_highlight_tile(tile_type: HighlightTile) -> Sprite2D:
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
			tile.z_index = 66
			focus_tile = tile
		HighlightTile.MOVABLE:
			tile.name = "BoardMovableTile%s" % movable_tiles.size()
			tile.modulate = Color("#6dd4d6", 0.584)
			tile.z_index = 65
			movable_tiles.append(tile)

	if not HighlightTile.MOVABLE:
		tile.hide()

	add_sibling.call_deferred(tile)

	return tile


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_map_position = get_mouse_map_position()

		if get_used_rect().has_point(mouse_map_position):
			hover_cell(mouse_map_position)
		else:
			hover_tile.hide()

	if event is InputEventMouseButton and event.is_pressed():
		var mouse_map_position = get_mouse_map_position()

		if event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_map_position == swordsman.map_position:
				if not is_tile_focused:
					on_focus_cell(mouse_map_position)
			else:
				if is_tile_focused:
					on_unfocus_cell(mouse_map_position, true)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if is_tile_focused:
				on_unfocus_cell(mouse_map_position, false)


func get_cell_id(map_index: Vector2i) -> int:
		var max_index = get_used_rect().size.max_axis_index()
		var max_axis_value = get_used_rect().size[max_index]
		var max_axis_value_power_10 = 10**ceili(log(max_axis_value) / log(10))

		return max_axis_value_power_10 * map_index.x + map_index.y


func get_mouse_map_position() -> Vector2i:
	var mouse_position = get_local_mouse_position()
	var map_position = local_to_map(mouse_position)
	return map_position


func on_focus_cell(map_index: Vector2i) -> void:
	focus_cell(map_index)
	moves = swordsman.get_legal_moves(map_index)
	render_movable_cells(moves)


func focus_cell(map_index: Vector2i) -> void:
	focus_tile.position = map_to_local(map_index)
	focus_tile.show()
	is_tile_focused = true


func render_movable_cells(legal_moves: Array[Vector2i]) -> void:
	for cell in legal_moves:
		var tile = instantiate_highlight_tile(HighlightTile.MOVABLE)
		tile.position = map_to_local(cell)


func on_unfocus_cell(map_index: Vector2i, move: bool = false) -> void:
	if move and swordsman.can_move(map_index):
		swordsman.move(map_index)

	unrender_movable_tiles()
	unfocus_cell()


func unfocus_cell() -> void:
	focus_tile.hide()
	is_tile_focused = false


func unrender_movable_tiles() -> void:
	for cell in movable_tiles:
		get_parent().remove_child(cell)
	moves.clear()
	movable_tiles.clear()


func hover_cell(map_index: Vector2i) -> void:
	if hover_tile.hidden:
		hover_tile.show()
	hover_tile.position = map_to_local(map_index)
