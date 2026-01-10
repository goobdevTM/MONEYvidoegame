extends Node2D

@onready var click_and_hover: Node = $ClickAndHover


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.set_ui_sounds(click_and_hover)
	Globals.in_game = true
	await get_tree().create_timer(0).timeout
	if Globals.selected_slot == -1:
		Globals.selected_slot = 0
	#fix bufg NO ROMOVE!!!
	Globals.selected_slot += 1
	Globals.emit_signal("slot_selected")
	Globals.selected_slot -= 1
	Globals.emit_signal("slot_selected")
	while is_inside_tree(): #AUTOSAVE
		await get_tree().create_timer(15).timeout
		Globals.set_saves(Globals.current_save)
