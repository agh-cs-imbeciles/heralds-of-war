class_name Board extends Node2D

signal unit_added(unit: Unit)
signal unit_died(unit: Unit)

var cost: Dictionary[String, int] = {}
var units: Dictionary[String, Variant] = {}
var path_finder: AStar2D = AStar2D.new()

@onready var input_manager: BoardInputManager = $"./BoardInputManager"
@onready var unit_node_container: Node = $"./Units"
@onready var tile_map: BoardTileMap = $"../../Board/BoardTileMap"
@onready var obstacle_tile_map: StandardTileMap \
	= $"../../Board/BoardTileMap/ObstacleTileMap"


func _ready() -> void:
	load_board_cost()
	init_path_finder()


func load_board_cost() -> void:
	var file = FileAccess.open(
		"res://assets/resources/board_cost.json",
		FileAccess.READ
	)
	var parsed_file: Dictionary[String, Variant]
	parsed_file.assign(JSON.parse_string(file.get_as_text()))

	for atlas_coords in parsed_file:
		if typeof(parsed_file[atlas_coords]) != TYPE_STRING:
			continue
		if parsed_file[atlas_coords] != "inf":
			continue

		parsed_file[atlas_coords] = Global.CELL_COST_INFINITY

	cost.assign(parsed_file)


func init_path_finder() -> void:
	for cell in tile_map.get_used_cells():
		var i = get_cell_id(cell)
		path_finder.add_point(i, cell, get_cell_cost(cell))

	for cell in tile_map.get_used_cells():
		var i = get_cell_id(cell)
		for surrounding_cell in tile_map.get_surrounding_cells(cell):
			if not tile_map.get_used_rect().has_point(surrounding_cell):
				continue
			var j = get_cell_id(surrounding_cell)
			path_finder.connect_points(i, j)


func get_cell_cost(map_index: Vector2i) -> int:
	if obstacle_tile_map.get_cell_tile_data(map_index):
		return Global.CELL_COST_INFINITY

	var atlas_coords = tile_map.get_cell_atlas_coords(map_index)
	var coord_key = VectorUtils.vector2i_to_string(atlas_coords)
	return cost.get(coord_key, Global.CELL_COST_INFINITY)


func get_cell_id(map_index: Vector2i) -> int:
		var max_index = tile_map.get_used_rect().size.max_axis_index()
		var max_axis_value = tile_map.get_used_rect().size[max_index]
		var max_axis_value_power_10 = 10**ceili(log(max_axis_value) / log(10))

		return max_axis_value_power_10 * map_index.x + map_index.y


func get_unit(map_index: Vector2i) -> Unit:
	var unit_container_children: Array[Unit]
	unit_container_children.assign(unit_node_container.get_children())

	for unit in unit_container_children:
		if unit.map_position == map_index:
			return unit
	return null


func add_unit(unit: Unit) -> void:
	unit.moved.connect(__on_unit_moved)
	unit.died.connect(__on_unit_died)
	units[unit.player].append(unit)
	update_cell_cost(unit.map_position, Global.CELL_COST_INFINITY)

	unit_added.emit(unit)


func __on_unit_moved(unit: Unit, from: Vector2i) -> void:
	update_cell_cost(from, get_cell_cost(from))
	update_cell_cost(unit.map_position, Global.CELL_COST_INFINITY)


func __on_unit_died(unit: Unit) -> void:
	unit_died.emit(unit)


func remove_unit(unit: Unit) -> void:
	units[unit.player].erase(unit)
	unit_node_container.remove_child(unit)
	update_cell_cost(unit.map_position, get_cell_cost(unit.map_position))


func get_total_unit_count() -> int:
	var total_unit_count := 0
	for player in units:
		total_unit_count += units[player].size()

	return total_unit_count


func get_player_unit_count() -> Dictionary[String, int]:
	var player_unit_count: Dictionary[String, int] = {}
	for player in units:
		player_unit_count[player] = units[player].size()

	return player_unit_count


func is_obstacle_at(map_index: Vector2i) -> bool:
	return obstacle_tile_map.get_cell_tile_data(map_index) != null


func update_cell_cost(map_index: Vector2i, new_cost: float) -> void:
	var i := get_cell_id(map_index)
	path_finder.set_point_weight_scale(i, new_cost)


func get_nearest_cells(center: Vector2i, max_distance: int) -> Array[Vector2i]:
	var square_cells: Array[Vector2i]

	for i in range(-max_distance - 1, max_distance + 2):
		for j in range(-max_distance - 1, max_distance + 2):
			var cell := center + Vector2i(i, j)
			if cell in tile_map.get_used_cells():
				square_cells.append(cell)

	return square_cells
