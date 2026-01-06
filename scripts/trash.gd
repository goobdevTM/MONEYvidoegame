class_name Trash

extends Node2D

const LITTER = preload("uid://6nia0edfdeaj")
const collision_scenes : Array[PackedScene] = [
	preload("res://scenes/collision/small_trash_bag.tscn"),
	preload("res://scenes/collision/trash_bag.tscn"),
	preload("res://scenes/collision/trash_can.tscn"),
	preload("res://scenes/collision/dumpster.tscn")
]

enum Types {
	TRASH_BAG_SMALL,
	TRASH_BAG,
	TRASH_CAN,
	DUMPSTER
}

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var timer: Timer = $Timer
@onready var litter_spawner: Node2D = $"../../LitterSpawner"
@onready var static_body: StaticBody2D = $StaticBody2D

var type : int = 0
var old : bool = false
var percentages : Array[float] = [
	1,
	0.25,
	0.1,
	0.05
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#
	for i in range(Types.size()):
		if randf_range(0.0, 1.0) <= percentages[i]:
			type = i
	
	#ANIMATION
	sprite.play(str(Types.find_key(type)))
	
	#COLLISION (AREA)
	var new_collision : Area2D = collision_scenes[type].instantiate()
	new_collision.area_entered.connect(_on_area_area_entered)
	add_child(new_collision)
	
	#COLLISION (STATICBODY)
	for i in range(Types.size()):
		if not i == type:
			static_body.get_child(i).queue_free()
	
	#SPAWNS LITTER
	await get_tree().create_timer(0).timeout
	for i in randi_range(3, 5):
		var clone_litter = LITTER.instantiate()
		litter_spawner.add_child(clone_litter)
		clone_litter.global_position = global_position + Vector2(randi_range(-40, 40), randi_range(-40, 40))
	



func _on_area_area_entered(area: Area2D) -> void:
	if timer.time_left > area.get_parent().timer.time_left: #only queuefrees the newest one
		queue_free()
	else:
		area.get_parent().queue_free()
