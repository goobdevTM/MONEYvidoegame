class_name Level

extends Node2D



const TRASH = preload("uid://blwgbgbei4tsn")

@onready var trash_spawner: Node2D = $TrashSpawner
@onready var top: CollisionShape2D = $Borders/Top
@onready var bottom: CollisionShape2D = $Borders/Bottom
var thread : Thread = Thread.new()
var thread_spawn_x : int
	
func _ready() -> void:
	generate_trash(0)

#SETS UP THREAD TO GENERATE
func generate_trash(spawn_x: int) -> void:
	thread_spawn_x = spawn_x
	await get_tree().create_timer(0).timeout
	if thread.is_started():
		thread.wait_to_finish()
	thread = Thread.new()
	thread.start(generate_trash_thread)
	
#SPAWNS TRASH
func generate_trash_thread() -> void:
	await get_tree().create_timer(0).timeout
	#generate a piece of trash trash_amount times
	for i in range(Globals.trash_amount):
		var new_trash : Node2D = TRASH.instantiate()
		trash_spawner.call_deferred("add_child", new_trash)
		call_deferred("move", new_trash, Vector2(randi_range(thread_spawn_x, thread_spawn_x + 256), randi_range(top.position.y + 24, bottom.position.y - 24)))

func move(object : Node2D, new_pos : Vector2) -> void:
	object.position = new_pos
	
func _exit_tree() -> void:
	thread.wait_to_finish()
