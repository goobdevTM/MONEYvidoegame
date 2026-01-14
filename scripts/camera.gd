extends Camera2D

@export var generate_trash : bool = false
@export var player: Player
@onready var ground: TileMapLayer = $"../Level/Ground"
@onready var noise_overlay: Node2D = $"../Level/NoiseOverlay"
@onready var level: Node2D = $"../Level"
@onready var bushes: TileMapLayer = $"../Level/Bushes"
@onready var fence: TileMapLayer = $"../Level/Fence"
@onready var buy_area: Node2D = $"../Level/RightBorder/BuyArea"
@onready var left_delete: CollisionShape2D = $"../Level/DeleteTrash/LeftDelete"
@onready var right_delete: CollisionShape2D = $"../Level/DeleteTrash/RightDelete"
@onready var delete_trash: Area2D = $"../Level/DeleteTrash"




var max_distance_from_spawn : int = -1
var min_distance_from_spawn : int = -1
var old_distance_calc : int = -1
var new_distance_calc : int = -1

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
	position = lerp(position, player.position, delta * 8)
	#infinite THINGIE loop
	ground.position = floor(position / 64) * 64
	if noise_overlay:
		noise_overlay.position.x = floor(position.x / 384) * 384
	if fence:
		fence.position.x = floor(position.x / 16) * 16
	if bushes:
		bushes.position.x = floor(position.x / 32) * 32
	
	if generate_trash:
		#check if area ahead needs to be generated
		new_distance_calc = floor((position.x + 128) / 256)
		if new_distance_calc > max_distance_from_spawn:
			max_distance_from_spawn = new_distance_calc
		if new_distance_calc < min_distance_from_spawn:
			min_distance_from_spawn = new_distance_calc
		#generate
		if not new_distance_calc == old_distance_calc and new_distance_calc >= 0:
			if new_distance_calc < old_distance_calc:
				if new_distance_calc < max_distance_from_spawn:
					left_delete.global_position.x = (new_distance_calc * 256)
					left_delete.disabled = false
					right_delete.global_position.x = (new_distance_calc * 256) + 512
					right_delete.disabled = false
					level.thread_generate_trash((new_distance_calc * 256) - (256*1))
					
					max_distance_from_spawn = new_distance_calc + 1
			else:
				if new_distance_calc > min_distance_from_spawn:
					right_delete.global_position.x = (new_distance_calc * 256)
					right_delete.disabled = false
					left_delete.global_position.x = (new_distance_calc * 256) - 512
					left_delete.disabled = false
					level.thread_generate_trash(new_distance_calc * 256)
					
					min_distance_from_spawn = new_distance_calc
		#buy text
		buy_area.position.y = position.y - 64
		buy_area.position.y = clamp(buy_area.position.y, -260, 140)
			
		old_distance_calc = new_distance_calc
