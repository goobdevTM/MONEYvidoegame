extends CanvasLayer

@onready var paper_crumpling: AudioStreamPlayer = $PaperCrumpling

func _ready() -> void:
	hide()
#
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("delete") or Input.is_action_just_pressed("settings"):
		if visible:
			get_tree().paused = false
			hide()
			paper_crumpling.play()
