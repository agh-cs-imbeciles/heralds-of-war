class_name PlayerTurnDisplay extends Control

@onready var sequence_container: HBoxContainer = $Sequence

var sequence_item_scene: PackedScene = preload(
	"res://scenes/ui/game/turn/sequence_item.tscn"
)


func update_display(sequence: Array[String], sequence_index: int) -> void:
	for child in sequence_container.get_children():
		sequence_container.remove_child(child)
		child.queue_free()

	if sequence.is_empty():
		return

	for i in sequence.size():
		var sequence_item: SequenceItem = sequence_item_scene.instantiate()
		sequence_item.player = sequence[i]
		if i == sequence_index:
			sequence_item.active = true

		sequence_container.add_child(sequence_item)
