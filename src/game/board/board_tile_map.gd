class_name BoardTileMap extends TileMapLayer

@onready var team_tiles: Array[TileMapLayer] = [
	$"./PlayerA",
	$"./PlayerB"
]
var __tile_update_functions: Dictionary[Vector2i, Callable] = {}


func update_tile(coords: Vector2i, fn: Callable):
	__tile_update_functions[coords] = fn
	notify_runtime_tile_data_update()


func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return __tile_update_functions.has(coords)


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	var fn: Callable = __tile_update_functions[coords]
	fn.call(tile_data)
	__tile_update_functions.erase(coords)
