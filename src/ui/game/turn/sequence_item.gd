class_name SequenceItem extends Control

var player: String = "A":
	set(value):
		player = value
		if player_label and player_label.is_node_ready():
			set_player_label_text(player)
			update_background_border()

var active: bool = false:
	set(value):
		active = value
		if player_label and player_label.is_node_ready():
			set_player_label_opacity(1.0 if active else 0.5)

@onready var player_label: Label = $"./MarginContainer/PlayerLabel"
@onready var background_border: Panel = $"./Background/Border"


func _ready() -> void:
	set_player_label_text(player)
	set_player_label_opacity(1.0 if active else 0.5)
	update_background_border()


func set_player_label_text(text: String) -> void:
	player_label.text = player


func set_player_label_opacity(alpha: float) -> void:
	var color := player_label.get_theme_color("font_color")
	player_label.add_theme_color_override("font_color", Color(color, alpha))


func update_background_border() -> void:
	var box: StyleBoxTexture = background_border.get_theme_stylebox("panel") \
		.duplicate()
	var texture_start_position: Vector2 = Vector2(
		34.0 if player == "A" else 68.0,
		box.region_rect.position.y,
	)
	box.region_rect = Rect2(texture_start_position, box.region_rect.size)

	background_border.add_theme_stylebox_override("panel", box)
