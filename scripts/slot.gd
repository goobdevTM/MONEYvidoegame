extends Control

@onready var slot_bg: Sprite2D = $SlotBG
@onready var item_sprite: Sprite2D = $Item
@onready var anim: AnimationPlayer = $Anim

var selected: bool = false
var index: int
var item : Dictionary
var last_slot : int = 0


func _ready() -> void:
	#make unique
	item_sprite.texture = item_sprite.texture.duplicate()
	
	#connect update slot function
	Globals.slot_selected.connect(update_slot)
	update_slot()
	


func update_slot() -> void:
	
	#set visuals if slot has changed
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
	
	#set last slot
	last_slot = Globals.selected_slot
