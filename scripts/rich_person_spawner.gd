extends Node2D

const RICH_PERSON = preload("uid://8fkuapxu0pm6")

var y_limit: int = 176
var x_limit: int = 240

func _ready() -> void:
	for i in randi_range(Globals.rich_person_max / 2, Globals.rich_person_max):
		var rich_clone = RICH_PERSON.instantiate()
		add_child(rich_clone)
		rich_clone.position = Vector2(randi_range(-x_limit, x_limit), randi_range(-y_limit, y_limit))
