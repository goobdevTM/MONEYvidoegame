extends Node

signal slot_selected
signal next_day

#TRASH STUFF
var trash_amount : int = 40
#	WILL BE MAX IN A RANDI RANGE
var rat_rarity : int = 12


var first_interaction_with_garby: bool = true

#ALSO UPGRADES
var upgrade_multipliers: Dictionary[String, float] = {
	"money_multiplier": 1,
	"player_base_speed": 1000,
	"trash_speed_multiplier": 1,
	"trash_density_multiplier": 1,
	"rat_speed_multiplier": 1,
	"stamina_max": 100,
	"player_base_sprint_speed": 800,
}

#UPGRADES
var upgrades: Array[Dictionary] = [
	{"name": "Speed", "base_cost": 50, "var": upgrade_multipliers["player_base_speed"], "cost_multiplier": 1.15, "upgrade_amount": 100, "description": "Makes you quicker.", "texture": preload("uid://bfwlc8spvq4i1")},
	{"name": "Stamina", "base_cost": 40, "var": upgrade_multipliers["stamina_max"], "cost_multiplier": 1.1, "upgrade_amount": 5, "description": "You'll be able to sprint longer.", "texture": preload("uid://bfwlc8spvq4i1")},
	{"name": "Money", "base_cost": 100, "var": upgrade_multipliers["money_multiplier"], "cost_multiplier": 1.2, "upgrade_multiplier": 1.05, "description": "You'll make more money overall.", "texture": preload("res://sprites/money_upgrade.png")},
	{"name": "Opening Trash", "base_cost": 50, "var": upgrade_multipliers["trash_speed_multiplier"], "cost_multiplier": 1.1, "upgrade_amount": 1, "description": "You can open trash containers quicker.", "texture": preload("res://sprites/small_garbage_bag.png")},
	{"name": "Trash Density", "base_cost": 100, "var": upgrade_multipliers["trash_density_multiplier"], "cost_multiplier": 1.15, "upgrade_amount": 5, "description": "More trash will spawn.", "texture": preload("res://sprites/small_garbage_bag.png")},
	{"name": "Rat Speed", "base_cost": 30, "var": upgrade_multipliers["rat_speed_multiplier"], "cost_multiplier": 1.05, "upgrade_amount": 100, "description": "Rats will be quicker", "texture": preload("res://sprites/rat_upgrade.png")},
	{"name": "Sprint Speed", "base_cost": 50, "var": upgrade_multipliers["player_base_sprint_speed"], "cost_multiplier": 1.1, "upgrade_amount": 50, "description": "Your sprint speed will be quicker.", "texture": preload("uid://bfwlc8spvq4i1")},

]

var garby_dialogue: Dictionary = {
	"first_encounter": [
		"Ay there! Im Garbyy. But you can call me Garbo, Garbonzo bean, or even Garboggle!",
		"Anyways nice alley-way ya got here! I think I might stay a while!",
		"Oh? Ya want some advice? You wanna make some sweet moola??",
		"While theres no way better than selling to rich people! Theres plenty of garbage in the courtyard. What would you do with garbage?",
		"Sell it to rich people!! They aint that smart, so you can probably trick them into thinking its somthin worth a dime or 2!",
		"Oh ya, I almost forgot! If you give me a random piece of garbage, I'll give ya a tip! A TIP!!",
	],
	"bothered_dialogue": [
		"Thats all bud!",
		"Nothin' else to say!",
		"I have nothin' else for ya to hear!",
		"You want a lollipop or somethin??",
		"Im tired of talkin to ya, scram!",
		"Get out of here! go get sum garbage or something!",
		"Heya look.. Its a.. a giant piece a' garbage over there!! Go get it.",
		"...",
	],
	"tips": [
		"The rarer trash usually sells for more!",
		"I hear theres sum rats in those garbage bags! Who knows, they may work for ya!",
		"You can use tha computer to upgrade stuffs!",
		"You can store all ya stuff in that dumpster!",
		"That bed of yours makes time go faster!",
		"You can unlock different areas with more trash!",
		"Careful what ya say in front of them rich folks!",
	],
}

var dumpster_slots : int = 6
var max_dumpster_slots : int = 18

#RICH PERSON
var rich_person_max : int = 48
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

#INVENTORY
var inventory_slots : int = 9
var selected_slot : int = -1
var max_per_slot : int = 32
var clicked_item : Dictionary = {'id': 0, 'count': 0, 'slot': 0, 'storage': false}
var last_given_slot : bool = false

var hovered_save : int

var items : Array[Dictionary] = [
	{'name': "Tissue", 'coords': Vector2i(0,0), 'chance': 1, "worth": 1,},
	{'name': "Cup", 'coords': Vector2i(1,0), 'chance': 0.3, "worth": 2,},
	{'name': "Water Bottle", 'coords': Vector2i(3,0), 'chance': 0.3, "worth": 2,},
	{'name': "Soda Can", 'coords': Vector2i(2,0), 'chance': 0.2, "worth": 3,},
	{'name': "Smelly Sock", 'coords': Vector2i(0,1), 'chance': 0.15, "worth": 2,},
	{'name': "Candy Wrapper", 'coords': Vector2i(1,1), 'chance': 0.15, "worth": 5,},
	{'name': "Fish Bone", 'coords': Vector2i(2,2), 'chance': 0.1, "worth": 8,},
	{'name': "Glove", 'coords': Vector2i(0,3), 'chance': 0.1, "worth": 5,},
	{'name': "Poopy haha", 'coords': Vector2i(2,1), 'chance': 0.08, "worth": 0,},
	{'name': "Banana Peel", 'coords': Vector2i(2,3), 'chance': 0.04, "worth": 3,},
	{'name': "Bone", 'coords': Vector2i(0,2), 'chance': 0.04, "worth": 8,},
	{'name': "Broken CD", 'coords': Vector2i(1,2), 'chance': 0.03, "worth": 10,},
	{'name': "Photo", 'coords': Vector2i(3,3), 'chance': 0.02, "worth": 10,},
	{'name': "Child", 'coords': Vector2i(3,1), 'chance': 0.008, "worth": 25,},
	{'name': "Evil Child", 'coords': Vector2i(3,2), 'chance': 0.0005, "worth": 250,},
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

var storage : Array[Dictionary] = []

#CONDITIONS
var in_settings : bool = false
var in_game : bool = false
var in_storage : bool = false
var in_smellizon : bool = false
var in_help : bool = false

#SETTINGS
var stamina_bar_opacity: float = 1
#	AUDIO
var master_volume : float = 50
var sound_volume : float = 50
var music_volume : float = 50


#UI
var click_sound : AudioStreamPlayer = AudioStreamPlayer.new()
var hover_sound : AudioStreamPlayer = AudioStreamPlayer.new()

#GAME
#SAVE RELATED VARIABLES SET LATER
var working_rats : int = 0
var money : int = 0
var time : float = 720.0 #day length / 2
var day : int = 0
var sleeping : bool = false
var first_time_minigame : bool = true
var start_pos : Vector2 = Vector2(0, 0) #where player spawns
const day_length : float = 1440.0 #seconds
var rich_person_name : String = ""
var question_speed_mult : float = 0.5

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
	
	file.store_var(first_interaction_with_garby)
	file.store_var(sound_volume)
	file.store_var(music_volume)
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
	saves[save]['first_time_minigame'] = first_time_minigame
	
#LOAD SAVES VARIALBLELY
func load_saves(save : int) -> void:
	if not saves[save] == {}: #check if not save empty
		working_rats = saves[save]['working_rats']
		money = saves[save]['money']
		time = saves[save]['time']
		day = saves[save]['day']
		first_time_minigame = saves[save]['first_time_minigame']
		inventory = saves[save]['inventory']
		storage = saves[save]['storage']
	else: #else reset
		#STARTING VALUES
		working_rats = 0
		money = 0
		dumpster_slots = 6
		inventory_slots = 3
		first_interaction_with_garby = true
		time = day_length / 2
		day = 0
		first_time_minigame = true
		inventory = [
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

		storage = []
	
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
func get_item_with_chance(lucky_multiplier : int = 1) -> int:
	
	var to_return: int = 0
	
	for i in range(len(Globals.items)):
		if randf_range(0.0, 1.0 / lucky_multiplier) <= Globals.items[i]['chance']:
			to_return = i
	return to_return
	


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
