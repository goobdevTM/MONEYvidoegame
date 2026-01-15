extends CanvasLayer

class_name Fade

var tween: Tween = create_tween()
var fading: bool = false
var fading_in : bool = false

@onready var color_rect: ColorRect = $ColorRect

@export var borders : Array[CollisionShape2D] = []

func _ready() -> void:
	fade_in()

func fade_in():
	if fading_in == false:
		while fading_in:
			await get_tree().create_timer(0).timeout
	fading_in = true
	await get_tree().create_timer(0.15).timeout
	tween.stop()
	tween = create_tween()
	color_rect.color = Color()
	show()
	tween.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 0.0), 0.25)
	await get_tree().create_timer(0.2).timeout
	for i in borders:
		i.disabled = true
	await tween.finished
	hide()

func fade_out(scene_change: PackedScene):
	if fading == false:
		while fading:
			await get_tree().create_timer(0).timeout
	fading = true
	tween.stop()
	tween = create_tween()
	color_rect.color = Color(0.0, 0.0, 0.0, 0.0)
	show()
	tween.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), 0.25)
	
	await tween.finished
		
	get_tree().change_scene_to_packed(scene_change)
