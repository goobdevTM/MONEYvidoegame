extends Node2D

@onready var click_and_hover: Node = $ClickAndHover
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

var speed_up : float = 1

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
	canvas_modulate.color = lerp(Color.WHITE, Color(0.245, 0.362, 0.514, 1.0), clampf(abs(Globals.time - (Globals.day_length / 1.85)) / (Globals.day_length / 8) - 1.65, 0, 1))
	if Globals.sleeping:
		Globals.time += delta * speed_up #speed time
		if speed_up < 2:
			speed_up = 2
		speed_up = lerp(speed_up, 48.0, delta * 4)
	else:
		speed_up = 1
		Globals.time += delta
	if Globals.time > Globals.day_length:
		Globals.emit_signal("next_day")
		Globals.day += 1
		Globals.time = 0
