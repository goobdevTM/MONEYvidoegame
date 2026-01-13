extends CanvasLayer

@onready var paper_crumpling: AudioStreamPlayer = $PaperCrumpling

func _ready() -> void:
	hide()
	Globals.in_help = false
#
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("delete") or Input.is_action_just_pressed("settings") and not Globals.in_settings:
		if visible:
			paper_crumpling.play()
			get_tree().paused = false
			hide()
			await get_tree().create_timer(0).timeout
			Globals.in_help = false
			
func open() -> void:
	show()
	Globals.in_help = true
	paper_crumpling.play()
	get_tree().paused = true
