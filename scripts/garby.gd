extends CharacterBody2D

var speed : int
var friction : float = 0.7
var direction : Vector2
var hired : bool = false
var hovering : bool = false
var current_dialogue: int = 0
var gave_tip : bool = false
var tween : Tween = create_tween()
var dialogue_shown : bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var piano_slam: AudioStreamPlayer = $PianoSlam
@onready var name_text: RichTextLabel = $Name
@onready var rich_person_collision: AudioStreamPlayer = $RichPersonCollision
@onready var player_collision: AudioStreamPlayer = $PlayerCollision
@onready var dialogue: CanvasLayer = $"../Dialogue"
@onready var buttons: Control = $"../Dialogue/Panel/Buttons"


func _ready() -> void:
	dialogue_shown = false
	tween = create_tween()
	tween.set_parallel()
	dialogue.hide()
	dialogue.get_child(0).scale = Vector2(0,0)
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
		
	if dialogue_shown:
		direction = Vector2(0,0)

	velocity += direction.normalized() * speed * delta
	velocity *= friction
	
	if Input.is_action_just_pressed("enter"):
		if dialogue_shown:
			spoken_to()
	
	move_and_slide()

func _on_rich_person_detector_area_entered(area: Area2D) -> void:
	if area.get_parent() is HigherClass:
		rich_person_collision.play()
	if area.get_parent() is Player:
		player_collision.play()
	
func spoken_to():
	show_dialogue()
	buttons.hide()
	if gave_tip:
		gave_tip = false
		if Globals.inventory[Globals.selected_slot]['count'] > 0:
			current_dialogue = 0
			dialogue.get_child(0).get_child(3).text = Globals.garby_dialogue["ask_for_litter"][randi_range(0,len(Globals.garby_dialogue["ask_for_litter"]) - 1)]
			buttons.show()
		else:
			hide_dialogue()
		return
	if Globals.first_interaction_with_garby:
		if current_dialogue < len(Globals.garby_dialogue["first_encounter"]):
			dialogue.get_child(0).get_child(3).text = Globals.garby_dialogue["first_encounter"][current_dialogue]
			current_dialogue += 1
		else:
			current_dialogue = 0
			Globals.first_interaction_with_garby = false
			hide_dialogue()
	else:
		if Globals.inventory[Globals.selected_slot]['count'] > 0:
			current_dialogue = 0
			dialogue.get_child(0).get_child(3).text = Globals.garby_dialogue["ask_for_litter"][randi_range(0,len(Globals.garby_dialogue["ask_for_litter"]) - 1)]
			buttons.show()
		else:
			if current_dialogue < len(Globals.garby_dialogue["bothered_dialogue"]):
				dialogue.get_child(0).get_child(3).text = Globals.garby_dialogue["bothered_dialogue"][current_dialogue]
				current_dialogue += 1
			else:
				current_dialogue = 0
				hide_dialogue()


func _on_give_pressed() -> void:
	buttons.hide()
	if Globals.inventory[Globals.selected_slot]['count'] > 0:
		dialogue.get_child(0).get_child(3).text = Globals.garby_dialogue["tips"][randi_range(0,len(Globals.garby_dialogue["tips"]) - 1)]
		Globals.inventory[Globals.selected_slot]['count'] -= 1
		Globals.emit_signal("slot_selected")
		gave_tip = true
	else:
		hide_dialogue()
		
func _on_no_pressed() -> void:
	buttons.hide()
	hide_dialogue()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		current_dialogue = 0
		hide_dialogue()
		
		
func show_dialogue() -> void:
	dialogue.show()
	dialogue_shown = true
	tween.stop()
	tween = create_tween()
	tween.tween_property(dialogue.get_child(0), "scale", Vector2(1,1), 0.05)
		
func hide_dialogue() -> void:
	dialogue_shown = false
	tween.stop()
	tween = create_tween()
	tween.tween_property(dialogue.get_child(0), "scale", Vector2(0,0), 0.05)
