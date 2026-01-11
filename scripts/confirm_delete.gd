extends Panel

@onready var plane_crash: AudioStreamPlayer = $PlaneCrash

func _on_yes_pressed() -> void:
	if not Globals.saves[Globals.hovered_save] == {}:
		Globals.saves[Globals.hovered_save] = {}
		plane_crash.play()
		hide()

func _on_no_pressed() -> void:
	hide()
