extends Node

signal slot_selected

var money : int = 0
var trash_amount : int = 40

#INVENTORY
var inventory_slots : int = 3
var selected_slot : int = 0

var items : Array[Dictionary] = [
	{'name': "Tissue", 'coords': Vector2i(0,0), 'chance': 0.4},
	{'name': "Cup", 'coords': Vector2i(1,0), 'chance': 0.3},
	{'name': "Soda Can", 'coords': Vector2i(2,0), 'chance': 0.25},
	{'name': "Water Bottle", 'coords': Vector2i(3,0), 'chance': 0.3},
	{'name': "Smelly Sock", 'coords': Vector2i(0,1), 'chance': 0.25},
	{'name': "Candy Wrapper", 'coords': Vector2i(1,1), 'chance': 0.15},
	{'name': "Poopy haha", 'coords': Vector2i(2,1), 'chance': 0.1},
	{'name': "Child", 'coords': Vector2i(3,1), 'chance': 0.01},
	{'name': "Bone", 'coords': Vector2i(0,2), 'chance': 0.04},
	{'name': "Broken CD", 'coords': Vector2i(1,2), 'chance': 0.05},
	{'name': "Fish Bone", 'coords': Vector2i(2,2), 'chance': 0.1},
	{'name': "Evil Child", 'coords': Vector2i(3,2), 'chance': 0.001},
	{'name': "Glove", 'coords': Vector2i(0,3), 'chance': 0.1},
	{'name': "Fries", 'coords': Vector2i(1,3), 'chance': 0.05},
	{'name': "Rat", 'coords': Vector2i(2,3), 'chance': 0.05},
	{'name': "Photo", 'coords': Vector2i(3,3), 'chance': 0.025},
]

var inventory : Array[Dictionary] = [
	{'id': 1, 'count': 1},
	{'id': 3, 'count': 0},
	{'id': 5, 'count': 3},
	{'id': 0, 'count': 1},
	{'id': 0, 'count': 1},
	{'id': 0, 'count': 1},
	{'id': 0, 'count': 1},
	{'id': 0, 'count': 1},
	{'id': 0, 'count': 1},
]

#CONDITIONS
var in_settings : bool = false
var in_game : bool = false

#SETTINGS
var master_volume : float = 0

#get random item int based on percentages
func get_item_with_chance() -> int:
	for i in range(len(Globals.items)):
		if randf_range(0.0, 1.0) <= Globals.items[i]['chance']:
			return i
	return 0 #in case big bug crash

func _input(event: InputEvent) -> void:
	#sets selected_slot to number keys
	if Input.is_action_just_pressed("1"):
		selected_slot = 0
	if Input.is_action_just_pressed("2"):
		selected_slot = 1
	if Input.is_action_just_pressed("3"):
		selected_slot = 2
	if Input.is_action_just_pressed("4"):
		selected_slot = 3
	if Input.is_action_just_pressed("5"):
		selected_slot = 4
	if Input.is_action_just_pressed("6"):
		selected_slot = 5
	if Input.is_action_just_pressed("7"):
		selected_slot = 6
	if Input.is_action_just_pressed("8"):
		selected_slot = 7
	if Input.is_action_just_pressed("9"):
		selected_slot = 8
		
	#sets selected_slot to scroll wheel
	if Input.is_action_just_released("scroll_up"):
		selected_slot += 1
	if Input.is_action_just_released("scroll_down"):
		selected_slot -= 1
		
	#loop selected_slot if > or < inventory_slots
	selected_slot = posmod(selected_slot, inventory_slots)
	
	#updates the slots
	emit_signal("slot_selected")
