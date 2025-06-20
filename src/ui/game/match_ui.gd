@tool
class_name MatchUi extends Node

@onready var __match: Match = $"../.."
@onready var __board_ui: BoardUi = $"BoardUi"
@onready var background: ColorRect = $"Background"
@onready var end_game_panel: Panel = $"UiCanvasLayer/EndGamePanel"
@onready var player_turn_display: PlayerTurnDisplay \
	= $"UiCanvasLayer/MarginContainer/VBoxContainer/PlayerTurnDisplay"


func _enter_tree() -> void:
	if NodeUtils.get_root(self) is Match and __match:
		__update_background_color()


func _ready() -> void:
	if NodeUtils.get_root(self) is Match:
		__update_background_color()

	if not Engine.is_editor_hint():
		__match.ready.connect(__on_match_ready)


func __update_background_color() -> void:
	background.color = __match.background_color



func __on_match_ready() -> void:
	__match.turn_ended.connect(__on_turn_ended)
	__match.match_ended.connect(__on_match_ended)
	__match.phase_manager.phase_changed.connect(__on_phase_changed)
	__match.board.unit_died.connect(__on_unit_died)
	__match.play_manager.ordering_manager.sequence_advanced.connect(
		__on_sequence_advanced
	)


func __on_turn_ended(_turn: int) -> void:
	update_player_turn_display()


func __on_match_ended(victor: String) -> void:
	show_end_game_panel(victor)


func __on_phase_changed(phase: Match.Phase) -> void:
	if phase == Match.Phase.PLAY:
		update_player_turn_display()


func __on_unit_died(_unit: Unit) -> void:
	update_player_turn_display()


func __on_sequence_advanced(
	_sequence: Array[String],
	_sequence_index: int,
	_player: String,
) -> void:
	update_player_turn_display()


func update_player_turn_display() -> void:
	var manager: MatchOrderingManager = __match.play_manager.ordering_manager
	player_turn_display.update_display(
		manager.sequence,
		manager.sequence_index,
	)


func show_end_game_panel(victor: String) -> void:
	__match.pause()
	__board_ui.hide()

	var label: Label = end_game_panel.find_child("VictorLabel")
	label.text = label.text % victor

	end_game_panel.show()
