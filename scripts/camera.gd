extends Camera2D

@onready var player: Player = $"../Player"
@onready var ground: TileMapLayer = $"../Level/Ground"
@onready var noise_overlay: Node2D = $"../Level/NoiseOverlay"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#move slowly towards player
	if player.direction:
		position = lerp(position, player.position + (player.direction.normalized() * 16), delta * 6)
	#infinite ground loop
	noise_overlay.position.x = floor(position.x / 384) * 384
	ground.position = floor(position / 64) * 64
	
