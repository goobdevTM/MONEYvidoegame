class_name Litter

extends Node2D

@onready var sprite: Sprite2D = $Sprite

var type : int = -1
var old : bool = false


func _ready() -> void:
	
	if type == -1:
		type = Globals.get_item_with_chance()
	
	#ANIMATION
	var randi_bool: bool = bool(randi_range(0, 1))
	sprite.flip_h = randi_bool
	sprite.rotation = deg_to_rad(randi_range(0, 4) * 90)

		
	sprite.texture = sprite.texture.duplicate()
	sprite.texture.region = Rect2(Globals.items[type]['coords'] * 8, Vector2(8,8))
	#print if evil child spawns
	await get_tree().create_timer(0.25).timeout
	if Globals.items[type]['name'] == "Evil Child":
		print(Globals.items[type])
		print(global_position)
		
#DELETES ITS SELF IF IT COLLIDES WITH OTHER TRASH
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("trash"):
		queue_free()


#too far away from player?
func _on_delete_check_area_entered(area: Area2D) -> void:
	queue_free()
