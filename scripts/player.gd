class_name Player

extends CharacterBody2D


@onready var text_anim: AnimationPlayer = $HandArea/Text/Anim
@onready var text: RichTextLabel = $HandArea/Text/Text
@onready var camera: Camera2D = $"../../../Camera"

@onready var eyes: AnimatedSprite2D = $Model/Eyes
#HANDS
@onready var hands: Node2D = $Model/Hands
@onready var right_hand: Sprite2D = $Model/Hands/RightHand
@onready var left_hand: Sprite2D = $Model/Hands/LeftHand
@onready var hand_area: Area2D = $HandArea
#UI
@onready var stamina_bar: HSlider = $"../../../INVENTORY/Control/Stamina"
@onready var storage_gui: CanvasLayer = $"../../../StorageGUI"
@onready var upgrade_menu: CanvasLayer = $"../../../UpgradeMenu"

#SOUND
@onready var open_container: AudioStreamPlayer = $OpenContainer
@onready var open_litter: AudioStreamPlayer = $OpenLitter

@onready var litter_spawner: Node2D = $"../../LitterSpawner"
@onready var music_controller: Node = $"../../../MusicController"

#litter scene
const LITTER = preload("uid://6nia0edfdeaj")

#movement variables
var speed : int = 0
var friction : float = 0.7
var direction : Vector2
#	FOR SPRINTING
var stamina: float = 100
var stamina_timer: float = 0
#		SHOULDNT BE CHANGED (FOR NOW)... wait a minute... i feel somethimg..
#	 	the MONEY!! the MONEY has arrvied YIPPESKIPY
var max_stamina: float = 100
var sprint_base_speed: int = 800

signal stop_rat_theme
signal talk_to_rich_person
signal talk_to_garby

#hand variables
var last_positions : Array[Vector2] = []
var hand_speed : float = 30
var hand_range : int = 32
var items_in_hand : Array[Node2D] = []

func _ready() -> void:
	stamina = 100
	stamina_bar.value = stamina
	stamina_bar.self_modulate = Color(1.0, 1.0, 1.0, 0.05)
	
	#set position according to where coming from
	global_position = Globals.start_pos

func sprint(sprint_speed: int) -> void:
	if stamina > 0:
		speed = sprint_speed #1600
		stamina -= 0.18
		stamina_bar.value = stamina
	else:
		#OUT OF ENERGY
		return

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("sprint"):
		sprint(sprint_base_speed + (stamina * 10)) #800 is default
		
		#ANIMATES STAMINA BAR
		var tween: Tween = create_tween()
		tween.tween_property(stamina_bar, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
		
	else:
		speed = 800 #800
		var tween: Tween = create_tween()
		tween.tween_property(stamina_bar, "self_modulate", Color(1.0, 1.0, 1.0, Globals.stamina_bar_opacity), 0.2)
		
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

	if direction:
		Globals.sleeping = false #wake up if moving

	move_and_slide()
	
func _process(delta: float) -> void:
	
	#ADDS STAMINA EVERY ONE SECOND
	if stamina < 0:
		stamina = 0
	if not Input.is_action_pressed("sprint"):
		stamina_timer += delta
	if stamina_timer >= (1 - (stamina / 100)):
		if stamina < 100:
			stamina += 5
			stamina_timer = 0
			stamina_bar.value = stamina
	if stamina > 100:
		stamina = 100
	
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
		if len(items_in_hand) > 0:
			if items_in_hand[0] is Trash: #is in trash class
				#spawn rat if not already opened
				items_in_hand[0].spawn_rat_randomly()
				for i in range(items_in_hand[0].amounts_of_trash[items_in_hand[0].type]):
					#SOUND
					open_container.play()
					
					#double check to prevent crash
					if len(items_in_hand) > 0 and items_in_hand[0] is Trash:
						#SETS TRASH TO EMPTY SPRITE
						items_in_hand[0].sprite.hide()
						items_in_hand[0].sprite_open.hide()
						items_in_hand[0].sprite_empty.show()
						items_in_hand[0].empty = true
						items_in_hand.remove_at(0)
					highlight_item()
					
					#ADDS TO INVENTORY
					add_item_to_inventory(Globals.get_item_with_chance(), false)
					
			elif items_in_hand[0] is Litter: #is litter
				if items_in_hand[0].rat_spawned:
					items_in_hand[0].emit_signal("picked_up")
				open_litter.play()
				add_item_to_inventory(items_in_hand[0].type)
				
			elif items_in_hand[0] is Rat: #is rat
				if items_in_hand[0].hired:
					#send rat to work
					items_in_hand[0].go_to_work()
					
				else:
					#mark rat as hired
					Globals.working_rats += 1
					items_in_hand[0].hired = true
					stop_rat_theme.connect(music_controller.stop_rat_theme)
					emit_signal("stop_rat_theme")
					stop_rat_theme.disconnect(music_controller.stop_rat_theme)
				#show text
				highlight_item()
			elif items_in_hand[0].is_in_group("storage_dumpster"):
				storage_gui.open()
			elif items_in_hand[0].is_in_group("bed"):
				var tween: Tween = create_tween()
				tween.tween_property(self, "global_position", items_in_hand[0].global_position, 0.1).set_trans(Tween.TRANS_SINE)
				tween.tween_property(camera, "global_position", items_in_hand[0].global_position, 0.15).set_trans(Tween.TRANS_SINE)
				Globals.sleeping = true
			elif items_in_hand[0] is HigherClass:
				emit_signal("talk_to_rich_person")
				if len(items_in_hand) > 0: #stop crash
					talk_to_rich_person.disconnect(items_in_hand[0].spoken_to)
			elif items_in_hand[0].is_in_group("computer"):
				upgrade_menu.open()
			elif items_in_hand[0].is_in_group("garby"):
				talk_to_garby.connect(items_in_hand[0].spoken_to)
				emit_signal("talk_to_garby")
	#drop item
	if Input.is_action_just_pressed("drop"):
		if Globals.inventory[Globals.selected_slot]['count'] > 0:
			drop_item(Globals.selected_slot, 1)

				
#add item with inventory or swap
func add_item_to_inventory(item : int, drop_items_at_hand : bool = true) -> void:
	
	#delete hovered item
	if len(items_in_hand) > 0:
		if items_in_hand[0] is Trash:
			items_in_hand[0].amounts_of_trash[items_in_hand[0].type] = 0
		else:
			items_in_hand[0].queue_free()
			items_in_hand.remove_at(0)
			
	var slot : int = -1
	#check for open slot
	for i in range(Globals.inventory_slots):
		if Globals.inventory[i]['id'] == item and Globals.inventory[i]['count'] < Globals.max_per_slot:
			slot = i
			break
		if Globals.inventory[i]['count'] == 0:
			slot = i
			break
			
	#if selected is open, use selected slot
	if (Globals.inventory[Globals.selected_slot]['count'] <= 0 or (Globals.inventory[Globals.selected_slot]['id'] == item and Globals.inventory[Globals.selected_slot]['count'] < Globals.max_per_slot)):
		slot = Globals.selected_slot
	#no open slot, drop item that is trying to be picked up
	if Globals.inventory[slot]['count'] >= Globals.max_per_slot or slot == -1:
		var new_litter : Litter = LITTER.instantiate()
		new_litter.type = item
		litter_spawner.add_child(new_litter)
		var drop_pos : Vector2 = hand_area.global_position + Vector2(randi_range(-1, 1), randi_range(-1, 1))
		if not drop_items_at_hand:
			drop_pos = global_position + Vector2(randi_range(-8, 8), randi_range(-8, 8))
		new_litter.global_position = drop_pos
		return
	#update array
	Globals.inventory[slot]['id'] = item
	Globals.inventory[slot]['count'] += 1
	#limit item amount
	if Globals.inventory[slot]['count'] > Globals.max_per_slot:
		drop_item(slot, Globals.inventory[slot]['count'] - Globals.max_per_slot, drop_items_at_hand)
	#update hover text
	highlight_item()
	#update slots
	#Globals.emit_signal("slot_selected")
	
func drop_item(slot : int, count : int, at_hand : bool = true, update_signal : bool = true) -> void:
	#add litter to ground count times
	for i in range(count):
		var new_litter : Litter = LITTER.instantiate()
		new_litter.type = Globals.inventory[slot]['id']
		litter_spawner.add_child(new_litter)
		var drop_pos : Vector2 = hand_area.global_position + Vector2(randi_range(-1, 1), randi_range(-1, 1))
		if not at_hand:
			drop_pos = global_position + Vector2(randi_range(-8, 8), randi_range(-8, 8))
		new_litter.global_position = drop_pos
		Globals.inventory[slot]['count'] -= 1
	#clear slot if empty
	if Globals.inventory[slot]['count'] <= 0:
		Globals.inventory[slot] = {'id': 0, 'count': 0}
		
	if update_signal:
		#update slots
		Globals.emit_signal("slot_selected")
	
func right_hand_go_back(delta : float) -> void:
	right_hand.position = lerp(right_hand.position, Vector2(12,0), delta * hand_speed)
	
func left_hand_go_back(delta : float) -> void:
	left_hand.position = lerp(left_hand.position, Vector2(-12,0), delta * hand_speed)


func _on_hand_area_area_entered(area: Area2D) -> void:
	#check if area is for hand to collide with
	if area.is_in_group("for_hand") and not is_trash_empty(area.get_parent()):
		items_in_hand.append(area.get_parent())
		#only highlight if first item in list
		if len(items_in_hand) == 1:
			highlight_item()



func _on_hand_area_area_exited(area: Area2D) -> void:
	#check if area is for hand to collide with and items in hand has item
	if area.is_in_group("for_hand") and len(items_in_hand) > 0 and not is_trash_empty(area.get_parent()):
		#check not queue_freed
		if items_in_hand[0]:
			#only highlight if first item in list
			if items_in_hand[0] is HigherClass: #disconnect if left area
				if len(items_in_hand) > 0: #stop crash
					talk_to_rich_person.disconnect(items_in_hand[0].spoken_to)
			if items_in_hand[0] == area.get_parent():
				items_in_hand.erase(area.get_parent())
				highlight_item()
				return
			
			items_in_hand.erase(area.get_parent())
	
func highlight_item() -> void:
	if len(items_in_hand) > 0:
		if items_in_hand[0] is Trash:
			text.text = "[center][E] - open"
		elif items_in_hand[0] is Litter:
			text.text = "[center][E] - pick up"
		elif items_in_hand[0] is Rat:
			if items_in_hand[0].hired:
				text.text = "[center][E] - send to work"
			else:
				text.text = "[center][E] - recruit"
		elif items_in_hand[0].is_in_group("storage_dumpster"):
			text.text = "[center][E] - open storage"
		elif items_in_hand[0].is_in_group("bed"):
			text.text = "[center][E] - sleep?"
			#SIGNALS
			talk_to_rich_person.connect(items_in_hand[0].spoken_to)
		elif items_in_hand[0].is_in_group("computer"):
			text.text = "[center][E] - go on computer?"
		elif items_in_hand[0].is_in_group("npc"):
			"[center][E] - talk to?"

		
		#dont show empty trash
		if len(items_in_hand) > 0: #stop crash
			if not is_trash_empty(items_in_hand[0]):
				text_anim.play("appear")
	else:
		text_anim.play("disappear")

#check if trash/litter is empty and return true or false
func is_trash_empty(trash : Node2D) -> bool:
	if trash:
		if trash.is_in_group("trash"):
			return trash.empty
		else:
			return false
	return false
