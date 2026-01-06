class_name Player

extends CharacterBody2D

@onready var text_anim: AnimationPlayer = $HandArea/Text/Anim
@onready var text: RichTextLabel = $HandArea/Text/Text

@onready var eyes: AnimatedSprite2D = $Model/Eyes
@onready var hands: Node2D = $Model/Hands
@onready var right_hand: Sprite2D = $Model/Hands/RightHand
@onready var left_hand: Sprite2D = $Model/Hands/LeftHand
@onready var hand_area: Area2D = $HandArea

#movement variables
var speed : int = 0
var friction : float = 0.7
var direction : Vector2

#hand variables
var last_positions : Array[Vector2] = []
var hand_speed : float = 30
var hand_range : int = 32
var items_in_hand : Array[Node2D] = []

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("sprint"):
		speed = 1600 #1600
	else:
		speed = 800 #800
		
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
		if hands.position.distance_to(get_local_mouse_position()) < hand_range:
			right_hand.position = lerp(right_hand.position, get_local_mouse_position(), delta * hand_speed)
		else:
			right_hand.position = lerp(right_hand.position, get_local_mouse_position().normalized() * hand_range, delta * hand_speed)
		left_hand_go_back(delta)
	else:
		if hands.position.distance_to(get_local_mouse_position()) < hand_range:
			left_hand.position = lerp(left_hand.position, get_local_mouse_position(), delta * hand_speed)
		else:
			left_hand.position = lerp(left_hand.position, get_local_mouse_position().normalized() * hand_range, delta * hand_speed)
		right_hand_go_back(delta)
		
	if hands.position.distance_to(get_local_mouse_position()) < hand_range:
		hand_area.position = get_local_mouse_position()
	else:
		hand_area.position = get_local_mouse_position().normalized() * hand_range
		
	#pick up item
	if Input.is_action_just_pressed("pickup"):
		if items_in_hand[0].is_in_group("litter"): #is litter
			add_item_to_inventory(items_in_hand[0].type)
		else: #is trash
			for i in range(items_in_hand[0].amount_of_trash[items_in_hand[0].type]):
				add_item_to_inventory(Globals.get_item_with_chance())
				
func add_item_to_inventory(item : int) -> void:
	pass
		
func right_hand_go_back(delta : float) -> void:
	right_hand.position = lerp(right_hand.position, Vector2(12,0), delta * hand_speed)
	
func left_hand_go_back(delta : float) -> void:
	left_hand.position = lerp(left_hand.position, Vector2(-12,0), delta * hand_speed)


func _on_hand_area_area_entered(area: Area2D) -> void:
	items_in_hand.append(area.get_parent())
	highlight_item()

func _on_hand_area_area_exited(area: Area2D) -> void:
	items_in_hand.erase(area.get_parent())
	highlight_item()
	
func highlight_item() -> void:
	if len(items_in_hand) > 0:
		if items_in_hand[0].is_in_group("trash"):
			text.text = "[center][E] - open"
		else:
			text.text = "[center][E] - pick up"
		text_anim.play("appear")
	else:
		text_anim.play("disappear")
