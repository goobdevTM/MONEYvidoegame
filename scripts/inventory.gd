extends CanvasLayer

@onready var h_box_container: HBoxContainer = $Control/HBoxContainer
@onready var slot: Control = $Control/Slot

func _ready() -> void:
	#CREATES INVENTORY
	for i in range(Globals.inventory_slots):
		var clone_slot: Control = slot.duplicate()
		h_box_container.add_child(clone_slot)
		clone_slot.show()
		clone_slot.index = i + 1
		clone_slot.get_child(0).text = str(clone_slot.index)
