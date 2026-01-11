extends Control


@onready var bg: ColorRect = $BG
@onready var control: Control = $Control


func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		if Globals.in_help:
			close()
	if Input.is_action_just_pressed("help"):
		if Globals.in_help:
			close()
		else:
			open()


func open() -> void:
	
	get_tree().paused = true
	show()

	bg.modulate.a = 0
	control.scale = Vector2(0,0)
	
	Globals.in_help = true
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	tween.tween_property(control, "scale", Vector2(1,1), 0.1)

	
func close() -> void:

	Globals.in_help = false
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	tween.tween_property(control, "scale", Vector2(0,0), 0.1)
	await tween.finished
	hide()
	if not Globals.in_storage:
		get_tree().paused = false
