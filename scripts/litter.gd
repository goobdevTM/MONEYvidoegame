extends Node2D

@onready var sprite: Sprite2D = $Sprite

var type : int = 0
var old : bool = false


func _ready() -> void:
	
	for i in range(len(Globals.items)):
		if randf_range(0.0, 1.0) <= Globals.items[i]['chance']:
			type = i
	
	#ANIMATION
	var randi_bool: bool = bool(randi_range(0, 1))
	sprite.flip_h = randi_bool
	sprite.rotation = deg_to_rad(randi_range(0, 4) * 90)
	print(Globals.items[type])
	sprite.texture = sprite.texture.duplicate()
	sprite.texture.region = Rect2(Globals.items[type]['coords'] * 8, Vector2(8,8))

#DELETES ITS SELF IF IT COLLIDES WITH OTHER TRASH
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("trash"):
		queue_free()
