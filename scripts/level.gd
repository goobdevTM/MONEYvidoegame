class_name Level

extends Node2D



const TRASH = preload("uid://blwgbgbei4tsn")

@onready var trash_spawner: Node2D = $TrashSpawner
@onready var top: CollisionShape2D = $Borders/Top
@onready var bottom: CollisionShape2D = $Borders/Bottom

func _ready() -> void:
	generate_trash(0)

#SPAWNS TRASH
func generate_trash(spawn_x: int) -> void:

	#generate a piece of trash trash_amount times
	for i in range(Globals.trash_amount):
		var new_trash : Node2D = TRASH.instantiate()
		trash_spawner.add_child(new_trash)
		new_trash.position = Vector2(randi_range(spawn_x, spawn_x + 768), randi_range(top.position.y + 64, bottom.position.y - 64))
