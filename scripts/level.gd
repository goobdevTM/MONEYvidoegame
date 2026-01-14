class_name Level

extends Node2D



const TRASH = preload("res://scenes/trash.tscn")

@onready var trash_spawner: Node2D = $TrashSpawner
@onready var top: CollisionShape2D = $Borders/Top
@onready var bottom: CollisionShape2D = $Borders/Bottom
@onready var left_delete: CollisionShape2D = $DeleteTrash/LeftDelete
@onready var right_delete: CollisionShape2D = $DeleteTrash/RightDelete

var thread_spawn_x : int = -1

var thread : Thread = Thread.new()
	
func _ready() -> void:
	thread_generate_trash(-256)
	
#SETS UP THREAD TO GENERATE
func thread_generate_trash(spawn_x: int) -> void:
	
	if thread.is_started():
		thread.wait_to_finish()
		
	thread_spawn_x = spawn_x
	await get_tree().create_timer(0.01).timeout
	if thread.is_started():
		thread.wait_to_finish()
	right_delete.disabled = true
	left_delete.disabled = true
	thread.start(generate_trash)
	
func generate_trash() -> void:
	for i in range((Globals.areas[Globals.area]['trash_amount']) + Globals.get_upgrade_value(3)):
		var new_trash : Trash = TRASH.instantiate()
		trash_spawner.call_deferred("add_child", new_trash)
		call_deferred("move", new_trash, Vector2(randi_range(thread_spawn_x, thread_spawn_x + 256), randf_range(-225.0, 242.0)))
		print(new_trash)
	

func move(object : Trash, new_pos : Vector2) -> void:
	object.position = new_pos
	
func _exit_tree() -> void:
	thread.wait_to_finish()
