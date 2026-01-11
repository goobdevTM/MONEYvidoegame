extends CharacterBody2D

var speed : int
var friction : float = 0.7
var direction : Vector2
var hired : bool = false
var hovering : bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var piano_slam: AudioStreamPlayer = $PianoSlam
@onready var name_text: RichTextLabel = $Name
@onready var rich_person_collision: AudioStreamPlayer = $RichPersonCollision
@onready var player_collision: AudioStreamPlayer = $PlayerCollision
@onready var dialogue: CanvasLayer = $"../Dialogue"


func _ready() -> void:
	
	hovering = false
		
	#MOVEMENT
	speed = 200
	direction = Vector2(randi_range(-1,1), randi_range(-1,1))

func _physics_process(delta: float) -> void:

	#luxorious movement
	if randi_range(0,150) == 0:
		direction.y = randi_range(-1,1)
	if randi_range(0,150) == 0:
		direction.x = randi_range(-1,1)

	velocity += direction.normalized() * speed * delta
	velocity *= friction
	
	move_and_slide()

func _on_rich_person_detector_area_entered(area: Area2D) -> void:
	if area.get_parent() is HigherClass:
		rich_person_collision.play()
	if area.get_parent() is Player:
		player_collision.play()
	
func spoken_to():
	dialogue.show()
	var current_dialogue: int = 0
	if Globals.first_interaction_with_garby:
		dialogue.get_child(0).get_child(3).text = Globals.garby_dialogue["first_interaction"][0]
		
