extends Node

var current_song: AudioStreamPlayer

@onready var rat_theme: AudioStreamPlayer = $RatTheme
var tween : Tween = create_tween()
#READY
func _ready() -> void:
	#LOOPS
	while true:
		#CYCLES THROUGH CHILDREN
		for i in range(Globals.song_playing, len(get_children())):
			if get_child(i).is_in_group("main_songs"):
				if rat_theme.playing:
					await rat_theme.finished
				current_song = get_child(i)
				current_song.play(Globals.song_time + 0.025)
				Globals.song_playing = i
				while current_song.playing:
					await get_tree().create_timer(0.1).timeout
					Globals.song_time = current_song.get_playback_position()
				Globals.song_time = 0
		Globals.song_playing = 0

func play_rat_theme():
	tween.stop()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(current_song, "volume_linear", 0, 0.5)
	tween.tween_property(rat_theme, "volume_linear", 1, 0.25)
	rat_theme.play()
	await rat_theme.finished
	tween.tween_property(current_song, "volume_linear", 1, 0.5)

func stop_rat_theme():
	if Globals.rats_running <= 0:
		tween.stop()
		tween = create_tween()
		tween.set_parallel()
		tween.tween_property(rat_theme, "volume_linear", 0, 0.5)
		tween.tween_property(current_song, "volume_linear", 1, 0.5)
		await tween.finished
		rat_theme.stop()
