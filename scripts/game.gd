class_name Game

extends Node2D

@export var game : bool = false

@onready var click_and_hover: Node = $ClickAndHover
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var rat_spawner: Node2D = $Level/RatSpawner
@onready var player: Player = $Level/TrashSpawner/Player
@onready var right_border: StaticBody2D = $Level/RightBorder
@onready var buy_text: RichTextLabel = $Level/RightBorder/BuyArea/BuyText
@onready var fade: Fade = $Fade
@onready var note: Node2D = $Note

@export var rich_plaza : bool = false


const RAT = preload("uid://cuwxqyo26k0jd")

var speed_up : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Globals.has_rich_people = false
	
	if game:
		set_area_upgrade_text()
	for i in range(Globals.working_rats):
		var new_rat = RAT.instantiate()
		new_rat.hired = true
		
		rat_spawner.add_child(new_rat)
		new_rat.global_position = player.global_position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
	
	Globals.set_ui_sounds(click_and_hover)
	Globals.in_game = true
	Globals.selected_slot += 1
	Globals.emit_signal("slot_selected")
	await get_tree().create_timer(0).timeout
	if Globals.selected_slot == -1:
		Globals.selected_slot = 0
	#fix bufg NO ROMOVE!!!
	Globals.selected_slot -= 1
	Globals.emit_signal("slot_selected")
	while is_inside_tree(): #AUTOSAVE
		await get_tree().create_timer(15).timeout
		Globals.set_saves(Globals.current_save)
		Globals.save_data()
		
func _process(delta: float) -> void:
	
	if (Globals.time < (Globals.day_length / 2) + ((Globals.day_length / 24) * 7) and Globals.time > (Globals.day_length / 2) - ((Globals.day_length / 24) * 5)): #is night?
		Globals.has_rich_people = true
	else:
		Globals.has_rich_people = false
	
	if rich_plaza:
		if not Globals.has_rich_people: #is night?
			note.show()
			note.get_child(0).get_child(1).disabled = false
		else:
			note.hide()
			note.get_child(0).get_child(1).disabled = true
		
	canvas_modulate.color = lerp(Color.WHITE, Color(0.245, 0.362, 0.514, 1.0), clampf(abs(Globals.time - (Globals.day_length / 1.85)) / (Globals.day_length / 8) - 1.65, 0, 1))
	if Globals.sleeping:
		Globals.time += delta * speed_up #speed time
		if speed_up < 2:
			speed_up = 2
		speed_up = lerp(speed_up, 48.0, delta * 4)
	else:
		speed_up = 1
		Globals.time += delta
	if Globals.time > Globals.day_length:
		Globals.emit_signal("next_day")
		Globals.day += 1
		Globals.time = 0
		
	if Input.is_action_pressed("give_money"):
		Globals.money += 5
		
	if game:
		if Globals.area < len(Globals.areas) - 1:
			if Globals.money >= Globals.areas[Globals.area + 1]['cost']:
				buy_text.modulate = Color.GREEN
			else:
				buy_text.modulate = Color.RED
		else:
			buy_text.modulate = Color.RED
		
	
		
func set_area_upgrade_text() -> void:
	if game:
		right_border.position.x = Globals.areas[Globals.area]['length']
		if Globals.area < len(Globals.areas) - 1:
			buy_text.text = "[right]" + Globals.areas[Globals.area + 1]['name'] + "

Buy for: $" + str(Globals.areas[Globals.area + 1]['cost'])
		else:
			buy_text.text = "Max Area Unlocked"
