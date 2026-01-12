extends CanvasLayer

class_name Fade

var tween: Tween = create_tween()
var fading: bool = false

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	fade_in()

func fade_in():
	tween.stop()
	tween = create_tween()
	color_rect.color = Color()
	show()
	tween.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), 0.25)
	await tween.finished
	hide()

func fade_out(scene_change: PackedScene):
	if fading == false:
		fading = true
		tween.stop()
		tween = create_tween()
		color_rect.color = Color(0.0, 0.0, 0.0, 0.0)
		show()
		tween.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), 0.25)
		
		await tween.finished
		
		get_tree().change_scene_to_packed(scene_change)
