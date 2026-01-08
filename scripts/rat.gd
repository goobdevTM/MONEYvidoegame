class_name Rat

extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Player = $"../../TrashSpawner/Player"


var speed : int = 200
var friction : float = 0.7
var direction : Vector2
var hired : bool = false

func _ready() -> void:
	direction = Vector2(randi_range(-1,1), randi_range(-1,1))

func _physics_process(delta: float) -> void:

	#basic movement
	if hired:
		direction = player.global_position - global_position
	else:
		if randi_range(0,50) == 0:
			direction.y = randi_range(-1,1)
		if randi_range(0,50) == 0:
			direction.x = randi_range(-1,1)
		if direction == Vector2(0,0):
			direction = Vector2(randi_range(-1,1), randi_range(-1,1))
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
