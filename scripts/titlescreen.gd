extends Control

@onready var click_and_hover: Node = $ClickAndHover
@onready var saves: VBoxContainer = $BottomButtons/Saves

func _ready() -> void:
	Globals.selected_slot = 0
	Globals.start_pos = Vector2(0, 0)
	Globals.set_ui_sounds(click_and_hover)
	for i : Button in saves.get_children():
		i.get_child(1).text = str(i.get_index() + 1)
		if Globals.saves[i.get_index()].has('working_rats'): #check if not save empty
			i.get_child(0).get_child(0).show()
			i.get_child(0).get_child(1).hide()
		else:
			i.get_child(0).get_child(1).show()
			i.get_child(0).get_child(0).hide()
			
func _on_play_pressed() -> void:
	Globals.load_saves(Globals.current_save)
	get_tree().change_scene_to_packed(preload("uid://bug8okbqgftl2"))


func save_pressed(index : int) -> void:
	Globals.current_save = index
	for i : Button in saves.get_children():
		if not i.get_index() == index:
			i.button_pressed = false
	saves.get_child(index).button_pressed = true
	Globals.load_saves(index)


func _on_website_pressed() -> void:
	OS.shell_open("https://glagglewares.neocities.org/")
	if OS.has_feature('JavaScript'):
		JavaScriptBridge.eval("""
            window.open('https://glagglewares.neocities.org/', '_blank').focus();
		""")


func _on_quit_pressed() -> void:
	Globals.save_and_quit()
