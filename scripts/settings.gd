extends CanvasLayer

@onready var bg: ColorRect = $BG
@onready var control: Control = $Control
@onready var stamina_opacity: HSlider = $Control/TabContainer/Video/StaminaOpacity

#AUDIO STUFF yhuj
@onready var music: AudioStreamPlayer = $Music
@onready var sound_slider: HSlider = $Control/TabContainer/Audio/Sound
@onready var music_slider: HSlider = $Control/TabContainer/Audio/Music
@onready var master_slider: HSlider = $Control/TabContainer/Audio/Master


func _ready() -> void:
	stamina_opacity.value = Globals.stamina_bar_opacity
	
	
	sound_slider.value = Globals.sound_volume
	music_slider.value = Globals.music_volume
	master_slider.value = Globals.master_volume
	_on_master_value_changed(Globals.master_volume)
	_on_music_value_changed(Globals.music_volume)
	_on_sound_value_changed(Globals.sound_volume)
	
	hide()

func _process(delta: float) -> void:
	if not Globals.in_storage and not Globals.in_smellizon:
		if Input.is_action_just_pressed("settings"):
			Globals.in_settings = not Globals.in_settings
			if Globals.in_settings:
				open()
			else:
				close()
	
func open() -> void:
	Globals.in_settings = true
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
	Globals.in_settings = false
	music.stop()
	show()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	tween.tween_property(control, "position", Vector2(0,480), 0.1)
	await tween.finished
	hide()
	get_tree().paused = false
	


func _on_stamina_opacity_value_changed(value: float) -> void:
	Globals.stamina_bar_opacity = value


func _on_quit_button_pressed() -> void:
	if Globals.in_game:
		get_tree().paused = false
		close()
		Globals.set_saves(Globals.current_save)
		await get_tree().create_timer(0.05).timeout
		get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")
	else:
		Globals.save_and_quit()


func _on_master_value_changed(value: float) -> void:
	Globals.master_volume = value
	AudioServer.set_bus_volume_linear(0, value / 75)

func _on_sound_value_changed(value: float) -> void:
	Globals.sound_volume = value
	AudioServer.set_bus_volume_linear(2, value / 75)

func _on_music_value_changed(value: float) -> void:
	Globals.music_volume = value
	AudioServer.set_bus_volume_linear(1, value / 75)
