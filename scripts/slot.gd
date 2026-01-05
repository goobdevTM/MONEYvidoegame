extends Control

var selected: bool = false
var index: int

@onready var slot_bg: Sprite2D = $SlotBG

func _input(event: InputEvent) -> void:
	if Globals.selected_slot == index:
		selected = true
		slot_bg.self_modulate = Color(0.49, 0.49, 0.49, 1.0)
	else:
		slot_bg.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
