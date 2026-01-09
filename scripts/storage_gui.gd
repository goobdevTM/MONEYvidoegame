extends CanvasLayer

const SLOT = preload("uid://ep7xcgg7p76x")

@onready var bg: ColorRect = $BG
@onready var control: Control = $Control
@onready var settings: CanvasLayer = $"../Settings"
@onready var grid_container: GridContainer = $Control/Storage/GridContainer
@onready var h_box_container: HBoxContainer = $Control/Inventory/HBoxContainer
@onready var inventory: CanvasLayer = $"../INVENTORY"
@onready var hover_item: Sprite2D = $Control/HoverItem


var opening_storage : bool = false

func _ready() -> void:
	Globals.in_storage = false
	hide()
	
	#CREATES STORAGE
	for i in range(len(Globals.storage)):
		var clone_slot: Control = SLOT.instantiate()
		clone_slot.storage = true
		clone_slot.from_storage_menu = true
		grid_container.add_child(clone_slot)
		clone_slot.show()
		clone_slot.index = i
		clone_slot.get_child(0).text = str(clone_slot.index + 1)
		
	#CREATES INVENTORY
	for i in range(Globals.inventory_slots):
		var clone_slot: Control = SLOT.instantiate()
		clone_slot.from_storage_menu = true
		h_box_container.add_child(clone_slot)
		clone_slot.show()
		clone_slot.index = i
		clone_slot.get_child(0).text = str(clone_slot.index + 1)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings") or Input.is_action_just_pressed("pickup") and Globals.in_storage and not opening_storage:
		close()
	if Globals.clicked_item['count'] > 0:
		hover_item.show()
		hover_item.get_child(0).text = "[right]x" + str(Globals.clicked_item['count'])
		hover_item.position = get_viewport().get_mouse_position()
	else:
		hover_item.hide()
	
func open() -> void:
	opening_storage = true
	if Globals.in_settings:
		Globals.in_settings = false
		settings.close()
	get_tree().paused = true
	control.position = Vector2(0,480)
	bg.modulate.a = 0
	show()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.502), 0.1)
	tween.tween_property(control, "position", Vector2(0,0), 0.1)
	Globals.in_storage = true
	Globals.emit_signal("slot_selected")
	await get_tree().create_timer(0).timeout
	Globals.emit_signal("slot_selected")
	await tween.finished
	inventory.h_box_container.hide()
	opening_storage = false
	Globals.emit_signal("slot_selected")
	
func close() -> void:
	if Globals.selected_slot >= Globals.inventory_slots:
		Globals.selected_slot = 0
	show()
	inventory.h_box_container.show()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	tween.tween_property(control, "position", Vector2(0,480), 0.1)
	Globals.emit_signal("slot_selected")
	await get_tree().create_timer(0).timeout
	Globals.emit_signal("slot_selected")
	await tween.finished
	hide()
	get_tree().paused = false
	Globals.in_storage = false
	Globals.emit_signal("slot_selected")
