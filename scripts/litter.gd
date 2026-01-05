extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite

var type : int = 0
var old : bool = false
var percentages : Array[float] = [
	0.25,
	0.05,
	0.1,
	0.25,
	0.2,
	0.2,
	0.3,
	0.2
]

enum Types {
	CANDY_WRAPPER,
	PLUSHIE,
	POOP,
	SOCK,
	SODA_CAN,
	SODA_CUP,
	TISSUE,
	WATER_BOTTLE,
}

func _ready() -> void:
	
	for i in range(Types.size()):
		if randf_range(0.0, 1.0) <= percentages[i]:
			type = i
	
	#ANIMATION
	var randi_bool: int = randi_range(0, 1)
	sprite.flip_h = bool(randi_bool)
	sprite.rotation = deg_to_rad(randi_range(0, 4) * 90)
	sprite.play(str(Types.find_key(type)))

#DELETES ITS SELF IF IT COLLIDES WITH OTHER TRASH
func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()
