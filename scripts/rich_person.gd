class_name HigherClass

extends CharacterBody2D

var speed : int
var friction : float = 0.7
var direction : Vector2
var hired : bool = false
var hovering : bool = false
var my_name: String = ""
var difficulty: int = 0
var skedaddling : bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var piano_slam: AudioStreamPlayer = $PianoSlam
@onready var name_text: RichTextLabel = $Name
@onready var rich_person_collision: AudioStreamPlayer = $RichPersonCollision
@onready var player_collision: AudioStreamPlayer = $PlayerCollision
@onready var poor_particles: GPUParticles2D = $PoorParticles
@onready var poor_sound: AudioStreamPlayer = $PoorSound
@onready var fade: Fade = $"../../../Fade"
@onready var body: CollisionShape2D = $Body
@onready var hat: CollisionShape2D = $Hat
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var timer: Timer = $Timer


func generate_my_name() -> String:
	#FINDS LEN OF RICH PEOPLE NAMES
	
	var my_name_index: int = 0
	my_name_index = len(Globals.rich_people_names) - 1
	
	my_name = Globals.rich_people_names[randi_range(0, my_name_index)] + " "
	my_name = my_name + Globals.rich_people_names[randi_range(0, my_name_index)] + " "
	
	my_name_index = len(Globals.roman_numerals) - 1
	my_name = my_name + Globals.roman_numerals[randi_range(0, my_name_index)]
	
	return my_name

func _ready() -> void:
	
	
	
	body.disabled = false
	hat.disabled = false
	
	difficulty = randi_range(0,2)
	hovering = false
	
	#NAME
	name_text.text = generate_my_name()
	match difficulty:
		0:
			name_text.modulate = Color.GREEN
		1:
			name_text.modulate = Color.YELLOW
		2:
			name_text.modulate = Color.RED
	
	#MOVEMENT
	speed = randi_range(200, 300)
	direction = Vector2(randi_range(-1,1), randi_range(-1,1))
	
	await get_tree().create_timer(0.1).timeout
	if not Globals.has_rich_people:
		queue_free()

func _physics_process(delta: float) -> void:
	
	if not Globals.has_rich_people and timer.time_left < 0.8:
		skedaddle(delta)
		return
	else:
		body.disabled = false
		hat.disabled = false
	#luxorious movement
	if randi_range(0,50) == 0:
		direction.y = randi_range(-1,1)
	if randi_range(0,50) == 0:
		direction.x = randi_range(-1,1)
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
	if area.get_parent() is HigherClass:
		rich_person_collision.play()
	if area.get_parent() is Player:
		player_collision.play()
	
func spoken_to():
	var can_sell_to : bool = false
	for i in Globals.inventory:
		if i.count > 0:
			can_sell_to = true
	if can_sell_to:
		Globals.rich_difficulty = difficulty
		Globals.rich_person_name = my_name
		fade.fade_out(load("res://scenes/rich_person_minigame.tscn"))
	else:
		poor_particles.emitting = true
		poor_particles.restart()
		poor_sound.play()
		piano_slam.play()

func skedaddle(delta: float):
	body.disabled = true
	hat.disabled = true
		
	while direction == Vector2(0,0):
		direction = Vector2(randi_range(-1,1), randi_range(-1,1))
	
	if direction.x > 0:
		direction.x = 1
	elif direction.x < 0:
		direction.x = -1
	if abs(direction.x) == 1:
		sprite.scale.x = -direction.x
	
	velocity += direction.normalized() * speed * delta * 6
	velocity *= friction
	
	if not visible_on_screen_notifier_2d.is_on_screen():
		queue_free()
	
	move_and_slide()
