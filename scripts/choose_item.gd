extends Control

const SLOT = preload("uid://ep7xcgg7p76x")

@onready var grid_container: GridContainer = $Control/GridContainer
@onready var bg: ColorRect = $BG
@onready var value: RichTextLabel = $Control/Panel/Value
@onready var hover_item: Sprite2D = $HoverItem
@onready var selling_sprite: Sprite2D = $"../Control/SellingSprite"
@onready var selling_name: RichTextLabel = $"../Control/SellingName"
@onready var cool: Button = $Control/Options/Cool
@onready var difficulty: RichTextLabel = $Control/Panel/Difficulty


func _ready() -> void:
	match Globals.rich_difficulty:
		0:
			difficulty.text = "[center]Difficulty: Easy"
			difficulty.modulate = Color.GREEN
		1:
			difficulty.text = "[center]Difficulty: Medium"
			difficulty.modulate = Color.YELLOW
		2:
			difficulty.text = "[center]Difficulty: Hard"
			difficulty.modulate = Color.RED
	get_tree().paused = true
	spawn_items()
	Globals.selected_slot = 1
	Globals.emit_signal("slot_selected")
	show()
	await get_tree().create_timer(0).timeout
	Globals.selected_slot = 0
	Globals.emit_signal("slot_selected")

func spawn_items() -> void:
	Globals.in_storage = true
	for i in range(Globals.inventory_slots):
		var clone_slot: Control = SLOT.instantiate()
		grid_container.add_child(clone_slot)
		clone_slot.from_storage_menu = true
		clone_slot.slot_bg.play("inventory")
		clone_slot.show()
		clone_slot.index = i
		
func close() -> void:
	Globals.item_selling = {'id': Globals.inventory[Globals.selected_slot]['id'], 'count': Globals.inventory[Globals.selected_slot]['count'], 'slot': Globals.selected_slot}
	selling_sprite.texture.region = Rect2(Globals.items[Globals.item_selling['id']]['coords'] * 8, Vector2(8,8))
	selling_name.text = "[center]" + Globals.items[Globals.item_selling['id']]['name']
	Globals.in_storage = false
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	tween.tween_property(selling_sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	tween.tween_property(selling_name, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	hide()
	get_tree().paused = false
	queue_free()
	
func _process(delta: float) -> void:
	var item : Dictionary = Globals.items[Globals.inventory[Globals.selected_slot]['id']]
	if Globals.clicked_item['count'] > 0:
		
		hover_item.show()
		hover_item.get_child(0).text = "[right]x" + str(Globals.clicked_item['count'])
		hover_item.position = get_viewport().get_mouse_position()
	else:
		hover_item.hide()
		
	if Globals.inventory[Globals.selected_slot]['count'] > 0:
		value.text = "[center]" + item['name'] + " - Count: " + str(Globals.inventory[Globals.selected_slot]['count']) + " Total Worth: $" + str(item['worth'] * Globals.inventory[Globals.selected_slot]['count'])
		cool.disabled = false
	else:
		value.text = "[center]Select and item..."
		cool.disabled = true
		
func _on_no_cool_pressed() -> void:
	get_tree().paused = false
	close()
	get_tree().change_scene_to_file("res://scenes/rich_plaza.tscn")
