class_name UnitHealthBar extends TextureProgressBar

@onready var unit: Unit = $"../.."


func _ready() -> void:
	value = unit.health
	max_value = unit.initial_health
	set_progress_color(
		Color("#1ad9ff") if unit.player == "A" else Color("#ff1a57"),
	)


func set_health(health: int) -> void:
	value = int(100.0 * health / max_value)


func set_progress_color(color: Color) -> void:
	tint_progress = Color(color)
