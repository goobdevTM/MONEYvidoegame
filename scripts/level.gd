extends Node2D

var noise: NoiseTexture2D

const TRASH = preload("uid://blwgbgbei4tsn")

func _ready() -> void:
	generate_trash(Vector2(0, 0))

#SPAWNS TRASH
func generate_trash(spawn_pos: Vector2) -> void:
	
	noise = NoiseTexture2D.new()
	noise.noise = FastNoiseLite.new()
	
	#WIDTH
	for x in range(noise.get_width()):
		#HEIGHT
		for y in range(noise.get_height()):
			
			print(noise.noise.get_noise_2d(x, y))
			if noise.noise.get_noise_2d(x, y) > 0.005:
				var trash_clone = TRASH.instantiate()
				add_child(trash_clone)
				trash_clone.position = Vector2(x, y) * 16
