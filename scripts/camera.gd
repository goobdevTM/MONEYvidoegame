extends Camera2D

@export var generate_trash : bool = false
@export var player: Player
@onready var ground: TileMapLayer = $"../Level/Ground"
@onready var noise_overlay: Node2D = $"../Level/NoiseOverlay"
@onready var level: Node2D = $"../Level"
@onready var delete_trash: Area2D = $"../Level/DeleteTrash"
@onready var bushes: TileMapLayer = $"../Level/Bushes"
@onready var fence: TileMapLayer = $"../Level/Fence"

var max_distance_from_spawn : int = 0
var old_distance_calc : int = 0
var new_distance_calc : int = 0

func _ready() -> void:
	#start at player
	if generate_trash:
		new_distance_calc = floor((player.global_position.x + 128) / 256)
		old_distance_calc = new_distance_calc
	await get_tree().create_timer(0).timeout
	global_position = player.global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#move slowly towards player
	if player.direction:
		position = lerp(position, player.position + (player.direction.normalized() * 16), delta * 6)
	#infinite THINGIE loop
	ground.position = floor(position / 64) * 64
	if noise_overlay:
		noise_overlay.position.x = floor(position.x / 384) * 384
	if fence:
		fence.position.x = floor(position.x / 32) * 32
	if bushes:
		bushes.position.x = floor(position.x / 32) * 32
	if delete_trash:
		delete_trash.position.x = floor(position.x / 256) * 256
	
	if generate_trash:
		#check if area ahead needs to be generated
		new_distance_calc = floor((position.x + 128) / 256)
		if new_distance_calc > max_distance_from_spawn:
			
			max_distance_from_spawn = new_distance_calc
			
		#generate
		if not new_distance_calc == old_distance_calc and new_distance_calc >= 0:
			if new_distance_calc < old_distance_calc:
				level.generate_trash((new_distance_calc * 256) - (256*1))
			else:
				level.generate_trash(new_distance_calc * 256)
			
		old_distance_calc = new_distance_calc
	
