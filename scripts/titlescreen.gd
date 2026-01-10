extends Control

@onready var click_and_hover: Node = $ClickAndHover
@onready var saves: VBoxContainer = $BottomButtons/Saves

func _ready() -> void:
	Globals.set_ui_sounds(click_and_hover)

func _on_play_pressed() -> void:
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
	
