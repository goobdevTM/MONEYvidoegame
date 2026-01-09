extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.in_game = true
	Globals.emit_signal("slot_selected")
