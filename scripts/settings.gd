extends CanvasLayer

@onready var bg: ColorRect = $BG
@onready var control: Control = $Control
@onready var master_slider: HSlider = $Control/TabContainer/Audio/Master
@onready var music: AudioStreamPlayer = $Music
@onready var stamina_opacity: HSlider = $Control/TabContainer/Video/StaminaOpacity


func _ready() -> void:
	stamina_opacity.value = Globals.stamina_bar_opacity
	master_slider.value = Globals.master_volume
	hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		Globals.in_settings = not Globals.in_settings
		if Globals.in_settings:
			open()
		else:
			close()
	
func open() -> void:
	music.play()
	get_tree().paused = true
	control.position = Vector2(0,480)
	bg.modulate.a = 0
	show()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.251), 0.1)
	tween.tween_property(control, "position", Vector2(0,0), 0.1)
	
func close() -> void:
	music.stop()
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

func _on_h_slider_value_changed(value: float) -> void:
	Globals.stamina_bar_opacity = value


func _on_button_pressed() -> void:
	Globals.save_data()
	get_tree().quit()
