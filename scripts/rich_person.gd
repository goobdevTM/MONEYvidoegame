class_name HigherClass

extends CharacterBody2D

var speed : int
var friction : float = 0.7
var direction : Vector2
var hired : bool = false
var hovering : bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var piano_slam: AudioStreamPlayer = $PianoSlam
@onready var name_text: RichTextLabel = $Name

func generate_name() -> String:
	#FINDS LEN OF RICH PEOPLE NAMES
	var name: String = ""
	var name_index: int = 0
	name_index = len(Globals.rich_people_names) - 1
	
	name = Globals.rich_people_names[randi_range(0, name_index)] + " "
	name = name + Globals.rich_people_names[randi_range(0, name_index)] + " "
	
	name_index = len(Globals.roman_numerals) - 1
	name = name + Globals.roman_numerals[randi_range(0, name_index)]
	
	return name

func _ready() -> void:
	
	hovering = false
	
	#NAME
	name_text.text = generate_name()
	
	#MOVEMENT
	speed = randi_range(200, 300)
	direction = Vector2(randi_range(-1,1), randi_range(-1,1))

func _physics_process(delta: float) -> void:

	#luxorious movement
	if randi_range(0,50) == 0:
		direction.y = randi_range(-1,1)
	if randi_range(0,50) == 0:
		direction.x = randi_range(-1,1)
	if direction == Vector2(0,0):
			direction = Vector2(randi_range(-1,1), randi_range(-1,1))
	velocity += direction.normalized() * speed * delta
	velocity *= friction
	
	#rich animation
	if direction.x > 0:
		direction.x = 1
	elif direction.x < 0:
		direction.x = -1
	if abs(direction.x) == 1:
		sprite.scale.x = -direction.x
	
	move_and_slide()

func _on_rich_person_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("rich_people"):
		position = Vector2(randi_range(-(get_parent().x_limit), get_parent().x_limit), randi_range(-(get_parent().y_limit), get_parent().y_limit))

func spoken_to():
	pass
	
