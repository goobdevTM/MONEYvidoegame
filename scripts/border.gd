extends Area2D



@export var start_pos : Vector2
@export var fade_dir : int = 0
@export var to_scene : PackedScene
@onready var fade: Fade = $"../../Fade"

func _on_body_entered(body: Node2D) -> void:
	print(self)
	print(to_scene)
	if body is Player:
		#go
		Globals.fade_dir = fade_dir
		Globals.start_pos = start_pos
		fade.fade_out(to_scene)
