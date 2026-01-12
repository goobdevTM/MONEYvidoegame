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
@onready var kaching: AudioStreamPlayer = $"../../Kaching"


func _ready() -> void:
	Globals.max_per_slot = Globals.get_upgrade_value(7)
	Globals.dumpster_slots = Globals.get_upgrade_value(6)
	Globals.inventory_slots = Globals.get_upgrade_value(5)
	money.text = "[right]$" + str(int(Globals.money))
	cost = int(Globals.upgrades[upgrade]["base_cost"] * (Globals.upgrades[upgrade]["cost_multiplier"] * (Globals.upgrades[upgrade]["times_upgraded"] + 1)))
	print(Globals.upgrades[upgrade]["texture"])
	sprite.texture = Globals.upgrade_textures[Globals.upgrades[upgrade]["texture"]]
	print("TEXTURE: " + str(Globals.upgrades[upgrade]["texture"]) + " UPGRADE: " + str(upgrade))
	name_text.text = Globals.upgrades[upgrade]["name"]
	description_text.text = Globals.upgrades[upgrade]["description"]
	cost_text.text = "[center]$" + str(int(cost))

func _pressed() -> void:
	if Globals.money >= cost:
		kaching.play()
		Globals.money -= Globals.upgrades[upgrade]["base_cost"]
		cost *= Globals.upgrades[upgrade]["cost_multiplier"]
		
		if Globals.upgrades[upgrade].has("upgrade_amount"):
			Globals.upgrades[upgrade]["var"] += Globals.upgrades[upgrade]["upgrade_amount"]
		else:
			Globals.upgrades[upgrade]["var"] *= Globals.upgrades[upgrade]["upgrade_multiplier"]
		Globals.upgrades[upgrade]["times_upgraded"] += 1
		upgrade_menu.set_buttons()
	else:
		piano_slam.play()
	_ready()
	
