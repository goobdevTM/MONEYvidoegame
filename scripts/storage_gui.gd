extends CanvasLayer

@onready var bg: ColorRect = $BG
@onready var control: Control = $Control
@onready var settings: CanvasLayer = $"../Settings"

func _ready() -> void:
	Globals.in_storage = false
	hide()
	
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("pickup") or Input.is_action_just_pressed("settings") and Globals.in_storage:
		#close()
	
func open() -> void:
	Globals.in_storage = true
	if Globals.in_settings:
		Globals.in_settings = false
		settings.close()
	get_tree().paused = true
	control.position = Vector2(0,480)
	bg.modulate.a = 0
	show()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.251), 0.1)
	tween.tween_property(control, "position", Vector2(0,0), 0.1)
	
func close() -> void:
	Globals.in_storage = false
	show()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	tween.tween_property(control, "position", Vector2(0,480), 0.1)
	await tween.finished
	hide()
	get_tree().paused = false
