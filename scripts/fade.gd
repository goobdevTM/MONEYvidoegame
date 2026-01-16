extends CanvasLayer

class_name Fade

var tween: Tween = create_tween()
var fading: bool = false
var fading_in : bool = false

@onready var color_rect: ColorRect = $ColorRect
@onready var gradient: TextureRect = $Gradient
@onready var gradient_anim: AnimationPlayer = $Gradient/GradientAnim

@export var fade_direction : int = 0
@export var borders : Array[CollisionShape2D] = []
@export var use_global_dir : bool = false

func _ready() -> void:
	fade_in()

func fade_in():
	if use_global_dir:
		fade_direction = Globals.fade_dir
	if fading_in == false:
		while fading_in:
			await get_tree().create_timer(0).timeout
	if abs(fade_direction) > 0:
		gradient.show()
		if fade_direction > 0:
			gradient_anim.play("fade_in")
		else:
			gradient_anim.play("fade_in_opposite")
	else:
		gradient.queue_free()
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


func fade_out(scene_change: PackedScene):
	if fading == false:
		while fading:
			await get_tree().create_timer(0).timeout
	if abs(fade_direction) > 0:
		gradient.show()
		gradient_anim.stop()
		if fade_direction > 0:
			gradient_anim.play("fade_out")
		else:
			gradient_anim.play("fade_out_opposite")
	fading = true
	tween.stop()
	tween = create_tween()
	color_rect.color = Color(0.0, 0.0, 0.0, 0.0)
	show()
	tween.tween_property(color_rect, "color", Color(0.0, 0.0, 0.0, 1.0), 0.25)
	
	await tween.finished
		
	get_tree().change_scene_to_packed(scene_change)
