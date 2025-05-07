extends TileMapLayer

class_name Board

var cost: Dictionary = {}
var swordsman: Unit
var path_finder: AStar2D = AStar2D.new()

var swordsman_scene: PackedScene = preload("res://scenes/units/swordsman.tscn")


func _ready() -> void:
	load_board_cost()
	init_path_finder()
	instantiate_swordsman()


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


func instantiate_swordsman() -> Unit:
	swordsman = swordsman_scene.instantiate()

	swordsman.stamina = 60
	swordsman.offset = Vector2(8, -20)
	swordsman.board = self
	swordsman.set_position_from_map(get_used_rect().size / 2)
	swordsman.scale = Vector2(0.5, 0.5)
	swordsman.z_index = 256

	add_sibling.call_deferred(swordsman)

	return swordsman


func get_cell_cost(map_index: Vector2i) -> int:
	var atlas_coords = get_cell_atlas_coords(map_index)
	var coord_key = "%s,%s" % [atlas_coords.x, atlas_coords.y]
	return cost.get(coord_key, 9223372036854775807)


func get_cell_id(map_index: Vector2i) -> int:
		var max_index = get_used_rect().size.max_axis_index()
		var max_axis_value = get_used_rect().size[max_index]
		var max_axis_value_power_10 = 10**ceili(log(max_axis_value) / log(10))

		return max_axis_value_power_10 * map_index.x + map_index.y


func move_unit_if_legal(to: Vector2i) -> void:
	if swordsman.can_move(to):
		swordsman.move(to)
