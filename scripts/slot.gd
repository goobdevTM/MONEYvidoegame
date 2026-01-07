extends Control

@onready var amount: RichTextLabel = $Amount
@onready var slot_bg: Sprite2D = $SlotBG
@onready var item_sprite: Sprite2D = $Item
@onready var anim: AnimationPlayer = $Anim
@onready var tooltip_anim: AnimationPlayer = $Tooltip/TooltipAnim
@onready var tooltip: Node2D = $Tooltip
@onready var name_text: RichTextLabel = $Tooltip/Name

var selected: bool = false
var index: int
var item : Dictionary
var last_slot : int = 0
var last_count : int = 0
var last_item : int = 0
var appeared : bool = false


func _ready() -> void:
	#make unique
	item_sprite.texture = item_sprite.texture.duplicate()
	
	#connect update slot function
	Globals.slot_selected.connect(update_slot)
	update_slot()
	


func update_slot() -> void:
	
	#set visuals if slot has change
	if not Globals.selected_slot == last_slot:
		selected = Globals.selected_slot == index
		if selected:
			anim.play("hover")
			slot_bg.self_modulate = Color(0.49, 0.49, 0.49, 1.0)
		else:
			if last_slot == index:
				anim.play("unhover")
			slot_bg.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

	#set item data
	item = Globals.items[Globals.inventory[index]['id']]
	item_sprite.texture.region = Rect2(item['coords'] * 8, Vector2(8,8))
	amount.text = "[right]x" + str(Globals.inventory[index]['count'])
	if Globals.inventory[index]['count'] > 0:
		name_text.text = ""
		name_text.size.x = 1
		name_text.text = item['name']
		
	#tooltip shengangingans DONTOT TOUCH
	if Globals.selected_slot == index:
		for i : Control in get_parent().get_children():
			if not i == self:
				if Globals.inventory[i.index]['count'] > 0 and i.appeared:
					i.tooltip_anim.play("disappear")
					i.appeared = false
					
	if Globals.inventory[index]['count'] > 0 and Globals.selected_slot == index:
		if (not Globals.selected_slot == last_slot) or (not Globals.inventory[index]['id'] == last_item or (last_count <= 0 and Globals.inventory[index]['count'] > 0)):
			appeared = true
			tooltip_anim.stop()
			tooltip_anim.play("appear")
			await get_tree().create_timer(0).timeout
			name_text.position.x = -name_text.size.x / 2
		
	if (Globals.inventory[index]['count'] < last_count and Globals.inventory[index]['count'] <= 0) and last_count > 0:
		appeared = false
		tooltip_anim.stop()
		last_count = 0
		Globals.inventory[index]['count'] = 0
		tooltip_anim.play("disappear")


	
	if Globals.inventory[index]['count'] <= 0:
		item_sprite.hide()
		amount.hide()
	else:
		item_sprite.show()
		amount.show()
	
	#set last slot and last count
	last_slot = Globals.selected_slot
	last_count = Globals.inventory[index]['count']
	last_item = Globals.inventory[index]['id']
