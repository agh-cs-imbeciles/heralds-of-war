extends VBoxContainer

var control_children: Array[Control]


func _ready() -> void:
	control_children.assign(get_children()
		.filter(func (child): return child is Control))
	print(control_children)
	
	
func _on_resized() -> void:
	var height = get_parent_area_size().y
	
	for control in control_children:
		control.add_theme_font_size_override("font_size", height / 4)
