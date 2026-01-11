extends CanvasLayer

@onready var music: AudioStreamPlayer = $Panel/Music
@onready var settings: CanvasLayer = $"../Settings"
@onready var h_box_container: HBoxContainer = $Panel/HBoxContainer
@onready var reload: Button = $Panel/Reload
@onready var piano_slam: AudioStreamPlayer = $Panel/PianoSlam

var reload_cost: int = 10

func _ready() -> void:
	set_buttons()

func set_buttons():
	for i in h_box_container.get_children():
		var upgrade: int = randi_range(0, len(Globals.upgrades) - 1)
		
		i.upgrade = upgrade
		i.get_child(2).texture = Globals.upgrades[upgrade]["texture"]
		i.get_child(3).text = Globals.upgrades[upgrade]["name"]
		i.get_child(0).text = Globals.upgrades[upgrade]["description"]
		i.get_child(4).text = "[center]" + str(Globals.upgrades[upgrade]["base_cost"]) + "$"

func open() -> void:
	music.play()
	if Globals.in_settings:
		Globals.in_settings = false
		settings.close()
	get_tree().paused = true
	show()
	
	#control.position = Vector2(0,480)
	#bg.modulate.a = 0
	
	#var tween : Tween = create_tween()
	#tween.set_parallel()
	#tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.502), 0.1)
	#tween.tween_property(control, "position", Vector2(0,0), 0.1)
	
	#await tween.finished
	#inventory.h_box_container.hide()
	#opening_storage = false
	
func close() -> void:
	music.stop()
	
	#var tween : Tween = create_tween()
	#tween.set_parallel()
	#tween.tween_property(bg, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.1)
	#tween.tween_property(control, "position", Vector2(0,480), 0.1)
	
	hide()
	get_tree().paused = false


func _on_reload_pressed() -> void:
	if Globals.money >= reload_cost:
		Globals.money -= reload_cost
		set_buttons()
	else:
		piano_slam.play()

func _on_exit_pressed() -> void:
	close()
