class_name Rat

extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Player = $"../../TrashSpawner/Player"
@onready var music_controller: Node = $"../../../MusicController"
@onready var litter_spawner: Node2D = $Level/LitterSpawner
@onready var hand_area: Area2D = $HandArea
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

const LITTER = preload("uid://6nia0edfdeaj")

#RATS ARE FAST SO YOU HAVE TO SPRINT TO CATCH THEM
var speed : int = 1200
var friction : float = 0.7
var direction : Vector2
var hired : bool = false
var currently_working : bool = false
var on_screen : bool

signal play_theme

func _ready() -> void:
	
	on_screen = true
	
	direction = Vector2(randi_range(-1,1), randi_range(-1,1))

	#CONNECTS
	if not hired:
		play_theme.connect(music_controller.play_rat_theme)
		emit_signal("play_theme")
		

func _physics_process(delta: float) -> void:

	#basic movement
	if hired:
		#NOT WORKING
		if not currently_working:
			direction = player.global_position - global_position
			if global_position.distance_to(player.global_position) < 20:
				direction = Vector2(0, 0)
		#WORKING
			
	else:
		if randi_range(0,50) == 0:
			direction.y = randi_range(-1,1)
		if randi_range(0,50) == 0:
			direction.x = randi_range(-1,1)
		while direction == Vector2(0,0):
			direction = Vector2(randi_range(-1,1), randi_range(-1,1))
		if not on_screen: #don run away to far.
			direction = Vector2(0,0)
	velocity += direction.normalized() * speed * delta
	velocity *= friction
	
	#animation
	if direction.x > 0:
		direction.x = 1
	elif direction.x < 0:
		direction.x = -1
	if abs(direction.x) == 1:
		sprite.scale.x = -direction.x
	
	move_and_slide()

func go_to_work():
	
	hand_area.get_child(0).disabled = true
	currently_working = true
	
	speed = 1400

	
	
	while direction == Vector2(0,0):
		direction = Vector2(randi_range(-1,1), randi_range(-1,1))
	
	
	await visible_on_screen_notifier_2d.screen_exited
	sprite.hide()
	
	await get_tree().create_timer(1).timeout
	
	sprite.show()
	currently_working = false
	var clone_litter: Litter = LITTER.instantiate()
	clone_litter.rat_spawned = true
	add_child(clone_litter)
	move_child(clone_litter, 0)
	
	
	await clone_litter.picked_up
	hand_area.get_child(0).disabled = false


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
