extends Control

@export var convinced : bool = true

@onready var rich_person_minigame: Node2D = $"../.."
@onready var earnings: RichTextLabel = $Earnings
@onready var anim: AnimationPlayer = $ConvincedAnim
@onready var customer_satisfaction: HSlider = $"../CustomerSatisfaction"


func start() -> void:
	anim.play("show")
	if convinced:
		var mult : float = (0.75 + (float(Globals.rich_difficulty) / 4.0))
		var gain : int = int(((Globals.items[Globals.item_selling['id']]['worth'] * Globals.item_selling['count']) * (1 + (rich_person_minigame.satisfaction / customer_satisfaction.max_value))) * mult)
		Globals.money += gain
		earnings.text = "[center]+ $" + str(gain) + " Earned!"
	else:
		earnings.text = '"GET OUT!!!" - the customer'
	Globals.inventory[Globals.item_selling['slot']]['count'] = 0
	
func _on_continue_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/rich_plaza.tscn")
