extends Panel

@onready var plane_crash: AudioStreamPlayer = $PlaneCrash
@onready var titlescreen: Control = $".."
@onready var saves: VBoxContainer = $"../BottomButtons/Saves"


func _on_yes_pressed() -> void:
	if not Globals.saves[Globals.hovered_save] == {}:
		Globals.saves[Globals.hovered_save] = {}
		plane_crash.play()
		hide()
		titlescreen.set_saves()
		saves.get_child(Globals.hovered_save).button_pressed = true

func _on_no_pressed() -> void:
	hide()
