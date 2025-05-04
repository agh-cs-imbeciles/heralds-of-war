extends TileMapLayer
class_name Board

signal tile_hovered(map_pos: Vector2i)
signal tile_clicked(map_pos: Vector2i)

enum HighlightTile { HOVER, FOCUS, MOVABLE }

var is_tile_focused: bool = false
var moves: Array[Vector2i] = []
var cost: Dictionary = {}

var path_finder: AStar2D = AStar2D.new()

var swordsman_scene: PackedScene = preload("res://scenes/units/swordsman.tscn")
var highlight_tile: PackedScene = preload("res://scenes/board/highlight-tile.tscn")

var hover_tile: Sprite2D
var focus_tile: Sprite2D
var movable_tiles: Array[Sprite2D] = []
var swordsman: Unit

@onready var game_match = get_parent() as Match
@onready var phase_manager = get_node("../PhaseManager") as PhaseManager


func _ready() -> void:
	load_board_cost()

	init_path_finder()
	instantiate_highlight_tile(HighlightTile.HOVER)
	instantiate_highlight_tile(HighlightTile.FOCUS)
	connect("tile_hovered", Callable(self, "_on_tile_hovered"))
	connect("tile_clicked", Callable(self, "_on_tile_clicked"))


func load_board_cost() -> void:
	var file = FileAccess.open(
		"res://assets/resources/board_cost.json",
		FileAccess.READ
	)
	var parsed_file = JSON.parse_string(file.get_as_text())

	for atlas_coords in parsed_file:
		if typeof(parsed_file[atlas_coords]) != TYPE_STRING:
			continue
		if parsed_file[atlas_coords] != "inf":
			continue

		parsed_file[atlas_coords] = 9223372036854775807  # 2^63 - 1

	cost = parsed_file


func init_path_finder() -> void:
	for cell in get_used_cells():
		var i = get_cell_id(cell)
		path_finder.add_point(i, cell, get_cell_cost(cell))
	for cell in get_used_cells():
		var i = get_cell_id(cell)
		for surrounding_cell in get_surrounding_cells(cell):
			if not get_used_rect().has_point(surrounding_cell):
				continue
			var j = get_cell_id(surrounding_cell)
			path_finder.connect_points(i, j)


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

	if tile_type != HighlightTile.MOVABLE:
		tile.hide()

	add_sibling.call_deferred(tile)

	return tile

func _get_unit_at_map(map_pos: Vector2i) -> Unit:
	for child in get_parent().get_children():
		if child is Unit and child.map_position == map_pos:
			return child
	return null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pos = get_mouse_map_position()
		if get_used_rect().has_point(pos):
			emit_signal("tile_hovered", pos)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var pos = get_mouse_map_position()
		if get_used_rect().has_point(pos):
			emit_signal("tile_clicked", pos)

func _on_tile_hovered(map_index: Vector2i) -> void:
	hover_cell(map_index)

func _on_tile_clicked(map_index: Vector2i) -> void:
	match phase_manager.get_current_phase():
		PhaseManager.Phase.PLAY:
			var clicked_unit := _get_unit_at_map(map_index)
			if clicked_unit and clicked_unit.player_id == game_match._get_current_player():
				swordsman = clicked_unit
				on_focus_cell(map_index)
			elif is_tile_focused:
				on_unfocus_cell(map_index, true)
		_:
			game_match._on_board_cell_clicked(map_index)

func get_cell_cost(map_index: Vector2i) -> int:
	var atlas_coords = get_cell_atlas_coords(map_index)
	var coord_key = "%s,%s" % [atlas_coords.x, atlas_coords.y]
	return cost.get(coord_key, 9223372036854775807)


func get_cell_id(map_index: Vector2i) -> int:
		var max_index = get_used_rect().size.max_axis_index()
		var max_axis_value = get_used_rect().size[max_index]
		var max_axis_value_power_10 = 10**ceili(log(max_axis_value) / log(10))

		return max_axis_value_power_10 * map_index.x + map_index.y


func get_mouse_map_position() -> Vector2i:
	var mouse_position = get_local_mouse_position()
	var map_position = local_to_map(mouse_position)
	return map_position


func move_unit_if_legal(to: Vector2i) -> void:
	if swordsman.can_move(to):
		var from = swordsman.map_position
		swordsman.move(to)
		print("Player %s moved unit from %s to %s" % [swordsman.player_id, from, to])



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
	if move:
		move_unit_if_legal(map_index)

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
