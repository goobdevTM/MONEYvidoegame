class_name Player

extends CharacterBody2D

@onready var anim: AnimationPlayer = $Anim
@onready var eyes: AnimatedSprite2D = $Model/Eyes
@onready var hands: Node2D = $Model/Hands

#movement variables
var speed : int = 1000 # 20
var friction : float = 0.7
var direction : Vector2
var last_positions : Array[Vector2] = []

func _physics_process(delta: float) -> void:
	#append to last positions
	last_positions.append(position)
	
	#clean last positions
	if len(last_positions) > 5:
		last_positions.remove_at(0)
		
	#basic movement
	direction = Input.get_vector("left", "right", "up", "down")
	velocity += direction.normalized() * speed * delta
	velocity *= friction
	
	#hand and eye animation (smooth)
	eyes.position = lerp(eyes.position, direction.normalized() * 1.5, delta * 10)
	hands.global_position = lerp(hands.global_position, last_positions[0], delta * 16)


	move_and_slide()
