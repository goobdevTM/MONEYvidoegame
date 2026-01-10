extends Node2D

@onready var click_and_hover: Node = $ClickAndHover
@onready var canvas_modulate: CanvasModulate = $CanvasModulate


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.set_ui_sounds(click_and_hover)
	Globals.in_game = true
	Globals.selected_slot += 1
	Globals.emit_signal("slot_selected")
	await get_tree().create_timer(0).timeout
	if Globals.selected_slot == -1:
		Globals.selected_slot = 0
	#fix bufg NO ROMOVE!!!
	Globals.selected_slot -= 1
	Globals.emit_signal("slot_selected")
	while is_inside_tree(): #AUTOSAVE
		await get_tree().create_timer(15).timeout
		Globals.set_saves(Globals.current_save)
		Globals.save_data()
		
func _process(delta: float) -> void:
	canvas_modulate.color = lerp(Color.WHITE, Color(0.305, 0.404, 0.535, 1.0), clampf(abs(Globals.time - (Globals.day_length / 2)) / (Globals.day_length / 4) - 0.5, 0, 1))
	Globals.time += delta * Globals.day_length
	if Globals.time > Globals.day_length:
		Globals.emit_signal("next_day")
		Globals.day += 1
		Globals.time = 0
