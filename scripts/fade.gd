extends CanvasLayer

var tween: Tween = create_tween()

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	fade_in()

func fade_in():
	color_rect.color = Color()
	show()
	tween.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), 0.25)
	await tween.finished
	hide()

func fade_out(scene_change: PackedScene):
	color_rect.color = Color(0.0, 0.0, 0.0, 0.0)
	show()
	tween.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), 0.25)
	await tween.tween_finished
	get_tree().change_scene_to_packed(scene_change)
