class_name PlayerTurnDisplay extends Control

@onready var label_container: HBoxContainer = $LabelContainer

const PLAYER_CHAR_MAP = {
	"A": "A",
	"B": "B"
}

const PLAYER_COLOR_MAP = {
	"A": Global.PLAYER_A_COLOR,
	"B": Global.PLAYER_B_COLOR
}

var style_current_player: StyleBoxFlat
var style_normal_player_template: StyleBoxFlat

func _ready():
	style_current_player = StyleBoxFlat.new()
	style_current_player.bg_color = Global.PLAYER_TEXT_BG_CURRENT
	style_current_player.set_content_margin_all(5)
	style_current_player.corner_radius_top_left = 3
	style_current_player.corner_radius_top_right = 3
	style_current_player.corner_radius_bottom_left = 3
	style_current_player.corner_radius_bottom_right = 3

	style_normal_player_template = StyleBoxFlat.new()
	style_normal_player_template.set_content_margin_all(5)
	style_normal_player_template.corner_radius_top_left = 3
	style_normal_player_template.corner_radius_top_right = 3
	style_normal_player_template.corner_radius_bottom_left = 3
	style_normal_player_template.corner_radius_bottom_right = 3


func update_display(turn_sequence: Array, current_player_idx: int) -> void:
	for child in label_container.get_children():
		label_container.remove_child(child)
		child.queue_free()

	if turn_sequence.is_empty():
		return

	for i in range(turn_sequence.size()):
		var player_id: String = turn_sequence[i]
		var player_char: String = PLAYER_CHAR_MAP.get(player_id, "?")
		var player_specific_color: Color = PLAYER_COLOR_MAP.get(player_id, Color.WHITE)

		var label = Label.new()
		label.text = player_char
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.custom_minimum_size = Vector2(30, 30)
		label.add_theme_font_size_override("font_size", 18)

		if i == current_player_idx:
			label.add_theme_color_override("font_color", Global.PLAYER_TEXT_COLOR_CURRENT)
			label.add_theme_stylebox_override("normal", style_current_player)
			label.scale = Vector2(1.1, 1.1)
		else:
			label.add_theme_color_override("font_color", Global.PLAYER_TEXT_COLOR_NORMAL)
			var normal_style_instance = style_normal_player_template.duplicate() as StyleBoxFlat
			var bg_color_normal = player_specific_color
			bg_color_normal.a = 0.2
			normal_style_instance.bg_color = bg_color_normal
			label.add_theme_stylebox_override("normal", normal_style_instance)
			label.scale = Vector2(1.0, 1.0)

		label_container.add_child(label)
