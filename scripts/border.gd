extends Area2D

const ALLEY = "res://scenes/alley.tscn"

@export var to_home : bool = false
@export var start_pos : Vector2
@export var to_scene : PackedScene
@onready var fade: Fade = $"../../Fade"

func _on_body_entered(body: Node2D) -> void:
	print(self)
	print(to_scene)
	if body is Player:
		#go
		Globals.start_pos = start_pos
		if to_home:
			fade.fade_out(load(ALLEY))
		else:
			fade.fade_out(to_scene)
