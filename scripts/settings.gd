extends CanvasLayer

@onready var bg: ColorRect = $BG
@onready var control: Control = $Control


func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		Globals.in_settings = not Globals.in_settings
		if Globals.in_settings:
			open()
		else:
			close()
	
func open() -> void:
	get_tree().paused = true
	control.position = Vector2(0,480)
	bg.modulate.a = 0
	show()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.251), 0.1)
	tween.tween_property(control, "position", Vector2(0,0), 0.1)
	
func close() -> void:
	show()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	tween.tween_property(control, "position", Vector2(0,480), 0.1)
	await tween.finished
	hide()
	get_tree().paused = false
	
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value / 75)
