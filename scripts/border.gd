extends Area2D

@export var start_pos : Vector2
@export var change_to_scene : PackedScene = preload("res://scenes/home.tscn")

func _on_body_entered(body: Node2D) -> void:
	print(self)
	print(change_to_scene)
	if body is Player:
		#go
		Globals.start_pos = start_pos
		get_tree().change_scene_to_packed(change_to_scene)
