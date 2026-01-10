extends Node

signal slot_selected
signal next_day

#TRASH STUFF
var trash_amount : int = 40
#	WILL BE MAX IN A RANDI RANGE
var rat_rarity : int = 12

var rich_person_max : int = 48

#INVENTORY
var inventory_slots : int = 9
var selected_slot : int = -1
var max_per_slot : int = 25
var clicked_item : Dictionary = {'id': 0, 'count': 0, 'slot': 0, 'storage': false}
var last_given_slot : bool = false

var roman_numerals : Array[String] = [
	"I",
	"II",
	"III",
	"IV",
	"V",
	"VI",
	"VII",
	"VIII",
	"IX",
	"X"
]

var rich_people_names : Array[String] = [
	"Stringsworth",
	"Toppenwagger",
	"Binglebottoms",
	"Bartholomeus",
	"Mozart",
	"Beethoven",
	"Gilly",
	"Wiggens",
	"Thomas",
	"Topplegoinginger",
	"Glagglewares",
	"PigFart",
	"PigeonHead",
	"Gurteth",
	"Larrytipper",
	"Flange",
	"Flangesworth",
	"Charles",
	"Charlemagne",
	"Schlongebong",
	"Homplytoopsworth",
	"Bonbon",
	"Von",
	"King",
	"Queen",
	"Crontleploppy",
	"Hoogansworth",
	"Moneysworth",
	"Richie",
	"Cashinator",
	"Frontleswoop",
	"Plungus",
	"Bart",
	"Domer",
	"Gabblyshoop",
	"Gibbysplop",
	"Slop"
]

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
	{'name': "Evil Child", 'coords': Vector2i(3,2), 'chance': 0.003},
	{'name': "Glove", 'coords': Vector2i(0,3), 'chance': 0.1},
	{'name': "Fries", 'coords': Vector2i(1,3), 'chance': 0.05},
	{'name': "Banana Peel", 'coords': Vector2i(2,3), 'chance': 0.05},
	{'name': "Photo", 'coords': Vector2i(3,3), 'chance': 0.025},
]

var inventory : Array[Dictionary] = [
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
]

var storage : Array[Dictionary] = [
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
	{'id': 0, 'count': 0},
]

#CONDITIONS
var in_settings : bool = false
var in_game : bool = false
var in_storage : bool = false

#SETTINGS
var master_volume : float = 50
var stamina_bar_opacity: float = 1

#UI
var click_sound : AudioStreamPlayer = AudioStreamPlayer.new()
var hover_sound : AudioStreamPlayer = AudioStreamPlayer.new()

#GAME
var working_rats : int = 0
var money : int = 0
var time : float = 0
var day : int = 0
var start_pos : Vector2 = Vector2(0, 0) #where player spawns
var day_length : float = 120 #seconds

#SAVE
var saves : Array[Dictionary] = [{},{},{}]
var current_save : int = 0

func _ready() -> void:
	load_data()
	process_mode = Node.PROCESS_MODE_ALWAYS

#SAVING AND LOADING
var file_path: String = "user://save_data.save"
signal loaded_data

#SET CLICK AND HOVER SOUND FOR GUI
func set_ui_sounds(parent_node : Node) -> void:
	click_sound = parent_node.get_child(0)
	hover_sound = parent_node.get_child(1)

#SAVE
func save_data():
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	file.store_var(saves)
	
	file.store_var(master_volume)
	file.store_var(stamina_bar_opacity)
	
#LOAD
func load_data():
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		
		saves = file.get_var()
		
		master_volume = file.get_var()
		stamina_bar_opacity = file.get_var()
	else:
		#ITS COOL AND MODULAR OK? DONT DELETE THIS AHG%^^&&$$BKDGSBKLGSDLKGELKMFS$$$$$
		var warning: String = "NO SAVE DATA"
		print(warning)
		return warning
	emit_signal("loaded_data")
	
#SET SAVES VARAIBALE
func set_saves(save : int) -> void:
	saves[save]['working_rats'] = working_rats
	saves[save]['money'] = money
	saves[save]['time'] = time
	saves[save]['day'] = day
	saves[save]['inventory'] = inventory
	saves[save]['storage'] = storage
	
#LOAD SAVES VARIALBLELY
func load_saves(save : int) -> void:
	if saves[save].has('working_rats'): #check if not save empty
		working_rats = saves[save]['working_rats']
		money = saves[save]['money']
		time = saves[save]['time']
		day = saves[save]['day']
		inventory = saves[save]['inventory']
		storage = saves[save]['storage']
	
	
#molodur awsoml
func save_and_quit() -> void:
	Globals.save_data()
	await get_tree().create_timer(0.05).timeout
	get_tree().quit()
	
#save when window closed
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_and_quit()

#get random item int based on percentages
func get_item_with_chance() -> int:
	for i in range(len(Globals.items)):
		if randf_range(0.0, 1.0) <= Globals.items[i]['chance']:
			return i
	return 0 #in case big bug crash
	


func _input(event: InputEvent) -> void:
	if in_game:
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
			
		#dont do scrolling if in storage
		if not selected_slot >= 9:
			#sets selected_slot to scroll wheel
			if Input.is_action_just_released("scroll_up"):
				selected_slot -= 1
				#loop selected_slot if > or < inventory_slots
				selected_slot = posmod(selected_slot, inventory_slots)
				
			if Input.is_action_just_released("scroll_down"):
				selected_slot += 1
				#loop selected_slot if > or < inventory_slots
				selected_slot = posmod(selected_slot, inventory_slots)
		
		
		#updates the slots
		emit_signal("slot_selected")
