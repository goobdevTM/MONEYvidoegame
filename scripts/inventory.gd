extends CanvasLayer

@onready var h_box_container: HBoxContainer = $Control/HBoxContainer
const SLOT = preload("uid://ep7xcgg7p76x")


func _ready() -> void:
	#CREATES INVENTORY
	for i in range(Globals.inventory_slots):
		var clone_slot: Control = SLOT.instantiate()
		h_box_container.add_child(clone_slot)
		clone_slot.show()
		clone_slot.index = i
		clone_slot.get_child(0).text = str(clone_slot.index + 1)
