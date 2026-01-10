class_name Trash

extends Node2D

const RAT = preload("uid://cuwxqyo26k0jd")
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
@onready var sprite_open: AnimatedSprite2D = $SpriteOpen
@onready var sprite_empty: AnimatedSprite2D = $SpriteEmpty
@onready var timer: Timer = $Timer
@onready var litter_spawner: Node2D = $"../../LitterSpawner"
@onready var rat_spawner: Node2D = $"../../RatSpawner"
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var smell_particles_1: GPUParticles2D = $SmellParticles1
@onready var smell_particles_2: GPUParticles2D = $SmellParticles2

var type : int = 0
var old : bool = false

var amounts_of_trash : Array[int] = [
	3,
	5,
	7,
	10
]

var percentages : Array[float] = [
	1,
	0.25,
	0.1,
	0.05
]

var open : bool = false
var empty : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(Types.size()):
		if randf_range(0.0, 1.0) <= percentages[i]:
			type = i
			
	open = (randi_range(0,10) == 0)
	
	#ANIMATION
	sprite.visible = not open
	sprite.play(str(Types.find_key(type)))
	sprite_open.visible = open
	sprite_open.play(str(Types.find_key(type)))
	sprite_empty.visible = false
	sprite_empty.play(str(Types.find_key(type)))
	
	#fix trashcan offset
	if type == Types.TRASH_CAN:
		sprite_open.position.y -= 10
		sprite_empty.position.x += 4
	
	#COLLISION (AREA)
	var new_collision : Area2D = collision_scenes[type].instantiate()
	new_collision.area_entered.connect(_on_area_area_entered)
	add_child(new_collision)
	
	#COLLISION (STATICBODY)
	for i in range(Types.size()):
		if not i == type:
			static_body.get_child(i).queue_free()
	
	#SPAWNS LITTER
	await get_tree().create_timer(randf_range(0,0.05)).timeout
	for i in randi_range(3, 5):
		var clone_litter = LITTER.instantiate()
		litter_spawner.add_child(clone_litter)
		clone_litter.global_position = global_position + Vector2(randi_range(-40, 40), randi_range(-40, 40))
		await get_tree().create_timer(randf_range(0,0.05)).timeout


	#show particles and increase trash amount
	if not randi_range(1, 3) == 3:
		smell_particles_1.emitting = false
		smell_particles_2.emitting = false
		smell_particles_1.hide()
		smell_particles_2.hide()
	else:
		smell_particles_1.emitting = true
		smell_particles_2.emitting = true
		smell_particles_1.show()
		smell_particles_2.show()
		amounts_of_trash[type] = int(amounts_of_trash[type] * 1.5)

func _on_area_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("trash"):
		if timer.time_left > area.get_parent().timer.time_left: #only queuefrees the newest one
			queue_free()
		else:
			area.get_parent().queue_free()


#too far away from player?
func _on_delete_check_area_entered(area: Area2D) -> void:
	queue_free()
	
#spawn rat if in correct conditions
func spawn_rat_randomly() -> void:
	if not open and not empty:
		var local_rarity : int = Globals.rat_rarity #night multiplier
		if Globals.time > Globals.day_length / 2: #is night?
			local_rarity /= 2 #less rare
		if randi_range(1, local_rarity) == local_rarity:
			var new_rat = RAT.instantiate()
			rat_spawner.add_child(new_rat)
			new_rat.global_position = global_position
