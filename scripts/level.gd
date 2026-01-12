class_name Level

extends Node2D



const TRASH = preload("res://scenes/trash.tscn")

@onready var trash_spawner: Node2D = $TrashSpawner
@onready var top: CollisionShape2D = $Borders/Top
@onready var bottom: CollisionShape2D = $Borders/Bottom
	
func _ready() -> void:
	generate_trash(-256)
	
#SETS UP THREAD TO GENERATE
func generate_trash(spawn_x: int) -> void:
	for i in range((Globals.areas[Globals.area]['trash_amount']) + Globals.get_upgrade_value(3)):
		var new_trash : Trash = TRASH.instantiate()
		trash_spawner.add_child(new_trash)
		new_trash.position = Vector2(randi_range(spawn_x, spawn_x + 256), randi_range(top.position.y + 24, bottom.position.y - 24))
		print(new_trash)
	

func move(object : Node2D, new_pos : Vector2) -> void:
	object.position = new_pos
	
