extends Button


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu/match_select.tscn")


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
	

func _on_resized() -> void:
	UiUtils.resize_font(self)
