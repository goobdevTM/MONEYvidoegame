extends Node

var current_song: AudioStreamPlayer

@onready var rat_theme: AudioStreamPlayer = $RatTheme

#READY
func _ready() -> void:
	#LOOPS
	while true:
		#CYCLES THROUGH CHILDREN
		for i: AudioStreamPlayer in get_children():
			if i.is_in_group("main_songs"):
				i.play()
				current_song = i
				await i.finished

func play_rat_theme():
	var tween: Tween = create_tween()
	tween.tween_property(current_song, "volume_linear", 0, 0.5)
	tween.tween_property(rat_theme, "volume_linear", 1, 0.25)
	rat_theme.play()
	await rat_theme.finished
	tween.tween_property(current_song, "volume_linear", 1, 0.5)

func stop_rat_theme():
	var tween: Tween = create_tween()
	tween.tween_property(rat_theme, "volume_linear", 0, 0.5)
	tween.tween_property(current_song, "volume_linear", 1, 0.5)
	await tween.finished
	rat_theme.stop()
