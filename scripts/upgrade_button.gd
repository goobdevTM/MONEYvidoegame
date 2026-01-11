extends Button

var upgrade: int = 0
var cost: float

@onready var piano_slam: AudioStreamPlayer = $"../../PianoSlam"
@onready var sprite: Sprite2D = $Sprite2D
@onready var name_text: RichTextLabel = $Name
@onready var description_text: RichTextLabel = $Description
@onready var cost_text: RichTextLabel = $Cost
@onready var money: RichTextLabel = $"../../Money"
@onready var upgrade_menu: CanvasLayer = $"../../.."
@onready var kaching: AudioStreamPlayer = $Kaching


func _ready() -> void:
	money.text = "[right]$" + str(int(Globals.money))
	cost = int(Globals.upgrades[upgrade]["base_cost"] * (Globals.upgrades[upgrade]["cost_multiplier"] * (Globals.upgrades[upgrade]["times_upgraded"] + 1)))
	print(Globals.upgrades[upgrade]["texture"])
	sprite.texture = Globals.upgrades[upgrade]["texture"]
	name_text.text = Globals.upgrades[upgrade]["name"]
	description_text.text = Globals.upgrades[upgrade]["description"]
	cost_text.text = "[center]$" + str(int(cost))

func _pressed() -> void:
	if Globals.money >= cost:
		
		Globals.money -= Globals.upgrades[upgrade]["base_cost"]
		cost *= Globals.upgrades[upgrade]["cost_multiplier"]
		
		if Globals.upgrades[upgrade].has("upgrade_amount"):
			Globals.upgrades[upgrade]["var"] += Globals.upgrades[upgrade]["upgrade_amount"]
		else:
			Globals.upgrades[upgrade]["var"] *= Globals.upgrades[upgrade]["upgrade_multiplier"]
		Globals.upgrades[upgrade]["times_upgraded"] += 1
		upgrade_menu.set_buttons()
		kaching.play()
	else:
		piano_slam.play()
	_ready()
	
