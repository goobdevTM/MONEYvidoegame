class_name Litter

extends Node2D

@onready var sprite: Sprite2D = $Sprite


var type : int = -1
var old : bool = false
var rat_spawned : bool = false

signal picked_up

func _ready() -> void:
	
	hide()
	
	if type == -1:
		if rat_spawned:
			type = Globals.get_item_with_chance(2)
		else:
			type = Globals.get_item_with_chance(1)
	
	#ANIMATION
	var randi_bool: bool = bool(randi_range(0, 1))
	sprite.flip_h = randi_bool
	sprite.rotation = deg_to_rad(randi_range(0, 4) * 90)

		
	sprite.texture = sprite.texture.duplicate()
	sprite.texture.region = Rect2(Globals.items[type]['coords'] * 8, Vector2(8,8))
	#print if evil child spawns
	await get_tree().create_timer(0.05).timeout
	if Globals.items[type]['name'] == "Evil Child":
		print(Globals.items[type])
		print(global_position)
	#CHECKS IF ABOVE FENCE
	if global_position.y < -220:
		global_position.y = -220
		
	show()
#DELETES ITS SELF IF IT COLLIDES WITH OTHER TRASH
func _on_area_2d_area_entered(area: Area2D) -> void:
	if not rat_spawned == true:
		if area.is_in_group("trash"):
			queue_free()


#too far away from player?
func _on_delete_check_area_entered(area: Area2D) -> void:
	if not rat_spawned == true:
		queue_free()
