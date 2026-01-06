extends Camera2D

@onready var player: Player = $"../Level/TrashSpawner/Player"
@onready var ground: TileMapLayer = $"../Level/Ground"
@onready var noise_overlay: Node2D = $"../Level/NoiseOverlay"
@onready var level: Level = $"../Level"
@onready var delete_trash: Area2D = $"../Level/DeleteTrash"

var max_distance_from_spawn : int = 0
var old_distance_calc : int = 0
var new_distance_calc : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#move slowly towards player
	if player.direction:
		position = lerp(position, player.position + (player.direction.normalized() * 16), delta * 6)
	#infinite ground loop
	noise_overlay.position.x = floor(position.x / 384) * 384
	ground.position = floor(position / 64) * 64
	delete_trash.position.x = floor(position.x / 256) * 256
	
	#check if area ahead needs to be generated
	new_distance_calc = floor((position.x + 128) / 256)
	if new_distance_calc > max_distance_from_spawn:
		
		max_distance_from_spawn = new_distance_calc
		
	#generate
	if not new_distance_calc == old_distance_calc:
		if new_distance_calc < old_distance_calc:
			level.generate_trash((new_distance_calc * 256) - (256*1))
		else:
			level.generate_trash(new_distance_calc * 256)
		
	old_distance_calc = new_distance_calc
	
