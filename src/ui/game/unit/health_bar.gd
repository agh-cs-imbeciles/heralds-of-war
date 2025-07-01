extends TextureProgressBar

@onready var unit: Unit = $"../.."

func _ready() -> void:
	value = unit.health
	max_value = unit.initial_health


func set_health(current_health: int, max_health: int) -> void:
	value = int(float(current_health) / float(max_health) * 100)
