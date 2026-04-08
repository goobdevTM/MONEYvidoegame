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
	for i in range(10):
		while (upgrade == 7 and Globals.get_upgrade_value(7) >= Globals.max_dumpster_slots) or (upgrade == 6 and Globals.get_upgrade_value(6) >= 9):
			upgrade = randi_range(0,len(Globals.upgrades) - 1)
			
		Globals.max_per_slot = Globals.get_upgrade_value(8)
		Globals.dumpster_slots = Globals.get_upgrade_value(7)
		Globals.inventory_slots = Globals.get_upgrade_value(6)
		money.text = "[right]$" + str(int(Globals.money))
		cost = int(Globals.upgrades[upgrade]["base_cost"] * (Globals.upgrades[upgrade]["cost_multiplier"] * (Globals.upgrades[upgrade]["times_upgraded"] + 1)))
		sprite.texture = Globals.upgrade_textures[Globals.upgrades[upgrade]["texture"]]
		name_text.text = Globals.upgrades[upgrade]["name"]
		description_text.text = Globals.upgrades[upgrade]["description"]
		cost_text.text = "[center]$" + str(int(cost))
		await get_tree().create_timer(0).timeout
		
func _pressed() -> void:
	cost = int(Globals.upgrades[upgrade]["base_cost"] * (Globals.upgrades[upgrade]["cost_multiplier"] * (Globals.upgrades[upgrade]["times_upgraded"] + 1)))
	if Globals.money >= cost:
		kaching.play()
		Globals.money -= cost
		Globals.upgrades[upgrade]["times_upgraded"] += 1
		upgrade_menu.set_buttons()
	else:
		piano_slam.play()
	_ready()
	
