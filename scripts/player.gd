class_name Player

extends CharacterBody2D

@onready var anim: AnimationPlayer = $Anim
@onready var eyes: AnimatedSprite2D = $Model/Eyes
@onready var hands: Node2D = $Model/Hands
@onready var right_hand: Sprite2D = $Model/Hands/RightHand
@onready var left_hand: Sprite2D = $Model/Hands/LeftHand

#movement variables
var speed : int = 800 #1000
var friction : float = 0.7
var direction : Vector2
var last_positions : Array[Vector2] = []

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("sprint"):
		speed = 1600
	else:
		speed = 800
		
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
	
func _process(delta: float) -> void:
	#hand follow mouse (do in process so no laggy)
	
	#if mouse on right, else if left

	if get_local_mouse_position().x > 0:
		if hands.position.distance_to(get_local_mouse_position()) > 32:
			right_hand.position = lerp(right_hand.position, get_local_mouse_position(), delta * 8)
		else:
			right_hand.position = lerp(right_hand.position, get_local_mouse_position().normalized() * 32, delta * 8)
		left_hand_go_back(delta)
	else:
		left_hand.global_position = lerp(left_hand.global_position, get_global_mouse_position(), delta * 8)
		right_hand_go_back(delta)
		
func right_hand_go_back(delta : float) -> void:
	right_hand.position = lerp(right_hand.position, Vector2(12,0), delta * 8)
	
func left_hand_go_back(delta : float) -> void:
	left_hand.position = lerp(left_hand.position, Vector2(-12,0), delta * 8)
