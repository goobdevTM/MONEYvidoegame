extends Area2D

@export var start_pos : Vector2
@export var change_to_scene : PackedScene = preload("uid://7xb7pi6ik7sv")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		#go
		Globals.coming_from = owner.name
		print(Globals.coming_from)
		get_tree().change_scene_to_packed(change_to_scene)
