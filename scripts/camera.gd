extends Camera2D

@onready var player: Player = $"../Player"
@onready var ground: TileMapLayer = $"../Level/Ground"
@onready var noise_overlay: Node2D = $"../Level/NoiseOverlay"
@onready var level: Level = $"../Level"

var distance_from_spawn : int = 0
var new_distance_calc : int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#move slowly towards player
	if player.direction:
		position = lerp(position, player.position + (player.direction.normalized() * 16), delta * 6)
	#infinite ground loop
	noise_overlay.position.x = floor(position.x / 384) * 384
	ground.position = floor(position / 64) * 64
	
	#check if area ahead needs to be generated
	new_distance_calc = floor((position.x + 128) / 768)
	if new_distance_calc > distance_from_spawn:
		
		distance_from_spawn = new_distance_calc
		
		#generate
		level.generate_trash(distance_from_spawn * 768)
	
