extends TileMapLayer

class_name Board

enum HighlightTile { HOVER, FOCUS, MOVABLE, ATTACKABLE }
enum Mode { ATTACK, MOVE, NONE }
var Command = Operation.Command

var is_tile_focused: bool = false
var moves: Array[Vector2i] = []

var path_finder: AStar2D = AStar2D.new()
var board_input_manager: BoardInputManager = BoardInputManager.new(self)

var swordsman_scene: PackedScene = preload("res://scenes/units/swordsman.tscn")
var highlight_tile: PackedScene = preload(
	"res://scenes/board/highlight-tile.tscn"
)

var hover_tile: Sprite2D
var focus_tile: Sprite2D
var current_tile: Sprite2D
var current_mode: Mode = Mode.NONE 
var marked_tiles: Array[Sprite2D] = []
var current_unit: Unit
var units: Array[Unit] = []

func _ready() -> void:
	init_path_finder()

	var swordsman1 = instantiate_swordsman(Vector2i(5, 6))
	var swordsman2 = instantiate_swordsman(Vector2i(5, 8))
	instantiate_highlight_tile(HighlightTile.HOVER)
	instantiate_highlight_tile(HighlightTile.FOCUS)
	
	current_tile = hover_tile
	units.append(swordsman1)
	units.append(swordsman2)


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


func instantiate_swordsman(position: Vector2i) -> Unit:
	var swordsman: Unit = swordsman_scene.instantiate()

	swordsman.start_stamina = 6
	swordsman.start_health = 6
	swordsman.start_attack_strength = 3
	swordsman.start_attack_cost = 1
	swordsman.start_defense_percent = 40
	swordsman.offset = Vector2(8, -20)
	swordsman.board = self
	swordsman.start_map_position = position
	swordsman.scale = Vector2(0.5, 0.5)
	swordsman.z_index = 256
	swordsman.reset_intitial_state()
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
			tile.name = "BoardMovableTile%s" % marked_tiles.size()
			tile.modulate = Color("#6dd4d6", 0.584)
			tile.z_index = 65
			marked_tiles.append(tile)
		HighlightTile.ATTACKABLE:
			tile.name = "BoardAttackableTile%s" % marked_tiles.size()
			tile.modulate = Color("#ff4040", 0.584)
			tile.z_index = 65
			marked_tiles.append(tile)

	if tile_type != HighlightTile.MOVABLE or tile_type != HighlightTile.ATTACKABLE:
		tile.hide()

	add_sibling.call_deferred(tile)

	return tile


func _input(event: InputEvent) -> void:
	
	var operation: Operation = board_input_manager.process(event)

	match (operation.command):
		Command.NONE: 
			pass
		Command.HOVER:
			hover_cell(operation.position, current_tile)
		Command.UNIT_MOVE_CLICK:
			clear_board_user_input_effects()
			current_unit = operation.unit
			current_mode = Mode.MOVE
			on_focus_cell(operation.position)
		Command.UNIT_ATTACK_CLICK: 
			clear_board_user_input_effects()
			if current_mode == Mode.ATTACK and operation.unit != current_unit:
				on_unfocus_cell(operation.position, current_unit, current_mode)
				current_unit = null
				current_mode = Mode.NONE
			else:
				current_unit = operation.unit
				current_mode = Mode.ATTACK
				on_focus_cell(operation.position, HighlightTile.ATTACKABLE)
		Command.FIELD_CLICK:
			clear_board_user_input_effects()
			if current_mode == Mode.MOVE:
				on_unfocus_cell(operation.position, current_unit, current_mode)
			current_mode = Mode.NONE
			current_unit = null
		Command.ATTACK_FIELD_CLICK:
			clear_board_user_input_effects()
			if current_mode == Mode.ATTACK:
				on_unfocus_cell(operation.position, current_unit, current_mode)
			current_mode = Mode.NONE
			current_unit = null
			

func clear_board_user_input_effects() -> void:
	unfocus_cell()
	unrender_marked_tiles()


func get_cell_id(map_index: Vector2i) -> int:
	var max_index = get_used_rect().size.max_axis_index()
	var max_axis_value = get_used_rect().size[max_index]
	var max_axis_value_power_10 = 10**ceili(log(max_axis_value) / log(10))

	return max_axis_value_power_10 * map_index.x + map_index.y


func get_mouse_map_position() -> Vector2i:
	var mouse_position = get_local_mouse_position()
	var map_position = local_to_map(mouse_position)
	return map_position


func on_focus_cell(map_index: Vector2i, cell_type: HighlightTile = HighlightTile.MOVABLE) -> void:
	focus_cell(map_index)
	
	var cells
	if cell_type == HighlightTile.MOVABLE:
		cells = current_unit.get_legal_moves(map_index)
	elif cell_type == HighlightTile.ATTACKABLE:
		cells = current_unit.get_attack_fields(map_index)
	render_cells(cells, cell_type)


func focus_cell(map_index: Vector2i) -> void:
	focus_tile.position = map_to_local(map_index)
	focus_tile.show()
	is_tile_focused = true


func render_cells(legal_moves: Array[Vector2i], tile_type: HighlightTile = HighlightTile.MOVABLE) -> void:
	for cell in legal_moves:
		var tile = instantiate_highlight_tile(tile_type)
		tile.position = map_to_local(cell)
		tile.show()


func on_unfocus_cell(map_index: Vector2i, unit: Unit, action: Mode = Mode.MOVE) -> void:
	perform_unit_action(map_index, unit, action)
	unrender_marked_tiles()
	unfocus_cell()


func perform_unit_action(map_index: Vector2i, unit: Unit, action: Mode = Mode.MOVE) -> void:
	if action == Mode.MOVE and unit.can_move(map_index):
		unit.move(map_index)
	elif action == Mode.ATTACK and unit.is_attackable(map_index):
		var unit_to_attack = get_unit_on_positon(map_index)
		if unit_to_attack != null:
			current_mode = Mode.NONE
			if unit.stamina >= unit.attack_cost:
				unit.deplete_stamina(unit.attack_cost)
				unit_to_attack.recieve_damage(unit.attack_strength)


func unfocus_cell() -> void:
	focus_tile.hide()
	is_tile_focused = false


func unrender_marked_tiles() -> void:
	for cell in marked_tiles:
		get_parent().remove_child(cell)
	moves.clear()
	marked_tiles.clear()


func hover_cell(map_index: Vector2i, tile: Sprite2D) -> void:
	if tile.hidden:
		tile.show()
	tile.position = map_to_local(map_index)


func get_square(center: Vector2i, space: int) -> Array[Vector2i]:
	var cells = get_used_cells()
	var square_cells: Array[Vector2i]
	
	for i in range(-space - 1, space + 2):
		for j in range(-space - 1, space + 2):
			var new_vector = center
			new_vector.x += i
			new_vector.y += j
			if new_vector in get_used_cells():
				square_cells.append(new_vector)
	return square_cells
	

func get_unit_on_positon(map_index: Vector2i) -> Unit:
	for unit in units:
		if unit.map_position == map_index:
			return unit
	return null
	

func get_blocked_cells() -> Array[Vector2i]:
	var blocked_cells: Array[Vector2i] = []
	for unit in units:
		blocked_cells.append(unit.map_position)
	return blocked_cells
