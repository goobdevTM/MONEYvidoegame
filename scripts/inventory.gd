extends CanvasLayer

@onready var h_box_container: HBoxContainer = $Control/HBoxContainer
@onready var money: RichTextLabel = $Money
@onready var rats_hired: RichTextLabel = $RatsHired
const SLOT = preload("uid://ep7xcgg7p76x")


func _ready() -> void:
	rats_hired.text = ""
	#CREATES INVENTORY
	for i in range(Globals.inventory_slots):
		var clone_slot: Control = SLOT.instantiate()
		h_box_container.add_child(clone_slot)
		clone_slot.slot_bg.play("inventory")
		clone_slot.show()
		clone_slot.index = i
		clone_slot.get_child(0).text = str(clone_slot.index + 1)

func _process(delta: float) -> void:
	if Globals.working_rats > 0:
		rats_hired.text = "[right][right]Rats Hired: " + str(Globals.working_rats)
	else:
		#hide if no working rats
		rats_hired.text = ""
	money.text = "$" + str(Globals.money)
