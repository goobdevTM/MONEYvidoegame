extends Node2D

const RICH_PERSON = preload("uid://8fkuapxu0pm6")

var y_limit: int = 176
var x_limit: int = 240

@onready var pop: AudioStreamPlayer = $"../../Pop"

func _ready() -> void:
	if (Globals.time < (Globals.day_length / 2) + ((Globals.day_length / 24) * 7) and Globals.time > (Globals.day_length / 2) - ((Globals.day_length / 24) * 5)):
		Globals.has_rich_people = true
		for i in Globals.rich_person_max:
			var rich_clone = RICH_PERSON.instantiate()
			add_child(rich_clone)
			rich_clone.position = Vector2(randi_range(-x_limit, x_limit), randi_range(-y_limit, y_limit))
	else:
		Globals.has_rich_people = false
		while not (Globals.time < (Globals.day_length / 2) + ((Globals.day_length / 24) * 7) and Globals.time > (Globals.day_length / 2) - ((Globals.day_length / 24) * 5)):
			await get_tree().create_timer(1).timeout
		pop.play()
		for i in Globals.rich_person_max:
			var rich_clone = RICH_PERSON.instantiate()
			add_child(rich_clone)
			rich_clone.position = Vector2(randi_range(-x_limit, x_limit), randi_range(-y_limit, y_limit))
