class_name StandardButton extends Button

@export var font_height_divider: float = 4


func __resize_font() -> void:
	UiUtils.resize_font(self, font_height_divider)
