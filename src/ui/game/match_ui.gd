class_name MatchUi extends Node

@onready var __match: Match = $".."
@onready var __board_ui: BoardUi = $"BoardUi"
@onready var end_game_panel: Panel = $"UiCanvasLayer/EndGamePanel"
@onready var player_turn_display: PlayerTurnDisplay = $"UiCanvasLayer/PlayerTurnDisplay"


func _ready() -> void:
	__match.match_ended.connect(__on_match_ended)

	if __match.is_node_ready():
		_connect_ordering_manager_signals()
	else:
		__match.ready.connect(_connect_ordering_manager_signals, CONNECT_ONE_SHOT)


func _connect_ordering_manager_signals() -> void:
	if __match and __match.play_manager and __match.play_manager.ordering_manager:
		if not __match.play_manager.ordering_manager.sequence_updated.is_connected(_on_sequence_updated):
			var error_code = __match.play_manager.ordering_manager.sequence_updated.connect(_on_sequence_updated)
			if error_code != OK:
				printerr("MatchUI: Failed to connect sequence_updated. Error: ", error_code)
			else:
				print("MatchUI: sequence_updated connected successfully.")
				var om = __match.play_manager.ordering_manager
				if om.sequence.size() > 0:
					_on_sequence_updated(om.sequence, om.sequence_index)
				elif __match.phase == Match.Phase.PLAY :
					om.init_sequence()
	else:
		push_warning("MatchUI: Match, PlayManager or OrderingManager not (yet) ready for PlayerTurnDisplay connection.")


func __on_match_ended(victor: String) -> void:
	show_end_game_panel(victor)


func show_end_game_panel(victor: String) -> void:
	__match.pause()
	__board_ui.hide()

	var label: Label = end_game_panel.find_child("VictorLabel")
	label.text = label.text % victor

	end_game_panel.show()


func _on_sequence_updated(turn_sequence: Array, current_player_idx: int) -> void:
	print("MatchUI: _on_sequence_updated called with sequence: ", turn_sequence, " and current_idx: ", current_player_idx)
	
	if player_turn_display:
		player_turn_display.update_display(turn_sequence, current_player_idx)
	else:
		push_warning("PlayerTurnDisplay node not found in MatchUi when trying to update display.")
