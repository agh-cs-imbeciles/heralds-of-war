extends Label

@export var font_height_divider: float = 6


func _on_resized() -> void:
	UiUtils.resize_font(self, font_height_divider)
