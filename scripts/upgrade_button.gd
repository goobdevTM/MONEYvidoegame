extends Button

var upgrade: int = 0
var cost: float

@onready var piano_slam: AudioStreamPlayer = $"../../PianoSlam"
@onready var sprite: Sprite2D = $"../Button3/Sprite2D"
@onready var name_text: RichTextLabel = $"../Button3/Name"
@onready var description_text: RichTextLabel = $"../Button3/Description"
@onready var cost_text: RichTextLabel = $"../Button3/Cost"
@onready var money: RichTextLabel = $"../../Money"

func _ready() -> void:
	money.text = "[right]$" + str(Globals.money)
	if Globals.upgrades[upgrade].has("upgrade_amount"): #add
		cost = int(Globals.upgrades[upgrade]["base_cost"] + (Globals.upgrades[upgrade]["upgrade_amount"] * Globals.upgrades[upgrade]["times_upgraded"]))
	else: #multiply
		cost = int(Globals.upgrades[upgrade]["base_cost"] * (Globals.upgrades[upgrade]["upgrade_multiplier"] * Globals.upgrades[upgrade]["times_upgraded"]))
	sprite.texture = Globals.upgrades[upgrade]["texture"]
	name_text.text = Globals.upgrades[upgrade]["name"]
	description_text.text = Globals.upgrades[upgrade]["description"]
	cost_text.text = "[center]$" + str(cost)

func _pressed() -> void:
	if Globals.money >= cost:
		
		Globals.money -= Globals.upgrades[upgrade]["base_cost"]
		cost *= Globals.upgrades[upgrade]["cost_multiplier"]
		
		if Globals.upgrades[upgrade].has("upgrade_amount"):
			Globals.Globals.upgrades[upgrade]["var"] += Globals.upgrades[upgrade]["upgrade_amount"]
		else:
			Globals.Globals.upgrades[upgrade]["var"] *= Globals.upgrades[upgrade]["upgrade_amount"]
	else:
		piano_slam.play()
	_ready()
