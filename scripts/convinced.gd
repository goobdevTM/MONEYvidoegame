extends Control

@export var convinced : bool = true

@onready var rich_person_minigame: Node2D = $"../.."
@onready var earnings: RichTextLabel = $Earnings
@onready var anim: AnimationPlayer = $ConvincedAnim
@onready var customer_satisfaction: HSlider = $"../CustomerSatisfaction"
@onready var kaching: AudioStreamPlayer = $"../../Kaching"
@onready var boowomp: AudioStreamPlayer = $"../../Boowomp"
@onready var button: Button = $Earnings/Continue
@onready var fade: Fade = $"../../Fade"


func start() -> void:
	anim.play("show")
	if convinced:
		var mult : float = (0.75 + (float(Globals.rich_difficulty) / 4.0))
		var gain : int = int(((Globals.items[Globals.item_selling['id']]['worth'] * Globals.item_selling['count']) * (1 + (rich_person_minigame.satisfaction / customer_satisfaction.max_value))) * mult)
		Globals.money += gain
		earnings.text = "[center]+ $" + str(gain) + " Earned!"
		Globals.inventory[Globals.item_selling['slot']]['count'] = 0
	else:
		earnings.text = '[center]"GET OUT!!!" - the customer'
	
	
func _on_continue_pressed() -> void:
	button.disabled = true
	if convinced:
		kaching.play()
	else:
		boowomp.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	fade.fade_out(preload("uid://cwq0qr0p3gujk"))
