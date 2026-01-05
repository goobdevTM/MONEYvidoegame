extends Node

var money : int = 0
var trash_amount : int = 150

#INVENTORY
var inventory_slots : int = 3
var selected_slot : int = 0

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("0"):
		selected_slot = 0
	if Input.is_action_just_pressed("1"):
		selected_slot = 1
	if Input.is_action_just_pressed("2"):
		selected_slot = 2
	if Input.is_action_just_pressed("3"):
		selected_slot = 3
	if Input.is_action_just_pressed("4"):
		selected_slot = 4
	if Input.is_action_just_pressed("5"):
		selected_slot = 5
	if Input.is_action_just_pressed("6"):
		selected_slot = 6
	if Input.is_action_just_pressed("7"):
		selected_slot = 7
	if Input.is_action_just_pressed("8"):
		selected_slot = 8
	if Input.is_action_just_pressed("9"):
		selected_slot = 9
