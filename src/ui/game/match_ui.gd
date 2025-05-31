class_name MatchUi extends Node

@onready var __match: Match = $".."
@onready var __board_ui: BoardUi = $"BoardUi"
@onready var end_game_panel: Panel = $"UiCanvasLayer/EndGamePanel"


func _ready() -> void:
	__match.ended.connect(__on_match_ended)


func __on_match_ended(victor: String) -> void:
	show_end_game_panel(victor)


func show_end_game_panel(victor: String) -> void:
	__match.pause()
	__board_ui.hide()

	var label: Label = end_game_panel.find_child("VictorLabel")
	label.text = label.text % victor

	end_game_panel.show()
