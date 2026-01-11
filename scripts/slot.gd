extends Control

@export var storage : bool = false
@export var from_storage_menu : bool = false

@onready var amount: RichTextLabel = $Amount
@onready var item_sprite: Sprite2D = $Item
@onready var anim: AnimationPlayer = $Anim
@onready var name_text: RichTextLabel = $ToolTip/Name
@onready var number: RichTextLabel = $Number
@onready var hover_item: Sprite2D = $"../../../HoverItem"
@onready var slot_bg: AnimatedSprite2D = $SlotBG
@onready var tool_tip: Node2D = $ToolTip

var selected: bool = false
var index: int
var item : Dictionary
var last_slot : int = 0
var last_count : int = 0
var last_item : int = 0
var appeared : bool = false
var local_inventory : Array[Dictionary] = []
var local_slot : int = 0
var mouse_over : bool = false

func _ready() -> void:
	
	#make unique
	item_sprite.texture = item_sprite.texture.duplicate()
	
	#hide number if storage
	if storage:
		number.hide()
		
	#connect update slot function
	Globals.slot_selected.connect(update_slot)
	update_slot()
	await get_tree().create_timer(0).timeout


func update_slot() -> void:
	if storage:
		local_inventory = Globals.storage
		local_slot = Globals.selected_slot - 9
	else:
		local_inventory = Globals.inventory
		local_slot = Globals.selected_slot
	#set visuals if slot has change
	if not local_slot == last_slot:
		selected = local_slot == index
		if selected:
			anim.stop()
			anim.play("hover")
			slot_bg.self_modulate = Color(0.49, 0.49, 0.49, 1.0)
		else:
			if last_slot == index:
				anim.stop()
				anim.play("unhover")
			slot_bg.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

	#set item data
	item = Globals.items[local_inventory[index]['id']]
	item_sprite.texture.region = Rect2(item['coords'] * 8, Vector2(8,8))
	amount.text = "[right]x" + str(local_inventory[index]['count'])
	


	if local_inventory[index]['count'] > 0:
		#no offscreen
		tool_tip.global_position.x = clamp(tool_tip.global_position.x, -300 + (len(item['name']) * 10), 300 - (len(item['name']) * 10))
		name_text.text = "[center]" + item['name']
		if ((not local_slot == last_slot) or (local_inventory[index]['count'] > last_count)) and local_slot == index:
			var tween: Tween = create_tween()
			tool_tip.show()
			tween.set_parallel()
			tween.tween_property(tool_tip, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
			tween.tween_property(tool_tip, "scale", Vector2(1, 1), 0.1)
	
	if local_inventory[index]['count'] <= 0 or not local_slot == index:
		var tween: Tween = create_tween()
		tween.set_parallel()
		tween.tween_property(tool_tip, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.1)
		tween.tween_property(tool_tip, "scale", Vector2(0, 0), 0.1)
		
	if local_inventory[index]['count'] <= 0:
		item_sprite.hide()
		amount.hide()
	else:
		item_sprite.show()
		amount.show()
	
	#set last slot and last count
	last_slot = local_slot
	last_count = local_inventory[index]['count']
	last_item = local_inventory[index]['id']


func _on_button_pressed() -> void:
	var can_add : bool = false
	if Globals.in_storage: #no click if not in storage
		if storage:
			Globals.selected_slot = index + 9
			local_inventory = Globals.storage
			local_slot = Globals.selected_slot - 9
		else:
			Globals.selected_slot = index
			local_inventory = Globals.inventory
			local_slot = Globals.selected_slot
			
				
		if Globals.clicked_item['count'] <= 0 or (Globals.clicked_item['id'] == local_inventory[index]['id']):
			can_add = true
			
		if Globals. last_given_slot:
			Globals.last_given_slot = false
			can_add = false
		
		if can_add: #take item
			if local_inventory[local_slot]['count'] > 0:
				Globals.clicked_item = {'id': local_inventory[index]['id'], 'count': Globals.clicked_item['count'] + 1, 'slot': index, 'storage': storage}
				hover_item.texture = item_sprite.texture
				if storage:
					Globals.storage[index]['count'] -= 1
				else:
					Globals.inventory[index]['count'] -= 1
			
		Globals.emit_signal("slot_selected")

func give_item() -> void:
	if (local_inventory[index]['id'] == Globals.clicked_item['id'] and local_inventory[index]['count'] < Globals.max_per_slot) or (local_inventory[index]['count'] == 0):
		if Globals.clicked_item['count'] > 0:
			if storage:
				Globals.storage[index] = {'id': Globals.clicked_item['id'], 'count': Globals.storage[index]['count'] + 1}
			else:
				Globals.inventory[index] = {'id': Globals.clicked_item['id'], 'count': Globals.inventory[index]['count'] + 1}
			Globals.clicked_item['count'] -= 1

func _on_button_mouse_entered() -> void:
	mouse_over = true

func _on_button_mouse_exited() -> void:
	mouse_over = false
	
func _input(event: InputEvent) -> void:
	if Globals.in_storage:
		if mouse_over:
			if storage:
				local_inventory = Globals.storage
			else:
				local_inventory = Globals.inventory
			if Input.is_action_just_released("right_click") or (Input.is_action_just_pressed("click") and ((local_inventory[index]['count'] <= 0 or local_inventory[index]['id'] == Globals.clicked_item['id']) and not (Globals.clicked_item['slot'] == index and Globals.clicked_item['storage'] == storage))):
				if storage:
					Globals.selected_slot = index + 9
					local_slot = Globals.selected_slot - 9
				else:
					Globals.selected_slot = index
					local_slot = Globals.selected_slot
				var can_give : bool = false
				if ((not Globals.clicked_item['count'] <= 0) or (Globals.clicked_item['id'] == local_inventory[index]['id'])) and local_inventory[index]['count'] < Globals.max_per_slot:
					can_give = true
				if can_give:
					if Input.is_action_just_pressed("click"): #left click, give all item possible
						if Globals.clicked_item['count'] > 0:
							Globals.last_given_slot = true
							for i in range(Globals.clicked_item['count']):
								give_item()
							Globals.clicked_item = {'id': 0, 'count': 0, 'slot': 0, 'storage': false}
					else: #right click, give one item
						give_item()
					Globals.emit_signal("slot_selected")
