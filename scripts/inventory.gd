extends CanvasLayer

@onready var h_box_container: HBoxContainer = $Control/HBoxContainer
@onready var money: RichTextLabel = $Money
@onready var rats_hired: RichTextLabel = $RatsHired
@onready var time: RichTextLabel = $Time
@onready var day: RichTextLabel = $Day

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
		

func _process(delta: float) -> void:
	if Globals.working_rats > 0:
		rats_hired.text = "Rats Hired: " + str(Globals.working_rats)
	else:
		#hide if no working rats
		rats_hired.text = ""
	day.text = "[right]Day " + str(Globals.day)
	var hour : int = int(Globals.time / (Globals.day_length / 24)) % 12 + 1
	var minute : int = int(Globals.time / (Globals.day_length / 1440)) % 60
	minute = floor(minute / 5) * 5
	time.text = "[right]" + str(hour) + ":" 
	if minute < 10:
		time.text += "0"
	time.text += str(minute)
	if Globals.time > (Globals.day_length / 2) - (Globals.day_length / 24) and not (Globals.time > ((Globals.day_length / 24) * 22)):
		time.text += " PM"
	else:
		time.text += " AM"
	money.text = "$" + str(Globals.money)
