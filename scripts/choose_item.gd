extends Control

const SLOT = preload("uid://ep7xcgg7p76x")

@onready var h_box_container: HBoxContainer = $Control/HBoxContainer
@onready var bg: ColorRect = $BG


func _ready() -> void:
	get_tree().paused = true
	show()

func spawn_items() -> void:
	for i in range(Globals.inventory_slots):
		var clone_slot: Control = SLOT.instantiate()
		h_box_container.add_child(clone_slot)
		clone_slot.slot_bg.play("inventory")
		clone_slot.show()
		clone_slot.index = i
		clone_slot.get_child(0).text = str(clone_slot.index + 1)
		
func close() -> void:
	
	Globals.in_help = false
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	
	hide()
	get_tree().paused = false
