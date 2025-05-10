extends TileMapLayer

class_name Board

var cost: Dictionary = {}
var units: Dictionary = {}
var path_finder: AStar2D = AStar2D.new()

@onready var input_manager: BoardInputManager = $"BoardInputManager"
@onready var unit_node_container: Node = $"Units"


func _ready() -> void:
	load_board_cost()
	init_path_finder()


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

		parsed_file[atlas_coords] = 9007199254740991  # 2^53 - 1

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


func get_cell_cost(map_index: Vector2i) -> int:
	var atlas_coords = get_cell_atlas_coords(map_index)
	var coord_key = "%s,%s" % [atlas_coords.x, atlas_coords.y]
	return cost.get(coord_key, 9007199254740991)


func get_cell_id(map_index: Vector2i) -> int:
		var max_index = get_used_rect().size.max_axis_index()
		var max_axis_value = get_used_rect().size[max_index]
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
	units[unit.player].append(unit)
	update_cell_cost(unit.map_position, 9007199254740991)


func __on_unit_moved(unit: Unit, from: Vector2i) -> void:
	update_cell_cost(from, get_cell_cost(from))
	update_cell_cost(unit.map_position, 9007199254740991)


func update_cell_cost(map_index: Vector2i, new_cost: float) -> void:
	var i := get_cell_id(map_index)
	path_finder.set_point_weight_scale(i, new_cost)
