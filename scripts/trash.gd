class_name Trash

extends Node2D

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
	for i in range(Types.size()):
		if randf_range(0.0, 1.0) <= percentages[i]:
			type = i
	sprite.play(str(Types.find_key(type)))
	var new_collision : Area2D = collision_scenes[type].instantiate()
	new_collision.area_entered.connect(_on_area_area_entered)
	add_child(new_collision)
	



func _on_area_area_entered(area: Area2D) -> void:
	if timer.time_left > area.get_parent().timer.time_left: #only queuefrees the newest one
		queue_free()
	else:
		area.get_parent().queue_free()
