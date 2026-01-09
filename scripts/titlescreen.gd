extends Control

@onready var click_and_hover: Node = $ClickAndHover

func _ready() -> void:
	Globals.set_ui_sounds(click_and_hover)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("uid://bug8okbqgftl2"))
