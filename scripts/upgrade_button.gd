extends Button

var upgrade: int
var cost: float

@onready var piano_slam: AudioStreamPlayer = $"../../PianoSlam"

func _pressed() -> void:
	cost = Globals.upgrades[upgrade]["base_cost"]
	
	if Globals.money >= cost:
		
		Globals.money -= Globals.upgrades[upgrade]["base_cost"]
		cost *= Globals.upgrades[upgrade]["cost_multiplier"]
		
		if Globals.upgrades[upgrade].has("upgrade_amount"):
			Globals.Globals.upgrades[upgrade]["var"] += Globals.upgrades[upgrade]["upgrade_amount"]
		else:
			Globals.Globals.upgrades[upgrade]["var"] *= Globals.upgrades[upgrade]["upgrade_amount"]
	else:
		piano_slam.play()
